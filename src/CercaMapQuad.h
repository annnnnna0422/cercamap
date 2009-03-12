//
//  CercaMapQuad.h
//  Cerca
//
//  Created by Peter Zion on 11/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CercaMapRect.h"

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
	UIImage *image;
	NSURLConnection *connection;
	NSMutableData *imageData;
}

#pragma mark Public

-(id) initWithDelegate:(id <CercaMapQuadDelegate>)delegate;

-(void) drawToContext:(CGContextRef)contextRef
	dstRect:(CGRect)dstRect
	centerPoint:(CercaMapPoint)centerPoint
	zoomLevel:(CGFloat)zoomLevel;

-(void) didReceiveMemoryWarning;

@end