//
//  CercaMapQuad.m
//  Cerca
//
//  Created by Peter Zion on 11/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CercaMapQuad.h"
#import "CercaMapQuadDelegate.h"
#import <VirtualEarthKit/VECommonService.h>

typedef struct { unsigned char r, g, b, a; } RGBA;

@implementation CercaMapQuad

#pragma mark Private

-(id) initWithDelegate:(id <CercaMapQuadDelegate>)_delegate
	parentQuad:(CercaMapQuad *)_parentQuad
	coverage:(CercaMapRect)_coverage
	token:(NSString *)_token
	urlBaseString:(NSString *)_urlBaseString
	logZoom:(CGFloat)_logZoom
{
	if ( self = [super init] )
	{
		// [pzion 20090311] Assign here rather than retain, otherwise
		// we get a reference loop
		delegate = _delegate;
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

-(void) outwardDrawToDstRect:(CGRect)dstRect
	srcRect:(CercaMapRect)srcRect
	mapType:(CercaMapType)mapType
{
	if ( images[mapType] != nil )
	{
		CGRect subImageRect = CGRectMake(
			(srcRect.origin.x - coverage.origin.x) >> (19-logZoom),
			(srcRect.origin.y - coverage.origin.y) >> (19-logZoom),
			srcRect.size.width >> (19-logZoom),
			srcRect.size.height >> (19-logZoom)
			);
		CGImageRef subImage = CGImageCreateWithImageInRect( [images[mapType] CGImage], subImageRect );
		[[UIImage imageWithCGImage:subImage] drawInRect:dstRect];
		CGImageRelease( subImage );
	}
	else
		[parentQuad outwardDrawToDstRect:dstRect srcRect:srcRect mapType:mapType];
}

-(void) inwardDrawToDstRect:(CGRect)dstRect
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
		if ( images[mapType] != nil )
		{
			CGRect subImageRect = CGRectMake(
				(srcRect.origin.x - coverage.origin.x) >> (19-logZoom),
				(srcRect.origin.y - coverage.origin.y) >> (19-logZoom),
				srcRect.size.width >> (19-logZoom),
				srcRect.size.height >> (19-logZoom)
				);
			CGImageRef subImage = CGImageCreateWithImageInRect( [images[mapType] CGImage], subImageRect );
			[[UIImage imageWithCGImage:subImage] drawInRect:dstRect];
			CGImageRelease( subImage );
		}
		else if ( parentQuad != nil )
		{
			[parentQuad outwardDrawToDstRect:dstRect srcRect:srcRect mapType:mapType];
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
				{
					CercaMapRect childCoverage;
					NSString *childURLBaseString;
					if ( i==0 )
					{
						if ( j==0 )
						{
							childCoverage = CercaMapRectMake(
								coverage.origin.x,
								coverage.origin.y,
								coverage.size.width/2,
								coverage.size.height/2
								);
							childURLBaseString = [NSString stringWithFormat:@"%@0", urlBaseString];
						}
						else
						{
							childCoverage = CercaMapRectMake(
								coverage.origin.x + coverage.size.width/2,
								coverage.origin.y,
								coverage.size.width/2,
								coverage.size.height/2
								);
							childURLBaseString = [NSString stringWithFormat:@"%@1", urlBaseString];
						}
					}
					else
					{
						if ( j==0 )
						{
							childCoverage = CercaMapRectMake(
								coverage.origin.x,
								coverage.origin.y + coverage.size.height/2,
								coverage.size.width/2,
								coverage.size.height/2
								);
							childURLBaseString = [NSString stringWithFormat:@"%@2", urlBaseString];
						}
						else
						{
							childCoverage = CercaMapRectMake(
								coverage.origin.x + coverage.size.width/2,
								coverage.origin.y + coverage.size.height/2,
								coverage.size.width/2,
								coverage.size.height/2
								);
							childURLBaseString = [NSString stringWithFormat:@"%@3", urlBaseString];
						}
					}
					childQuad = childQuads[i][j] = [[CercaMapQuad alloc] initWithDelegate:delegate
						parentQuad:self
						coverage:childCoverage
						token:token
						urlBaseString:childURLBaseString
						logZoom:logZoom+1];
				}
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
					[childQuad inwardDrawToDstRect:childDstRect srcRect:childSrcRect zoomLevel:zoomLevel mapType:mapType];
				}
			}
		}
	}
}

-(CercaMapType) mapTypeForConnection:(NSURLConnection *)connection
{
	for ( CercaMapType i=0; i<CMT_NUM_TYPES; ++i )
		if ( connections[i] == connection )
			return i;
	return -1;
}

#pragma mark Lifecycle

-(id) initWithDelegate:(id <CercaMapQuadDelegate>)_delegate
{
	VECommonService *commonService = [[[VECommonService alloc] init] autorelease];
	[commonService getToken:&token forUserID:@"137913" password:@"!panChr0mat1c7" ipAddress:@"192.168.0.1"];
	
	return [self initWithDelegate:_delegate
		parentQuad:nil
		coverage:CercaMapRectMake( 0, 0, 1<<27, 1<<27 )
		token:token
		urlBaseString:@""
		logZoom:0];
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

#pragma mark Public

-(void) drawToDstRect:(CGRect)dstRect
	centerPoint:(CercaMapPoint)centerPoint
	zoomLevel:(CGFloat)zoomLevel
	mapType:(CercaMapType)mapType
{
	CGFloat mult = (1<<18) / zoomLevel;
	CGSize srcSize = CGSizeMake( CGRectGetWidth(dstRect)*mult, CGRectGetHeight(dstRect)*mult );
	CercaMapRect srcRect = CercaMapRectMake( roundf( centerPoint.x - srcSize.width/2 ), roundf( centerPoint.y - srcSize.height/2 ),
		roundf( srcSize.width ), roundf( srcSize.height ) );
	[self inwardDrawToDstRect:dstRect srcRect:srcRect zoomLevel:zoomLevel mapType:mapType];
}

-(void) didReceiveMemoryWarning
{
	for ( int i=0; i<2; ++i )
	{
		for ( int j=0; j<2; ++j )
		{
			[childQuads[i][j] release];
			childQuads[i][j] = nil;
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
		
	[delegate cercaMapQuadDidFinishLoading:self];
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
