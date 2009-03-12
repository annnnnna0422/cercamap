//
//  CercaMapDemoAppDelegate.m
//  CercaMapDemo
//
//  Created by Peter Zion on 12/03/09.
//  Copyright Peter Zion 2009. All rights reserved.
//

#import "CercaMapDemoAppDelegate.h"
#import "CercaMapDemoViewController.h"

@implementation CercaMapDemoAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
