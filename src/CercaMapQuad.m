//
//  CercaMapQuad.m
//  Cerca
//
//  Created by Peter Zion on 11/03/09.
//  Copyright 2009 Peter Zion. All rights reserved.
//

#import "CercaMapQuad.h"
#import "CercaMapGenerator.h"
#import <VirtualEarthKit/VECommonService.h>

typedef struct { unsigned char r, g, b, a; } RGBA;

@implementation CercaMapQuad

static NSUInteger globalLoadGeneration;

#pragma mark Private

-(NSString *) urlStringForMapType:(CercaMapType)mapType
{
	static NSString *token = nil;
	if ( token == nil
		&& [CercaMapGenerator mapServiceUsername] != nil
		&& [CercaMapGenerator mapServicePassword] != nil )
	{
		VECommonService *commonService = [[[VECommonService alloc] init] autorelease];
		[commonService getToken:&token
			forUserID:[CercaMapGenerator mapServiceUsername]
			password:[CercaMapGenerator mapServicePassword]
			ipAddress:@"192.168.0.1"];
	}
	
	if ( token == nil )
		return nil;
	
	NSString *prefix;
	switch ( mapType )
	{
		case CM_MAP_TYPE_ROADS:
			prefix = @"http://r0.ortho.tiles.virtualearth.net/tiles/r";
			break;
		case CM_MAP_TYPE_ARIAL:
			prefix = @"http://a0.ortho.tiles.virtualearth.net/tiles/a";
			break;
		case CM_MAP_TYPE_HYBRID:
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
		urlBaseString:childURLBaseString
		logZoom:logZoom+1] autorelease];
}

-(CercaMapType) mapTypeForConnection:(NSURLConnection *)connection
{
	for ( CercaMapType i=0; i<CM_NUM_MAP_TYPES; ++i )
		if ( connections[i] == connection )
			return i;
	return -1;
}

+(UIImage *) uncompressedImageWithData:(NSData *)data
{
	UIImage *image = [UIImage imageWithData:data];
	
	UIGraphicsBeginImageContext(image.size);
	[image drawAtPoint:CGPointMake(0,0)];
	UIImage *uncompressedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return uncompressedImage;
}

#pragma mark Lifecycle

-(id) initWithParentQuad:(CercaMapQuad *)_parentQuad
	coverage:(CercaMapRect)_coverage
	urlBaseString:(NSString *)_urlBaseString
	logZoom:(int)_logZoom
{
	if ( self = [super init] )
	{
		// [pzion 20090311] Assign here rather than retain, otherwise
		// we get a reference loop
		parentQuad = _parentQuad;
		
		coverage = _coverage;
		
		urlBaseString = [_urlBaseString retain];
		
		logZoom = _logZoom;
	}
	return self;
}	

