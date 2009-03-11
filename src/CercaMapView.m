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

-(void) layoutSubviews
{
	[delegate cercaMapViewDidResize:self];
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
				CercaMapPixel delta = CercaMapPixelMake( roundf(panStartPoint.x-panEndPoint.x), roundf(panStartPoint.y-panEndPoint.y) );
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
				CGPoint point1 = CGPointApplyAffineTransform( [[[allTouches allObjects] objectAtIndex:0] locationInView:self], self.transform );
				CGPoint point2 = CGPointApplyAffineTransform( [[[allTouches allObjects] objectAtIndex:1] locationInView:self], self.transform );
				CGFloat zoomEndDistance = [CercaMapView distanceFromPoint:point1 toPoint:point2];
				if ( zoomEndDistance >= 2 * zoomStartDistance )
				{
					[delegate cercaMapViewDidZoomIn:self];
					self.transform = CGAffineTransformIdentity;
					zoomStartDistance = zoomEndDistance;
				}
				else if ( zoomEndDistance <= 0.5 * zoomStartDistance )
				{
					[delegate cercaMapViewDidZoomOut:self];
					self.transform = CGAffineTransformIdentity;
					zoomStartDistance = zoomEndDistance;
				}
				else if ( zoomStartDistance > 0.1 )
				{
					CGFloat zoomRatio = zoomEndDistance / zoomStartDistance;
					self.transform = CGAffineTransformMake( zoomRatio, 0, 0, zoomRatio, 0, 0);
				}
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
    NSSet *allTouches = [event allTouches];
    
    switch ( [allTouches count] )
	{
       case 2:
	   {
			if ( mode == M_ZOOMING )
			{
				CGPoint point1 = CGPointApplyAffineTransform( [[[allTouches allObjects] objectAtIndex:0] locationInView:self], self.transform );
				CGPoint point2 = CGPointApplyAffineTransform( [[[allTouches allObjects] objectAtIndex:1] locationInView:self], self.transform );
				CGFloat zoomEndDistance = [CercaMapView distanceFromPoint:point1 toPoint:point2];
				if ( zoomEndDistance >= 1.4142 * zoomStartDistance )
				{
					[delegate cercaMapViewDidZoomIn:self];
				}
				else if ( zoomEndDistance <= 0.707 * zoomStartDistance )
				{
					[delegate cercaMapViewDidZoomOut:self];
				}
			}
        }
		break;
    }

	mode = M_NONE;
	self.transform = CGAffineTransformIdentity;
}

-(void) touchesCanceled
{
    mode = M_NONE;
	self.transform = CGAffineTransformIdentity;
}

@end
