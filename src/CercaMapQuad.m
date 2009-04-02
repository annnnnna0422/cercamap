//
//  CercaMapQuad.m
//  Cerca
//
//  Created by Peter Zion on 11/03/09.
//  Copyright 2009 Peter Zion. All rights reserved.
//

#import "CercaMapQuad.h"
#import "CercaMapGenerator.h"

typedef struct { unsigned char r, g, b, a; } RGBA;

@implementation CercaMapQuad

struct CercaMapQuadMRU_struct
{
	CercaMapQuadMRU *prev, *next;
};
static CercaMapQuadMRU *frontMRU;

static inline CercaMapQuadMRU *allocMRU()
{
	CercaMapQuadMRU *mru = malloc( sizeof(CercaMapQuadMRU) );
	mru->prev = NULL;
	mru->next = NULL;
	return mru;
}

static inline void moveMRUToFront( CercaMapQuadMRU *mru )
{
	if ( frontMRU != mru )
	{
		if ( mru->prev != NULL )
			mru->prev->next = mru->next;
		if ( mru->next != NULL )
			mru->next->prev = mru->prev;
		
		mru->prev = NULL;
		mru->next = frontMRU;
		if ( frontMRU != NULL )
			frontMRU->prev = mru;
		frontMRU = mru;
	}
}

static inline void freeMRU( CercaMapQuadMRU *mru )
{
	if ( mru->prev != NULL )
		mru->prev->next = mru->next;
	else
		frontMRU = mru->next;
	if ( mru->next != NULL )
		mru->next->prev = mru->prev;
	free( mru );
}

static inline NSUInteger indexForMRU( CercaMapQuadMRU *mru, NSUInteger cutoff )
{
	// [pzion 20090314] We wrap around intentionally here, so that we return
	// the maximum NSUInteger value in the case that mru is NULL
	NSInteger result = -1;
	while ( mru != NULL && result < (NSInteger)cutoff )
	{
		++result;
		mru = mru->prev;
	}
	return (NSUInteger)result;
}

#pragma mark Private

-(NSString *) urlStringForMapType:(CercaMapType)mapType
{
	NSString *result = [NSString stringWithFormat:@"http://tile.openstreetmap.org/%d/%d/%d.png",
		CM_ZOOM_LEVEL_LOG_MAX-logZoom,
		coverage.origin.x >> (logZoom + 8),
		coverage.origin.y >> (logZoom + 8)];
	NSLog( @"%d,%d+%d,%d: %@", coverage.origin.x, coverage.origin.y, coverage.size.width, coverage.size.height, result );
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
	return [[[CercaMapQuad alloc] initWithParentQuad:self
		coverage:childCoverage
		logZoom:logZoom-1] autorelease];
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
	logZoom:(int)_logZoom
{
	if ( self = [super init] )
	{
		// [pzion 20090311] Assign here rather than retain, otherwise
		// we get a reference loop
		parentQuad = _parentQuad;
		
		coverage = _coverage;
		
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
		if ( displayMRUs[i] != NULL )
			freeMRU( displayMRUs[i] );
	}
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
static NSString *logZoomPK = @"logZoom_1";
static NSString *imagePKs[CM_NUM_MAP_TYPES] =
{
	@"defaultImage_1",
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
		
		logZoom = [decoder decodeIntForKey:logZoomPK];
		
		for ( int i=0; i<CM_NUM_MAP_TYPES; ++i )
		{
			NSData *imagePNGRepresentation = [decoder decodeObjectForKey:imagePKs[i]];
			if ( imagePNGRepresentation != nil )
				images[i] = [[CercaMapQuad uncompressedImageWithData:imagePNGRepresentation] retain];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	static const NSUInteger displayMRUsToEncode = 8;
	
	for ( int i=0; i<2; ++i )
		for ( int j=0; j<2; ++j )
			[encoder encodeObject:childQuads[i][j]
				forKey:childQuadPKs[i][j]];
	
	[encoder encodeInt:coverage.origin.x forKey:coverageOriginXPK];
	[encoder encodeInt:coverage.origin.y forKey:coverageOriginYPK];
	[encoder encodeInt:coverage.size.width forKey:coverageSizeWidthPK];
	[encoder encodeInt:coverage.size.height forKey:coverageSizeHeightPK];
	
	[encoder encodeInt:logZoom forKey:logZoomPK];
	
	for ( int i=0; i<CM_NUM_MAP_TYPES; ++i )
	{
		NSData *imagePNGRepresentation = nil;
		if ( images[i] != nil && indexForMRU( displayMRUs[i], displayMRUsToEncode ) < displayMRUsToEncode )
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
		
	CercaMapZoomLevel zoomMin = 1 << (logZoom-1);
	CercaMapZoomLevel zoomMax = 1 << (logZoom);
	if ( zoomLevel > zoomMin && zoomLevel <= zoomMax )
	{
		CercaMapQuad *quad = self;
		while ( quad != nil )
		{
			if ( quad->images[mapType] != nil )
			{
				int shift = quad->logZoom;
				CGRect subImageRect = CGRectMake(
					(srcRect.origin.x - quad->coverage.origin.x) >> shift,
					(srcRect.origin.y - quad->coverage.origin.y) >> shift,
					(srcRect.size.width) >> shift,
					(srcRect.size.height) >> shift
					);
				CGImageRef subImage = CGImageCreateWithImageInRect( [quad->images[mapType] CGImage], subImageRect );
				[[UIImage imageWithCGImage:subImage] drawInRect:dstRect];
				CGImageRelease( subImage );
				if ( quad->displayMRUs[mapType] == NULL )
					quad->displayMRUs[mapType] = allocMRU();
				moveMRUToFront( quad->displayMRUs[mapType] );
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
						roundf( (dstRect.origin.x * (srcRect.origin.x + srcRect.size.width - childSrcRect.origin.x)
							+ (dstRect.origin.x + dstRect.size.width) * (childSrcRect.origin.x - srcRect.origin.x)) / srcRect.size.width ),
						roundf( (dstRect.origin.y * (srcRect.origin.y + srcRect.size.height - childSrcRect.origin.y)
							+ (dstRect.origin.y + dstRect.size.height) * (childSrcRect.origin.y - srcRect.origin.y)) / srcRect.size.height ),
						roundf( dstRect.size.width * childSrcRect.size.width / srcRect.size.width ),
						roundf( dstRect.size.height * childSrcRect.size.height / srcRect.size.height )
						);
					[childQuad drawToDstRect:childDstRect srcRect:childSrcRect zoomLevel:zoomLevel mapType:mapType];
				}
			}
		}
	}
}

-(BOOL) shouldKeepAfterPurgingMemory
{
	static const NSUInteger displayMRUsToKeep = 8;
	BOOL keep = NO;

	for ( int i=0; i<CM_NUM_MAP_TYPES; ++i )
	{
		if ( images[i] != nil )
		{
			if ( indexForMRU( displayMRUs[i], displayMRUsToKeep ) >= displayMRUsToKeep )
			{
				if ( displayMRUs[i] != NULL )
				{
					freeMRU( displayMRUs[i] );
					displayMRUs[i] = NULL;
				}
				[images[i] release];
				images[i] = nil;
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
