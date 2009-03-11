//
//  CercaAppController.h
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CercaAppController : NSObject
	<UIApplicationDelegate,
		UITabBarControllerDelegate>
{
@private
    IBOutlet UIWindow *window;
    IBOutlet UITabBarController *tabBarController;
}

@end
