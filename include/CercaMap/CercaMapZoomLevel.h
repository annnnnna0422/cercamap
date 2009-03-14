//
//  CercaMapZoomLevel.h
//  CercaMap
//
//  Created by Peter Zion on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#pragma mark CercaMapZoomLevel

typedef CGFloat CercaMapZoomLevel;

#define CM_ZOOM_LEVEL_MIN ((CercaMapZoomLevel)(1<<0))
#define CM_ZOOM_LEVEL_NEIGHBORHOOD ((CercaMapZoomLevel)(1<<15))
#define CM_ZOOM_LEVEL_MAX ((CercaMapZoomLevel)(1<<19))
