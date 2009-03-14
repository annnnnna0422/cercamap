//
//  CercaMapHelper.h
//  Cerca
//
//  Created by Peter Zion on 12/03/09.
//  Copyright 2009 Peter Zion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <CercaMap/CercaMapLocation.h>
#import <CercaMap/CercaMapZoomLevel.h>

@interface CercaMapHelper : NSObject
{
}

+(CercaMapLocation) mapPointForCoordinate:(CLLocationCoordinate2D)coordinates;

+(CercaMapLocation) mapLocation:(CercaMapLocation)mapLocation
	pannedByPointDelta:(CGPoint)pointDelta
	atZoomLevel:(CercaMapZoomLevel)zoomLevel;
	
+(CercaMapZoomLevel) mapZoomLevel:(CercaMapZoomLevel)zoomLevel
	scaleByFactor:(CGFloat)scale;
	
@end
