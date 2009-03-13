//
//  CercaMapDemoAppDelegate.h
//  CercaMapDemo
//
//  Created by Peter Zion on 12/03/09.
//  Copyright Peter Zion 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CercaMapDemoViewController;

@interface CercaMapDemoAppDelegate : NSObject
	<UIApplicationDelegate>
{
    IBOutlet UIWindow *window;
    IBOutlet CercaMapDemoViewController *viewController;
}

@end

