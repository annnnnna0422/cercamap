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
#import <CoreLocation/CoreLocation.h>

@implementation CercaNearbyViewController

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
	center = [CercaMapQuad mapPointForCoordinate:coordinates];
}

-(void) didReceiveMemoryWarning
{
	[rootMapQuad didReceiveMemoryWarning];
}

#pragma mark CercaMapViewController

-(void) cercaMapView:(CercaMapView *)cercaMapView
	drawToDstRect:(CGRect)dstRect
{
	[rootMapQuad drawToDstRect:dstRect
		centerPoint:center
		zoomLevel:zoomLevel
		mapType:mapType];
}

-(void) cercaMapView:(CercaMapView *)overlay
	didPanByDelta:(CGPoint)delta
{
	center.x += (1<<18)*delta.x/zoomLevel;
	center.y += (1<<18)*delta.y/zoomLevel;

	[mapView setNeedsDisplay];
}
	
-(void) cercaMapView:(CercaMapView *)cercaMapView
	didZoomByScale:(CGFloat)scale
{
	zoomLevel *= scale;
	if ( zoomLevel < (1<<1) )
		zoomLevel = (1<<1);
	if ( zoomLevel > (1<<19) )
		zoomLevel = (1<<19);
	[mapView setNeedsDisplay];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
	fromLocation:(CLLocation *)oldLocation
{
	center = [CercaMapQuad mapPointForCoordinate:newLocation.coordinate];
	zoomLevel = 1<<14;
	[mapView setNeedsDisplay];
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

-(void) segmentedControlTapped:(id)sender
{
	mapType = segmentedControl.selectedSegmentIndex;
	[mapView setNeedsDisplay];
}

#pragma mark CercaMapQuadDelegate

-(void) cercaMapQuadDidFinishLoading:(CercaMapQuad *)cercaMapQuad
{
	[mapView setNeedsDisplay];
}

@end
