//
//  CercaMapQuad.m
//  Cerca
//
//  Created by Peter Zion on 11/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CercaMapQuad.h"
#import "CercaMapGenerator.h"

typedef struct { unsigned char r, g, b, a; } RGBA;

@implementation CercaMapQuad

#pragma mark Private

-(NSString *) urlStringForMapType:(CercaMapType)mapType
{
	NSString *prefix;
	switch ( mapType )
	{
		case CMT_ROADS:
			prefix = @"http://r0.ortho.tiles.virtualearth.net/tiles/r";
			break;
		case CMT_ARIAL:
			prefix = @"http://a0.ortho.tiles.virtualearth.net/tiles/a";
			break;
		case CMT_HYBRID:
			prefix = @"http://h0.ortho.tiles.virtualearth.net/tiles/h";
			break;
	}
	NSString *result = [NSString stringWithFormat:@"%@%@%@%@", prefix, urlBaseString, @".jpeg?g=131&token=", token];
	return result;
}

-(CercaMapQuad *) childQuadAtRow:(int)i col:(int)j
{
	CercaMapRect childCoverage = CercaMapRectMake(
		coverage.origin.x + j*coverage.size.width/2,
		coverage.origin.y + i*coverage.size.height/2,
		coverage.size.width/2,
		coverage.size.height/2
		);
	static NSString *childURLBaseSuffixStrings[2][2] = { { @"0", @"1" }, { @"2", @"3" } };
	NSString *childURLBaseString = [NSString stringWithFormat:@"%@%@", urlBaseString, childURLBaseSuffixStrings[i][j]];
	return [[[CercaMapQuad alloc] initWithParentQuad:self
		coverage:childCoverage
		token:token
		urlBaseString:childURLBaseString
		logZoom:logZoom+1] autorelease];
}

-(CercaMapType) mapTypeForConnection:(NSURLConnection *)connection
{
	for ( CercaMapType i=0; i<CMT_NUM_TYPES; ++i )
		if ( connections[i] == connection )
			return i;
	return -1;
}

#pragma mark Lifecycle

-(id) initWithParentQuad:(CercaMapQuad *)_parentQuad
	coverage:(CercaMapRect)_coverage
	token:(NSString *)_token
	urlBaseString:(NSString *)_urlBaseString
	logZoom:(CGFloat)_logZoom
{
	if ( self = [super init] )
	{
		// [pzion 20090311] Assign here rather than retain, otherwise
		// we get a reference loop
		parentQuad = _parentQuad;
		
		coverage = _coverage;
		
		token = [_token retain];
		
		urlBaseString = [_urlBaseString retain];
		
		logZoom = _logZoom;
		zoomMin = powf( 2, logZoom-1 );
		zoomMax = 2 * zoomMin;
	}
	return self;
}	

-(void) dealloc
{
	for ( CercaMapType i=0; i<CMT_NUM_TYPES; ++i )
	{
		[imageDatas[i] release];
		[connections[i] release];
		[images[i] release];
	}
	[urlBaseString release];
	for ( int i=0; i<2; ++i )
		for ( int j=0; j<2; ++j )
			[childQuads[i][j] release];
	[super dealloc];
}

#pragma mark CercaMapQuad

-(void) drawToDstRect:(CGRect)dstRect
	srcRect:(CercaMapRect)srcRect
	zoomLevel:(CGFloat)zoomLevel
	mapType:(CercaMapType)mapType
{
	if ( parentQuad != nil && images[mapType] == nil && connections[mapType] == nil )
	{
		NSString *urlString = [self urlStringForMapType:mapType];
		NSURL *url = [NSURL URLWithString:urlString];
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
		connections[mapType] = [[NSURLConnection connectionWithRequest:urlRequest delegate:self] retain];
	}
		
	if ( zoomLevel >= zoomMin && zoomLevel < zoomMax )
	{
		CercaMapQuad *quad = self;
		while ( quad != nil )
		{
			if ( quad->images[mapType] != nil )
			{
				CGRect subImageRect = CGRectMake(
					(srcRect.origin.x - quad->coverage.origin.x) >> (19-quad->logZoom),
					(srcRect.origin.y - quad->coverage.origin.y) >> (19-quad->logZoom),
					srcRect.size.width >> (19-quad->logZoom),
					srcRect.size.height >> (19-quad->logZoom)
					);
				CGImageRef subImage = CGImageCreateWithImageInRect( [quad->images[mapType] CGImage], subImageRect );
				[[UIImage imageWithCGImage:subImage] drawInRect:dstRect];
				CGImageRelease( subImage );
				break;
			}
			quad = quad->parentQuad;
		}
	}
	else
	{
		for ( int i=0; i<2; ++i )
		{
			for ( int j=0; j<2; ++j )
			{
				CercaMapQuad *childQuad = childQuads[i][j];
				if ( childQuad == nil )
					childQuad = childQuads[i][j] = [[self childQuadAtRow:i col:j] retain];
				CercaMapRect childSrcRect = CercaMapRectIntersect( srcRect, childQuad->coverage );
				if ( CercaMapRectIsNonEmpty( childSrcRect ) )
				{
					CGRect childDstRect = CGRectMake(
						(dstRect.origin.x * (srcRect.origin.x + srcRect.size.width - childSrcRect.origin.x)
							+ (dstRect.origin.x + dstRect.size.width) * (childSrcRect.origin.x - srcRect.origin.x)) / srcRect.size.width,
						(dstRect.origin.y * (srcRect.origin.y + srcRect.size.height - childSrcRect.origin.y)
							+ (dstRect.origin.y + dstRect.size.height) * (childSrcRect.origin.y - srcRect.origin.y)) / srcRect.size.height,
						dstRect.size.width * childSrcRect.size.width / srcRect.size.width,
						dstRect.size.height * childSrcRect.size.height / srcRect.size.height
						);
					[childQuad drawToDstRect:childDstRect srcRect:childSrcRect zoomLevel:zoomLevel mapType:mapType];
				}
			}
		}
	}
}

#pragma mark NSURLConnection Delegate

-(void) connection:(NSURLConnection *)connection
	didReceiveResponse:(NSURLResponse *)response
{
	CercaMapType mapType = [self mapTypeForConnection:connection];
	imageDatas[mapType] = [[NSMutableData alloc] init];
}

-(void) connection:(NSURLConnection *)connection
	didReceiveData:(NSData *)data
{
	CercaMapType mapType = [self mapTypeForConnection:connection];
	[imageDatas[mapType] appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	CercaMapType mapType = [self mapTypeForConnection:connection];

	[connections[mapType] autorelease];
	connections[mapType] = nil;

	UIImage *origImage = [UIImage imageWithData:imageDatas[mapType]];
	[imageDatas[mapType] release];
	imageDatas[mapType] = nil;
	
	UIGraphicsBeginImageContext(origImage.size);
	[origImage drawAtPoint:CGPointMake(0,0)];
	images[mapType] = [UIGraphicsGetImageFromCurrentImageContext() retain];
	UIGraphicsEndImageContext();
		
	[[CercaMapGenerator refreshNotificationCenter]
		postNotificationName:[CercaMapGenerator refreshNotificationName]
		object:self];
}

- (void)connection:(NSURLConnection *)connection
	didFailWithError:(NSError *)error
{
	CercaMapType mapType = [self mapTypeForConnection:connection];
	[imageDatas[mapType] release];
	imageDatas[mapType] = nil;
	[connections[mapType] autorelease];
	connections[mapType] = nil;
}

@end
