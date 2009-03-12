//
//  CercaMapView.m
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CercaMapView.h"
#import "CercaMapViewDelegate.h"

@implementation CercaMapView

#pragma mark Private

+(CGFloat) distanceFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2
{
	return sqrt( (point2.x - point1.x) * (point2.x - point1.x) + (point2.y - point1.y) * (point2.y - point1.y) );
}

+(CGPoint) midpointBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2
{
	return CGPointMake( (point1.x + point2.x)/2, (point1.y + point2.y)/2 );
}

+(CGPoint) closestPointToPoint:(CGPoint)point betweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2
{
	CGFloat point1Dist = [self distanceFromPoint:point toPoint:point1];
	CGFloat point2Dist = [self distanceFromPoint:point toPoint:point2];
	if ( point1Dist < point2Dist )
		return point1;
	else
		return point2;
}

#pragma mark UIView

-(void) drawRect:(CGRect)rect
{
	[delegate cercaMapView:self
		drawToDstRect:self.bounds];
}

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	numPoints = 0;
	for ( UITouch *touch in touches )
	{
		points[numPoints++] = [touch locationInView:self];
		if ( numPoints == 2 )
			break;
	}
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	int newNumPoints = 0;
	CGPoint newPoints[2];
	for ( UITouch *touch in [event allTouches] )
	{
		newPoints[newNumPoints++] = [touch locationInView:self];
		if ( newNumPoints == 2 )
			break;
	}
	
	if ( newNumPoints >= 1 && numPoints >= 1 )
	{
		CGPoint startPoint, endPoint;
		if ( numPoints == 2 )
		{
			if ( newNumPoints == 2 )
			{
				startPoint = [CercaMapView midpointBetweenPoint:points[0] andPoint:points[1]];
				endPoint = [CercaMapView midpointBetweenPoint:newPoints[0] andPoint:newPoints[1]];
			}
			else
			{
				startPoint = [CercaMapView closestPointToPoint:newPoints[0] betweenPoint:points[0] andPoint:points[1]];
				endPoint = newPoints[0];
			}
		}
		else
		{
			if ( newNumPoints == 2 )
			{
				startPoint = points[0];
				endPoint = [CercaMapView closestPointToPoint:points[0] betweenPoint:newPoints[0] andPoint:newPoints[1]];
			}
			else
			{
				startPoint = points[0];
				endPoint = newPoints[0];
			}
		}
		CGPoint delta = CGPointMake( startPoint.x - endPoint.x, startPoint.y - endPoint.y );
		[delegate cercaMapView:self didPanByDelta:delta];
	}
	
	if ( newNumPoints == 2 && numPoints == 2 )
	{
		CGFloat startDistance = [CercaMapView distanceFromPoint:points[0] toPoint:points[1]];
		CGFloat endDistance = [CercaMapView distanceFromPoint:newPoints[0] toPoint:newPoints[1]];
		if ( startDistance > 1 )
			[delegate cercaMapView:self didZoomByScale:endDistance/startDistance];
	}

	numPoints = newNumPoints;
	for ( int i=0; i<numPoints; ++i )
		points[i] = newPoints[i];
}

@end
