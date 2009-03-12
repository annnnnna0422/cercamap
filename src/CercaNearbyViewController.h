//
//  CercaNearbyViewController.h
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CercaMapGeneratorDelegate.h"
#import "CercaMapPoint.h"
#import "CercaMapType.h"

#pragma mark Forward Declarations
@class CercaMapView;
@class CLLocationManager;

@interface CercaNearbyViewController : UIViewController
	<CLLocationManagerDelegate>
{
@private
	IBOutlet CercaMapView *mapView;
	IBOutlet UIBarButtonItem *gpsBarButtonItem;
	IBOutlet UISegmentedControl *segmentedControl;
	CLLocationManager *locationManager;
}

#pragma mark Actions

-(void) gpsButtonTapped:(id)sender;
-(void) segmentedControlTapped:(id)sender;

@end
