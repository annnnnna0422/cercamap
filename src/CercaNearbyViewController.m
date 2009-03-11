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

-(void) forLocation:(CLLocationCoordinate2D)location
	getPixelX:(int *)pixelX
	pixelY:(int *)pixelY
{
	if ( pixelX != NULL )
		*pixelX = (int)roundf( ((location.longitude + 180) / 360) * (1<<(zoomLevel+8)) );
	if ( pixelY != NULL )
	{
		float sinLatitude = sinf( location.latitude * M_PI / 180 );
		float div = (1 + sinLatitude) / (1 - sinLatitude);
		*pixelY = (int)roundf( (0.5 - log(div) / (4 * M_PI)) * (1<<(zoomLevel+8)) );
	}
}

-(NSURL *) getTileURLForPixelX:(int)pixelX
	pixelY:(int)pixelY
{
	NSMutableString *tileURLString = [NSMutableString stringWithString:@"http://r0.ortho.tiles.virtualearth.net/tiles/r"];
	int mask = 1 << zoomLevel;
	while ( mask != 1 )
	{
		mask = mask >> 1;
		if ( pixelY & (mask<<8) )
		{
			if ( pixelX & (mask<<8) )
				[tileURLString appendString:@"3"];
			else
				[tileURLString appendString:@"2"];
		}
		else
		{
			if ( pixelX & (mask<<8) )
				[tileURLString appendString:@"1"];
			else
				[tileURLString appendString:@"0"];
		}
	}
	[tileURLString appendString:@".jpeg?g=131&token="];
	[tileURLString appendString:token];
	return [NSURL URLWithString:tileURLString];
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
	
	int originX = centerX - width/2, originY = centerY - height/2;
	int offsetX = originX % 256, offsetY = originY % 256;
	for ( int y = -offsetY; y < height; y += 256 )
	{
		for ( int x = -offsetX; x < CGRectGetWidth(bounds); x += 256 )
		{
			BOOL found = NO;
			for ( UIView *tile in tiles )
			{
				if ( CGRectContainsPoint( tile.frame, CGPointMake(x,y) ) )
				{
					found = YES;
					break;
				}
			}
			if ( found )
				continue;
				
			NSURL *tileURL = [self getTileURLForPixelX:originX+x pixelY:originY+y];
			CercaMapTile *tile = [CercaMapTile tileWithURL:tileURL];
			tile.frame = CGRectMake( x, y, 256, 256 );
			[mapView addSubview:tile];
		}
	}
}

#pragma mark UIViewController

-(void) viewDidLoad
{
	VECommonService *commonService = [[[VECommonService alloc] init] autorelease];
	[commonService getToken:&token forUserID:@"137913" password:@"!panChr0mat1c7" ipAddress:@"192.168.0.1"];
	[token retain];
	
	CLLocationCoordinate2D coordinates;
	coordinates.latitude = 44.23;
	coordinates.longitude = -76.5;
	
	zoomLevel = 14;
	[self forLocation:coordinates getPixelX:&centerX pixelY:&centerY];
	
	[self refreshTiles];
}

#pragma mark CercaMapViewController

-(void) cercaMapView:(CercaMapView *)overlay
	didPanByDelta:(CGPoint)delta
{
}
	
-(void) cercaMapViewDidZoomIn:(CercaMapView *)cercaMapView
{
}

-(void) cercaMapViewDidZoomOut:(CercaMapView *)cercaMapView
{
}

@end
