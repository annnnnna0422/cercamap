//
//  CercaNearbyViewController.m
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CercaNearbyViewController.h"
#import "CercaMapView.h"
#import "CercaMapQuad.h"

@implementation CercaNearbyViewController

#pragma mark Private

-(CercaMapPoint) pixelForCoordinates:(CLLocationCoordinate2D)coordinates
{
	CercaMapPoint pixel;
	pixel.x = (int)roundf( ((coordinates.longitude + 180) / 360) * (1<<27) );
	float sinLatitude = sinf( coordinates.latitude * M_PI / 180 );
	float div = (1 + sinLatitude) / (1 - sinLatitude);
	pixel.y = (int)roundf( (0.5 - log(div) / (4 * M_PI)) * (1<<27) );
	return pixel;
}

-(void) panByDelta:(CercaMapPoint)delta
{
	center.x += (1<<19)/zoomLevel*delta.x;
	center.y += (1<<19)/zoomLevel*delta.y;

	[mapView setNeedsDisplay];
}

#pragma mark Lifecycle

-(void) dealloc
{
	[locationManager release];
	[rootMapQuad release];
	[mapView release];
	[super dealloc];
}

#pragma mark UIViewController

-(void) viewDidLoad
{
	rootMapQuad = [[CercaMapQuad alloc] initWithDelegate:self];
	
	CLLocationCoordinate2D coordinates;
	coordinates.latitude = 44.23;
	coordinates.longitude = -76.5;

	zoomLevel = 1 << 14;
	center = [self pixelForCoordinates:coordinates];
}

-(void) didReceiveMemoryWarning
{
	[rootMapQuad didReceiveMemoryWarning];
}

#pragma mark CercaMapViewController

-(void) cercaMapView:(CercaMapView *)cercaMapView
	drawToContext:(CGContextRef)contextRef
	dstRect:(CGRect)dstRect
{
	[rootMapQuad drawToContext:contextRef
		dstRect:dstRect
		centerPoint:center
		zoomLevel:zoomLevel];
}

-(void) cercaMapView:(CercaMapView *)overlay
	didPanByDelta:(CercaMapPoint)delta
{
	[self panByDelta:delta];
}
	
-(void) cercaMapView:(CercaMapView *)cercaMapView
	didZoomByScale:(CGFloat)scale
{
	zoomLevel *= scale;
	if ( zoomLevel < 1 )
		zoomLevel = 1;
	if ( zoomLevel > 19 )
		zoomLevel = 19;
	[mapView setNeedsDisplay];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
	fromLocation:(CLLocation *)oldLocation
{
	CercaMapPoint newCenter = [self pixelForCoordinates:newLocation.coordinate];
	CercaMapPoint delta = CercaMapPointMake( newCenter.x - center.x, newCenter.y - center.y );
	[self panByDelta:delta];
}

- (void)locationManager:(CLLocationManager *)manager
	didFailWithError:(NSError *)error
{
}

#pragma mark Actions

-(void) gpsButtonTapped:(id)sender
{
	if ( gpsBarButtonItem.style == UIBarButtonItemStyleDone )
	{
		[locationManager release];
		locationManager = nil;
		gpsBarButtonItem.style = UIBarButtonItemStyleBordered;
	}
	else
	{
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		[locationManager startUpdatingLocation];
		gpsBarButtonItem.style = UIBarButtonItemStyleDone;
	}
}

#pragma mark CercaMapQuadDelegate

-(void) cercaMapQuadDidFinishLoading:(CercaMapQuad *)cercaMapQuad
{
	[mapView setNeedsDisplay];
}

@end
