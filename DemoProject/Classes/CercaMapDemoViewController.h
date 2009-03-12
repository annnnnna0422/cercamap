//
//  CercaMapDemoViewController.h
//  CercaMapDemo
//
//  Created by Peter Zion on 12/03/09.
//  Copyright Peter Zion 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CercaMap/CercaMap.h>

@interface CercaMapDemoViewController : UIViewController
{
@public
	IBOutlet CercaMapView *cercaMapView;
	IBOutlet UISegmentedControl *segmentedControl;
}

-(IBAction) segmentedControlValueChanged:(id)sender;

@end

