//
//  CercaMapDemoViewController.m
//  CercaMapDemo
//
//  Created by Peter Zion on 12/03/09.
//  Copyright Peter Zion 2009. All rights reserved.
//

#import "CercaMapDemoViewController.h"
#import <CercaMap/CercaMap.h>

@implementation CercaMapDemoViewController

-(void) viewDidLoad
{
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = 37.766667;
	coordinate.longitude = -122.433333;

	cercaMapView.zoomLevel = 1 << 14;
	[cercaMapView setCenterCoordinate:coordinate];
	cercaMapView.mapType = CM_MAP_TYPE_ROADS;
}

-(IBAction) segmentedControlValueChanged:(id)sender
{
	cercaMapView.mapType = segmentedControl.selectedSegmentIndex;
}

@end
