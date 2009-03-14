//
//  CercaMapView.h
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright 2009 Peter Zion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CercaMap/CercaMapType.h>
#import <CercaMap/CercaMapLocation.h>
#import <CercaMap/CercaMapZoomLevel.h>

#pragma mark Forward Declarations
@protocol CercaMapViewDelegate;

@interface CercaMapView : UIView
{
@private
	int numPoints;
	CGPoint points[2];
	CercaMapLocation centerPoint;
	CercaMapZoomLevel zoomLevel;
	CercaMapType mapType;
}

#pragma mark CercaMapView - Parameters
@property( assign ) CercaMapLocation centerPoint;
@property( assign ) CercaMapZoomLevel zoomLevel;
@property( assign ) CercaMapType mapType;
-(void) setCenterCoordinate:(CLLocationCoordinate2D)coordinate;

@end
