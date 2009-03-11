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
			panStartPoint = CGPointApplyAffineTransform( [[[allTouches allObjects] objectAtIndex:0] locationInView:self], self.transform );
        }
		break;
		
        case 2:
		{
			mode = M_ZOOMING;
            CGPoint point1 = CGPointApplyAffineTransform( [[[allTouches allObjects] objectAtIndex:0] locationInView:self], self.transform );
            CGPoint point2 = CGPointApplyAffineTransform( [[[allTouches allObjects] objectAtIndex:1] locationInView:self], self.transform );
            zoomStartDistance = [CercaMapView distanceFromPoint:point1 toPoint:point2];
			zoomStartScale = self.transform.a;
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
				CGPoint panEndPoint = CGPointApplyAffineTransform( [[[allTouches allObjects] objectAtIndex:0] locationInView:self], self.transform );
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
				CGFloat zoomEndScale = zoomStartScale * zoomEndDistance / zoomStartDistance;
				if ( zoomEndScale >= 1.4142 )
				{
					[delegate cercaMapViewDidZoomIn:self];
					zoomEndScale /= 2;
					zoomStartScale /= 2;
				}
				else if ( zoomEndScale <= 0.5 )
				{
					[delegate cercaMapViewDidZoomOut:self];
					zoomEndScale *= 2;
					zoomStartScale *= 2;
				}
				self.transform = CGAffineTransformMake( zoomEndScale, 0, 0, zoomEndScale, 0, 0);
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
	self.transform = CGAffineTransformIdentity;
}

@end
