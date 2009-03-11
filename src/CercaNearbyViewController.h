//
//  CercaNearbyViewController.h
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CercaMapViewDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "CercaMapPixel.h"

#pragma mark Forward Declarations
@class CercaMapView;
@class CercaMapTileCache;
@class CLLocationManager;

@interface CercaNearbyViewController : UIViewController
	<CercaMapViewDelegate,
		CLLocationManagerDelegate>
{
@private
	IBOutlet CercaMapView *mapView;
	IBOutlet UIBarButtonItem *gpsBarButtonItem;
	NSString *token;
	NSMutableDictionary *tileCache;
	CercaMapPixel center;
	int zoomLevel;
	CLLocationManager *locationManager;
}

#pragma mark Actions

-(void) gpsButtonTapped:(id)sender;

@end
