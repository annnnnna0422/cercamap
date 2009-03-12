/*
 *  CercaMapQuadDelegate.h
 *  Cerca
 *
 *  Created by Peter Zion on 11/03/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
 
#import <Foundation/Foundation.h>
 
#pragma mark Forward Declarations
@class CercaMapQuad;

@protocol CercaMapQuadDelegate <NSObject>

@required

-(void) cercaMapQuadDidFinishLoading:(CercaMapQuad *)cercaMapQuad;

@end
