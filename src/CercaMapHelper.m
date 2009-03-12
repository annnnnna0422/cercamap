//
//  CercaMapHelper.m
//  Cerca
//
//  Created by Peter Zion on 12/03/09.
//  Copyright 2009 Peter Zion. All rights reserved.
//

#import "CercaMapHelper.h"

@implementation CercaMapHelper

+(CercaMapPoint) mapPointForCoordinate:(CLLocationCoordinate2D)coordinates
{
	CercaMapPoint pixel;
	pixel.x = (int)roundf( ((coordinates.longitude + 180) / 360) * (1<<27) );
	float sinLatitude = sinf( coordinates.latitude * M_PI / 180 );
	float div = (1 + sinLatitude) / (1 - sinLatitude);
	pixel.y = (int)roundf( (0.5 - log(div) / (4 * M_PI)) * (1<<27) );
	return pixel;
}

+(CercaMapPoint) mapPoint:(CercaMapPoint)mapPoint
	pannedByPixelDelta:(CGPoint)delta
	atZoomLevel:(CGFloat)zoomLevel
{
	CercaMapPoint result = CercaMapPointMake(
		mapPoint.x + (1<<18)*delta.x/zoomLevel,
		mapPoint.y + (1<<18)*delta.y/zoomLevel
		);
	return result;
}

+(CGFloat) mapZoomLevel:(CGFloat)zoomLevel
	scaleByFactor:(CGFloat)scale
{
	zoomLevel *= scale;
	if ( zoomLevel < (1<<1) )
		zoomLevel = (1<<1);
	if ( zoomLevel > (1<<19) )
		zoomLevel = (1<<19);
	return zoomLevel;
}

@end
