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
#import <CercaMap/CercaMapPoint.h>

@interface CercaMapHelper : NSObject
{
}

+(CercaMapPoint) mapPointForCoordinate:(CLLocationCoordinate2D)coordinates;

+(CercaMapPoint) mapPoint:(CercaMapPoint)mapPoint
	pannedByPixelDelta:(CGPoint)delta
	atZoomLevel:(CGFloat)zoomLevel;
	
+(CGFloat) mapZoomLevel:(CGFloat)zoomLevel
	scaleByFactor:(CGFloat)scale;
	
@end
