//
//  CercaNearbyViewController.h
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CercaMapViewDelegate.h"
#import "CercaMapQuadDelegate.h"
#import "CercaMapPoint.h"
#import "CercaMapType.h"

#pragma mark Forward Declarations
@class CercaMapView;
@class CercaMapQuad;
@class CLLocationManager;

@interface CercaNearbyViewController : UIViewController
	<CercaMapViewDelegate,
		CercaMapQuadDelegate,
		CLLocationManagerDelegate>
{
@private
	IBOutlet CercaMapView *mapView;
	IBOutlet UIBarButtonItem *gpsBarButtonItem;
	IBOutlet UISegmentedControl *segmentedControl;
	CercaMapQuad *rootMapQuad;
	CercaMapPoint center;
	CGFloat zoomLevel;
	CercaMapType mapType;
	CLLocationManager *locationManager;
}

#pragma mark Actions

-(void) gpsButtonTapped:(id)sender;
-(void) segmentedControlTapped:(id)sender;

@end
