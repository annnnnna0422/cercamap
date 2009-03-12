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

#pragma mark Lifecycle

-(void) awakeFromNib
{
	mode = M_NONE;
}

#pragma mark UIView

-(void) drawRect:(CGRect)rect
{
	[delegate cercaMapView:self
		drawToContext:UIGraphicsGetCurrentContext()
		dstRect:self.bounds];
}

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSSet *allTouches = [event allTouches];
    
    switch ( [allTouches count] )
	{
        case 1:
		{
			mode = M_PANNING;
			panStartPoint = [[[allTouches allObjects] objectAtIndex:0] locationInView:self];
        }
		break;
		
        case 2:
		{
			mode = M_ZOOMING;
            CGPoint point1 = [[[allTouches allObjects] objectAtIndex:0] locationInView:self];
            CGPoint point2 = [[[allTouches allObjects] objectAtIndex:1] locationInView:self];
            zoomStartDistance = [CercaMapView distanceFromPoint:point1 toPoint:point2];
        }
		break;
		
        default:
            mode = M_NONE;
            break;
    }
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSSet *allTouches = [event allTouches];
    
    switch ( [allTouches count] )
	{
        case 1:
		{
            if ( mode == M_PANNING )
			{
				CGPoint panEndPoint = [[[allTouches allObjects] objectAtIndex:0] locationInView:self];
				CercaMapPoint delta = CercaMapPointMake( roundf(panStartPoint.x-panEndPoint.x), roundf(panStartPoint.y-panEndPoint.y) );
				[delegate cercaMapView:self didPanByDelta:delta];
				panStartPoint = panEndPoint;
			}
			else
				mode = M_NONE;
        }
		break;
        
       case 2:
	   {
			if ( mode == M_ZOOMING )
			{
				CGPoint point1 = [[[allTouches allObjects] objectAtIndex:0] locationInView:self];
				CGPoint point2 = [[[allTouches allObjects] objectAtIndex:1] locationInView:self];
				CGFloat zoomEndDistance = [CercaMapView distanceFromPoint:point1 toPoint:point2];
				[delegate cercaMapView:self didZoomByScale:zoomEndDistance/zoomStartDistance];
				zoomStartDistance = zoomEndDistance;
			}
			else
				mode = M_NONE;
        }
		break;
		
        default:
            mode = M_NONE;
            break;
    }
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	mode = M_NONE;
}

-(void) touchesCanceled
{
    mode = M_NONE;
}

@end
