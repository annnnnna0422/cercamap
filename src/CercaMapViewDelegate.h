/*
 *  CercaMapViewDelegate.h
 *  Cerca
 *
 *  Created by Peter Zion on 10/03/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
 
#pragma mark Forward Declarations
@class CercaMapView;

@protocol CercaMapViewDelegate

@required

-(void) cercaMapView:(CercaMapView *)overlay
	didPanByDelta:(CGPoint)delta;
-(void) cercaMapViewDidZoomIn:(CercaMapView *)cercaMapView;
-(void) cercaMapViewDidZoomOut:(CercaMapView *)cercaMapView;

@end
