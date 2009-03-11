//
//  CercaAppController.m
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CercaAppController.h"

@implementation CercaAppController

#pragma mark Lifecycle

-(void) dealloc
{
    [tabBarController release];
    [window release];
    [super dealloc];
}

#pragma mark UIApplicationDelegate

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
    [window addSubview:tabBarController.view];
}

@end

