//
//  MPFindService.h
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 11/18/08.
//  Copyright 2008 Consonance Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VirtualEarthKit/VEService.h>
#import <VirtualEarthKit/MPFindRequest.h>


@interface MPFindService : VEService {

}

-(VEServiceResponse *)findNearby:(MPFindRequest *)request;

@end
