//
//  CercaNearbyViewController.h
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CercaMapViewDelegate.h"

#pragma mark Forward Declarations
@class CercaMapView;
@class CercaMapTileCache;

#pragma mark CercaMapPixel

typedef struct
{
	int x;
	int y;
} CercaMapPixel;

static inline CercaMapPixel CercaMapPixelMake( int x, int y )
{
	CercaMapPixel result = { x, y };
	return result;
}

@interface CercaNearbyViewController : UIViewController
	<CercaMapViewDelegate>
{
@private
	IBOutlet CercaMapView *mapView;
	NSString *token;
	NSMutableDictionary *tileCache;
	CercaMapPixel center;
	int zoomLevel;
}

@end
