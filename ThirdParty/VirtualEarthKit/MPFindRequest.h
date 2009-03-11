//
//  MPFindRequest.h
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 11/18/08.
//  Copyright 2008 Consonance Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VirtualEarthKit/MPRequest.h>
#import <CoreLocation/CoreLocation.h>


@interface MPFindRequest : MPRequest {
	CLLocation *m_location;
	float m_distance;
	NSString *m_filter;
	NSString *m_datasourceName;
}

@property (retain) CLLocation *location;
@property float distance;
@property (retain) NSString *filter;
@property (retain) NSString *datasourceName;

@end
