//
//  CercaMapQuad.h
//  Cerca
//
//  Created by Peter Zion on 11/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CercaMapRect.h"
#import "CercaMapType.h"

#pragma mark Forward Declarations
@protocol CercaMapQuadDelegate;

@interface CercaMapQuad : NSObject
{
@private
	id <CercaMapQuadDelegate> delegate;
	CercaMapQuad *parentQuad;
	CercaMapQuad *childQuads[2][2];
	CercaMapRect coverage;
	NSString *token;
	NSString *urlBaseString;
	CGFloat zoomMin, zoomMax;
	int logZoom;
	UIImage *images[CMT_NUM_TYPES];
	NSURLConnection *connections[CMT_NUM_TYPES];
	NSMutableData *imageDatas[CMT_NUM_TYPES];
}

#pragma mark Public

-(id) initWithDelegate:(id <CercaMapQuadDelegate>)delegate;

-(void) drawToDstRect:(CGRect)dstRect
	centerPoint:(CercaMapPoint)centerPoint
	zoomLevel:(CGFloat)zoomLevel
	mapType:(CercaMapType)mapType;

-(void) didReceiveMemoryWarning;

+(CercaMapPoint) mapPointForCoordinate:(CLLocationCoordinate2D)coordinates;

@end
