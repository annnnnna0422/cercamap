//
//  CercaMapHelper.m
//  Cerca
//
//  Created by Peter Zion on 12/03/09.
//  Copyright 2009 Peter Zion. All rights reserved.
//

#import "CercaMapHelper.h"
#import "CercaMapInternal.h"

@implementation CercaMapHelper

+(CercaMapLocation) mapPointForCoordinate:(CLLocationCoordinate2D)coordinates
{
	CercaMapLocation pixel;
	pixel.x = (int)roundf( ((coordinates.longitude + 180) / 360) * CM_TOTAL_PIXELS );
	float sinLatitude = sinf( coordinates.latitude * M_PI / 180 );
	float div = (1 + sinLatitude) / (1 - sinLatitude);
	pixel.y = (int)roundf( (0.5 - log(div) / (4 * M_PI)) * CM_TOTAL_PIXELS );
	return pixel;
}

+(CercaMapLocation) mapLocation:(CercaMapLocation)mapLocation
	pannedByPointDelta:(CGPoint)pointDelta
	atZoomLevel:(CercaMapZoomLevel)zoomLevel
{
	CercaMapLocation result = CercaMapLocationMake(
		mapLocation.x + CM_ZOOM_LEVEL_MAX*pointDelta.x/zoomLevel,
		mapLocation.y + CM_ZOOM_LEVEL_MAX*pointDelta.y/zoomLevel
		);
	return result;
}

+(CercaMapZoomLevel) mapZoomLevel:(CercaMapZoomLevel)zoomLevel
	scaleByFactor:(CGFloat)scale
{
	zoomLevel *= scale;
	if ( zoomLevel < CM_ZOOM_LEVEL_MIN )
		zoomLevel = CM_ZOOM_LEVEL_MIN;
	if ( zoomLevel > CM_ZOOM_LEVEL_MAX )
		zoomLevel = CM_ZOOM_LEVEL_MAX;
	return zoomLevel;
}

@end
