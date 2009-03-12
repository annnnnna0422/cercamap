//
//  CercaMapDemoViewController.m
//  CercaMapDemo
//
//  Created by Peter Zion on 12/03/09.
//  Copyright Peter Zion 2009. All rights reserved.
//

#import "CercaMapDemoViewController.h"
#import <CercaMap/CercaMap.h>
#import "config.h"

@implementation CercaMapDemoViewController

-(void) viewDidLoad
{
	cercaMapView.virtualEarthKitUsername = @VIRTUAL_EARTH_KIT_USERNAME;
	cercaMapView.virtualEarthKitPassword = @VIRTUAL_EARTH_KIT_PASSWORD;

	CLLocationCoordinate2D coordinate;
	coordinate.latitude = 37.766667;
	coordinate.longitude = -122.433333;

	cercaMapView.zoomLevel = 1 << 14;
	cercaMapView.centerPoint = [CercaMapHelper mapPointForCoordinate:coordinate];
	cercaMapView.mapType = CMT_ROADS;
}

-(IBAction) segmentedControlValueChanged:(id)sender
{
	cercaMapView.mapType = segmentedControl.selectedSegmentIndex;
}

@end