-(void) dealloc
{
	for ( CercaMapType i=0; i<CM_NUM_MAP_TYPES; ++i )
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

#pragma mark Persistence

static NSString *childQuadPKs[2][2] =
{
	{ @"childQuad[0][0]_1", @"childQuad[0][1]_1" },
	{ @"childQuad[1][0]_1", @"childQuad[1][1]_1" }
};
static NSString *coverageOriginXPK = @"coverageOriginX_1";
static NSString *coverageOriginYPK = @"coverageOriginY_1";
static NSString *coverageSizeWidthPK = @"coverageSizeWidth_1";
static NSString *coverageSizeHeightPK = @"coverageSizeHeight_1";
static NSString *urlBaseStringPK = @"urlBaseString_1";
static NSString *logZoomPK = @"logZoom_1";
static NSString *imagePKs[CM_NUM_MAP_TYPES] =
{
	@"roadsImage_1",
	@"aerialImage_1",
	@"hybridImage_1"
};

-(id) initWithCoder:(NSCoder *)decoder
{
	if ( self = [super init] )
	{
		for ( int i=0; i<2; ++i )
		{
			for ( int j=0; j<2; ++j )
			{
				childQuads[i][j] = [[decoder decodeObjectForKey:childQuadPKs[i][j]] retain];
				if ( childQuads[i][j] != nil )
					childQuads[i][j]->parentQuad = self;
			}
		}
		
		coverage = CercaMapRectMake(
			[decoder decodeIntForKey:coverageOriginXPK],
			[decoder decodeIntForKey:coverageOriginYPK],
			[decoder decodeIntForKey:coverageSizeWidthPK],
			[decoder decodeIntForKey:coverageSizeHeightPK]
			);
		
		urlBaseString = [[decoder decodeObjectForKey:urlBaseStringPK] retain];
		
		logZoom = [decoder decodeIntForKey:logZoomPK];
		
		for ( int i=0; i<CM_NUM_MAP_TYPES; ++i )
		{
			NSData *imagePNGRepresentation = [decoder decodeObjectForKey:imagePKs[i]];
			if ( imagePNGRepresentation != nil )
			{
				images[i] = [[CercaMapQuad uncompressedImageWithData:imagePNGRepresentation] retain];
				loadGenerations[i] = globalLoadGeneration++;
			}
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	for ( int i=0; i<2; ++i )
		for ( int j=0; j<2; ++j )
			[encoder encodeObject:childQuads[i][j]
				forKey:childQuadPKs[i][j]];
	
	[encoder encodeInt:coverage.origin.x forKey:coverageOriginXPK];
	[encoder encodeInt:coverage.origin.y forKey:coverageOriginYPK];
	[encoder encodeInt:coverage.size.width forKey:coverageSizeWidthPK];
	[encoder encodeInt:coverage.size.height forKey:coverageSizeHeightPK];
	
	[encoder encodeObject:urlBaseString forKey:urlBaseStringPK];

	[encoder encodeInt:logZoom forKey:logZoomPK];
	
	for ( int i=0; i<CM_NUM_MAP_TYPES; ++i )
	{
		NSData *imagePNGRepresentation = nil;
		if ( images[i] != nil )
			imagePNGRepresentation = UIImagePNGRepresentation(images[i]);
		[encoder encodeObject:imagePNGRepresentation forKey:imagePKs[i]];
	}
}

#pragma mark CercaMapQuad

-(void) drawToDstRect:(CGRect)dstRect
	srcRect:(CercaMapRect)srcRect
	zoomLevel:(CercaMapZoomLevel)zoomLevel
	mapType:(CercaMapType)mapType
{
	if ( parentQuad != nil && images[mapType] == nil && connections[mapType] == nil )
	{
		NSString *urlString = [self urlStringForMapType:mapType];
		if ( urlString != nil )
		{
			NSURL *url = [NSURL URLWithString:urlString];
			NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
			connections[mapType] = [[NSURLConnection connectionWithRequest:urlRequest delegate:self] retain];
		}
	}
		
	CercaMapZoomLevel zoomMin = 1 << logZoom;
	CercaMapZoomLevel zoomMax = 1 << (logZoom+1);
	if ( zoomLevel >= zoomMin && zoomLevel < zoomMax )
	{
		CercaMapQuad *quad = self;
		while ( quad != nil )
		{
			if ( quad->images[mapType] != nil )
			{
				int shift = 19 - quad->logZoom;
				CGRect subImageRect = CGRectMake(
					(srcRect.origin.x - quad->coverage.origin.x + shift/2) >> shift,
					(srcRect.origin.y - quad->coverage.origin.y + shift/2) >> shift,
					(srcRect.size.width + shift/2) >> shift,
					(srcRect.size.height + shift/2) >> shift
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

-(BOOL) shouldKeepAfterPurgingMemory
{
	BOOL keep = NO;

	for ( int i=0; i<CM_NUM_MAP_TYPES; ++i )
	{
		if ( imageDatas[i] != nil )
		{
			if ( globalLoadGeneration - loadGenerations[i] > 8 )
			{
				[imageDatas[i] release];
				imageDatas[i] = nil;
			}
			else
				keep = YES;
		}
		else if ( connections[i] != nil )
			keep = YES;
	}
	
	for ( int i=0; i<2; ++i )
	{
		for ( int j=0; j<2; ++j )
		{
			if ( [childQuads[i][j] shouldKeepAfterPurgingMemory] )
				keep = YES;
			else
			{
				[childQuads[i][j] release];
				childQuads[i][j] = nil;
			}
		}
	}
	
	return keep;
}

#pragma mark NSURLConnection Delegate

-(void) connection:(NSURLConnection *)connection
	didReceiveResponse:(NSURLResponse *)response
{
	CercaMapType mapType = [self mapTypeForConnection:connection];
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	NSInteger httpStatusCode = [httpResponse statusCode];
	if ( httpStatusCode >= 400 )
	{
		[connections[mapType] cancel];
		[connections[mapType] autorelease];
		connections[mapType] = nil;
		
		[[CercaMapGenerator refreshNotificationCenter]
			postNotificationName:[CercaMapGenerator refreshNotificationName]
			object:self];
	}
	else
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

	images[mapType] = [[CercaMapQuad uncompressedImageWithData:imageDatas[mapType]] retain];
	[imageDatas[mapType] release];
	imageDatas[mapType] = nil;
	
	loadGenerations[mapType] = globalLoadGeneration++;
	
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
