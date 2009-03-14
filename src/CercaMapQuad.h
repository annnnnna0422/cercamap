//
//  CercaMapQuad.h
//  Cerca
//
//  Created by Peter Zion on 11/03/09.
//  Copyright 2009 Peter Zion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <CercaMap/CercaMapRect.h>
#import <CercaMap/CercaMapType.h>
#import <CercaMap/CercaMapZoomLevel.h>

@interface CercaMapQuad : NSObject
{
@private
	CercaMapQuad *parentQuad;
	CercaMapQuad *childQuads[2][2];
	CercaMapRect coverage;
	NSString *urlBaseString;
	int logZoom;
	UIImage *images[CM_NUM_MAP_TYPES];
	NSURLConnection *connections[CM_NUM_MAP_TYPES];
	NSMutableData *imageDatas[CM_NUM_MAP_TYPES];
	NSUInteger displayGenerations[CM_NUM_MAP_TYPES];
}

#pragma mark Public

-(id) initWithParentQuad:(CercaMapQuad *)_parentQuad
	coverage:(CercaMapRect)_coverage
	urlBaseString:(NSString *)_urlBaseString
	logZoom:(int)_logZoom;

-(void) drawToDstRect:(CGRect)dstRect
	srcRect:(CercaMapRect)srcRect
	zoomLevel:(CercaMapZoomLevel)zoomLevel
	mapType:(CercaMapType)mapType;

-(BOOL) shouldKeepAfterPurgingMemory;

@end
