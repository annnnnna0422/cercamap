//
//  CercaNearbyViewController.m
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CercaNearbyViewController.h"
#import "CercaMapView.h"
#import "CercaMapTile.h"

#import <CoreLocation/CoreLocation.h>
#import <VirtualEarthKit/VECommonService.h>

@implementation CercaNearbyViewController

#pragma mark Private

-(CercaMapPixel) pixelForCoordinates:(CLLocationCoordinate2D)coordinates
{
	CercaMapPixel pixel;
	pixel.x = (int)roundf( ((coordinates.longitude + 180) / 360) * (1<<(zoomLevel+8)) );
	float sinLatitude = sinf( coordinates.latitude * M_PI / 180 );
	float div = (1 + sinLatitude) / (1 - sinLatitude);
	pixel.y = (int)roundf( (0.5 - log(div) / (4 * M_PI)) * (1<<(zoomLevel+8)) );
	return pixel;
}

-(NSString *) tileURLStringForPixel:(CercaMapPixel)pixel
{
	NSMutableString *tileURLString = [NSMutableString stringWithString:@"http://r0.ortho.tiles.virtualearth.net/tiles/r"];
	int mask = 1 << zoomLevel;
	while ( mask != 1 )
	{
		mask = mask >> 1;
		if ( pixel.y & (mask<<8) )
		{
			if ( pixel.x & (mask<<8) )
				[tileURLString appendString:@"3"];
			else
				[tileURLString appendString:@"2"];
		}
		else
		{
			if ( pixel.x & (mask<<8) )
				[tileURLString appendString:@"1"];
			else
				[tileURLString appendString:@"0"];
		}
	}
	[tileURLString appendString:@".jpeg?g=131&token="];
	[tileURLString appendString:token];
	return tileURLString;
}

-(CercaMapTile *) tileForMapPixel:(CercaMapPixel)pixel
{
	NSString *tileURLString = [self tileURLStringForPixel:pixel];
	CercaMapTile *tile = [tileCache objectForKey:tileURLString];
	if ( tile == nil )
	{
		NSURL *tileURL = [NSURL URLWithString:tileURLString];
		tile = [CercaMapTile tileWithURL:tileURL];
		[tileCache setObject:tile forKey:tileURLString];
	}
	return tile;
}

-(void) clearTiles
{
	NSArray *tiles = mapView.subviews;
	for ( UIView *tile in tiles )
		[tile removeFromSuperview];
}

-(void) refreshTiles
{
	CGRect bounds = mapView.bounds;
	int width = CGRectGetWidth(bounds);
	int height = CGRectGetHeight(bounds);
	
	NSArray *tiles = mapView.subviews;
	for ( UIView *tile in tiles )
	{
		CGRect intersection = CGRectIntersection( bounds, tile.frame );
		if ( CGRectIsNull( intersection ) )
			[tile removeFromSuperview];
	}
	tiles = mapView.subviews;
	
	CercaMapPixel originMapPixel = CercaMapPixelMake( center.x - width/2, center.y - height/2 );
	for ( int y = -(originMapPixel.y%256); y < height; y += 256 )
	{
		for ( int x = -(originMapPixel.x%256); x < width; x += 256 )
		{
			BOOL found = NO;
			for ( UIView *tile in tiles )
			{
				if ( CGRectContainsPoint( tile.frame, CGPointMake( x, y ) ) )
				{
					found = YES;
					break;
				}
			}
			if ( found )
				continue;
			
			CercaMapPixel tileMapPixel = CercaMapPixelMake( originMapPixel.x+x, originMapPixel.y+y );
			CercaMapTile *tile = [self tileForMapPixel:tileMapPixel];
			tile.frame = CGRectMake( x, y, 256, 256 );
			[mapView addSubview:tile];
		}
	}
}

#pragma mark Lifecycle

-(void) dealloc
{
	[tileCache release];
	[token release];
	[mapView release];
	[super dealloc];
}

#pragma mark UIViewController

-(void) viewDidLoad
{
	VECommonService *commonService = [[[VECommonService alloc] init] autorelease];
	[commonService getToken:&token forUserID:@"137913" password:@"!panChr0mat1c7" ipAddress:@"192.168.0.1"];
	[token retain];
	
	tileCache = [[NSMutableDictionary alloc] init];
	
	CLLocationCoordinate2D coordinates;
	coordinates.latitude = 44.23;
	coordinates.longitude = -76.5;

	zoomLevel = 14;
	center = [self pixelForCoordinates:coordinates];
}

-(void) didReceiveMemoryWarning
{
	[tileCache removeAllObjects];
}

#pragma mark CercaMapViewController

-(void) cercaMapViewDidResize:(CercaMapView *)circaMapView
{
	[self clearTiles];
	[self refreshTiles];
}

-(void) cercaMapView:(CercaMapView *)overlay
	didPanByDelta:(CGPoint)delta
{
	center.x -= delta.x;
	center.y -= delta.y;

	NSArray *tiles = mapView.subviews;
	for ( UIView *tile in tiles )
	{
		CGRect frame = tile.frame;
		frame.origin.x += delta.x;
		frame.origin.y += delta.y;
		tile.frame = frame;
	}
	
	[self refreshTiles];
}
	
-(void) cercaMapViewDidZoomIn:(CercaMapView *)cercaMapView
{
	if ( zoomLevel < 19 )
	{
		[self clearTiles];
		++zoomLevel;
		center.x *= 2;
		center.y *= 2;
		[self refreshTiles];
	}
}

-(void) cercaMapViewDidZoomOut:(CercaMapView *)cercaMapView
{
	if ( zoomLevel > 1 )
	{
		[self clearTiles];
		--zoomLevel;
		center.x /= 2;
		center.y /= 2;
		[self refreshTiles];
	}
}

@end
