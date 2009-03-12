/*
 *  CercaMapGeneratorDelegate.h
 *  Cerca
 *
 *  Created by Peter Zion on 11/03/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
 
#import <Foundation/Foundation.h>
 
#pragma mark Forward Declarations
@class CercaMapQuad;

@protocol CercaMapGeneratorDelegate

@required

-(void) cercaMapQuadDidFinishLoading:(CercaMapQuad *)cercaMapQuad;

@end
