//
//  CercaMapDemoAppDelegate.h
//  CercaMapDemo
//
//  Created by Peter Zion on 12/03/09.
//  Copyright Peter Zion 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CercaMapDemoViewController;

@interface CercaMapDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CercaMapDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CercaMapDemoViewController *viewController;

@end

