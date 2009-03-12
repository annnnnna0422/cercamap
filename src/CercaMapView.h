//
//  CercaMapView.h
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CercaMap/CercaMapType.h>
#import <CercaMap/CercaMapPoint.h>

#pragma mark Forward Declarations
@protocol CercaMapViewDelegate;

@interface CercaMapView : UIView
{
@private
	int numPoints;
	CGPoint points[2];
	CercaMapPoint centerPoint;
	NSString *virtualEarthKitUsername;
	NSString *virtualEarthKitPassword;
	CGFloat zoomLevel;
	CercaMapType mapType;
}

#pragma mark Public

@property( retain ) NSString *virtualEarthKitUsername;
@property( retain ) NSString *virtualEarthKitPassword;
@property( assign ) CercaMapPoint centerPoint;
@property( assign ) CGFloat zoomLevel;
@property( assign ) CercaMapType mapType;

@end
