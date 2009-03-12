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

@interface CercaMapQuad : NSObject
{
@private
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

-(id) initWithParentQuad:(CercaMapQuad *)_parentQuad
	coverage:(CercaMapRect)_coverage
	token:(NSString *)_token
	urlBaseString:(NSString *)_urlBaseString
	logZoom:(CGFloat)_logZoom;

-(void) drawToDstRect:(CGRect)dstRect
	srcRect:(CercaMapRect)srcRect
	zoomLevel:(CGFloat)zoomLevel
	mapType:(CercaMapType)mapType;

@end
