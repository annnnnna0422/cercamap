//
//  CercaMapDemoAppDelegate.m
//  CercaMapDemo
//
//  Created by Peter Zion on 12/03/09.
//  Copyright Peter Zion 2009. All rights reserved.
//

#import "CercaMapDemoAppDelegate.h"
#import "CercaMapDemoViewController.h"
#import <CercaMap/CercaMap.h>
#import "config.h"

@implementation CercaMapDemoAppDelegate

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
	[CercaMapGenerator setMapServiceUsername:@VIRTUAL_EARTH_KIT_USERNAME
		password:@VIRTUAL_EARTH_KIT_PASSWORD];
	[CercaMapGenerator loadState];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

-(void) applicationWillTerminate:(UIApplication *)application
{
	[CercaMapGenerator saveState];
}

-(void) dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
