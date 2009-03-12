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

@implementation CercaMapQuad

#pragma mark Private

-(id) initWithDelegate:(id <CercaMapQuadDelegate>)_delegate
	parentQuad:(CercaMapQuad *)_parentQuad
	coverage:(CercaMapRect)_coverage
	token:(NSString *)_token
	urlBaseString:(NSString *)_urlBaseString
	zoomMin:(CGFloat)_zoomMin
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
		
		zoomMin = _zoomMin;
		zoomMax = 2.0*zoomMin;
	}
	return self;
}	

-(NSString *) urlString
{
	NSString *result = [NSString stringWithFormat:@"%@%@%@", urlBaseString, @".jpeg?g=131&token=", token];
	return result;
}

-(BOOL) inwardDrawToContext:(CGContextRef)contextRef
	dstRect:(CGRect)dstRect
	srcRect:(CercaMapRect)srcRect
	zoomLevel:(CGFloat)zoomLevel
{
	if ( zoomLevel >= zoomMin && zoomLevel < zoomMax )
	{
		NSLog( @"dstRect=(%.1f,%.1f+%.1f,%.1f)",
			dstRect.origin.x, dstRect.origin.y, dstRect.size.width, dstRect.size.height );
		if ( image != nil )
			[image drawInRect:dstRect];
		else if ( connection == nil )
		{
			NSString *urlString = [self urlString];
			NSURL *url = [NSURL URLWithString:urlString];
			NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
			connection = [[NSURLConnection connectionWithRequest:urlRequest delegate:self] retain];
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
						zoomMin:zoomMax];
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
					[childQuad inwardDrawToContext:contextRef
						dstRect:childDstRect
						srcRect:childSrcRect
						zoomLevel:zoomLevel];
				}
			}
		}
	}
	return YES;
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
		urlBaseString:@"http://r0.ortho.tiles.virtualearth.net/tiles/r"
		zoomMin:sqrt(2)/4];
}

-(void) dealloc
{
	[imageData release];
	[connection release];
	[image release];
	[urlBaseString release];
	for ( int i=0; i<2; ++i )
		for ( int j=0; j<2; ++j )
			[childQuads[i][j] release];
	[super dealloc];
}

#pragma mark Public

-(void) drawToContext:(CGContextRef)contextRef
	dstRect:(CGRect)dstRect
	centerPoint:(CercaMapPoint)centerPoint
	zoomLevel:(CGFloat)zoomLevel
{
	CGFloat mult = (1<<18) / zoomLevel;
	CGSize srcSize = CGSizeMake( CGRectGetWidth(dstRect)*mult, CGRectGetHeight(dstRect)*mult );
	CercaMapRect srcRect = CercaMapRectMake( roundf( centerPoint.x - srcSize.width/2 ), roundf( centerPoint.y - srcSize.height/2 ),
		roundf( srcSize.width ), roundf( srcSize.height ) );
	[self inwardDrawToContext:contextRef dstRect:dstRect srcRect:srcRect zoomLevel:zoomLevel];
}

-(void) didReceiveMemoryWarning
{
	// [pzion 20090311] FIXME
}

#pragma mark NSURLConnection Delegate

-(void) connection:(NSURLConnection *)connection
	didReceiveResponse:(NSURLResponse *)response
{
	imageData = [[NSMutableData alloc] init];
}

-(void) connection:(NSURLConnection *)connection
	didReceiveData:(NSData *)data
{
	[imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_
{
	image = [[UIImage imageWithData:imageData] retain];
	[imageData release];
	imageData = nil;
	[connection autorelease];
	connection = nil;
	[delegate cercaMapQuadDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)_ didFailWithError:(NSError *)error
{
	[imageData release];
	imageData = nil;
	[connection autorelease];
	connection = nil;
}

@end
