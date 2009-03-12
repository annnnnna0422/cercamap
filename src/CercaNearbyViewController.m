//
//  CercaNearbyViewController.m
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CercaNearbyViewController.h"
#import "CercaMapView.h"
#import "CercaMapGenerator.h"
#import "CercaMapHelper.h"

@implementation CercaNearbyViewController

#pragma mark Lifecycle

-(void) dealloc
{
	[locationManager release];
	[mapView release];
	[super dealloc];
}

#pragma mark UIViewController

-(void) didReceiveMemoryWarning
{
	[CercaMapGenerator didReceiveMemoryWarning];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
	fromLocation:(CLLocation *)oldLocation
{
	mapView.centerPoint = [CercaMapHelper mapPointForCoordinate:newLocation.coordinate];
	mapView.zoomLevel = 1<<14;
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
	mapView.mapType = segmentedControl.selectedSegmentIndex;
}

@end
