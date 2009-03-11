//
//  MPFindService.m
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 11/18/08.
//  Copyright 2008 Consonance Software. All rights reserved.
//

#import "MPFindService.h"
#import "VEServicePrivate.h"
#import "VEServiceResponse.h"
#import "MPFindResult.h"


@implementation MPFindService

-(VEServiceResponse *)findNearby:(MPFindRequest *)request
{
	xmlNodePtr xmlRequest;
	[request serializeToXMLQuery:&xmlRequest];
	NSString *server = @"http://mappoint.net/Find-30/FindService.asmx";
	if(self.realm==kVEStagingRealm)
		server = @"http://staging.mappoint.net/Find-30/FindService.asmx";
	xmlNodePtr result = [super sendVERequestWithBody:xmlRequest action:@"http://s.mappoint.net/mappoint-30/FindNearby" server:[NSURL URLWithString:server] userid:@"" password:@"" error:nil];
	xmlNodePtr body = nil;
	for(body = result->children; body; body = body->next)
	{
		if(!strcmp((char *)body->name, "FindNearbyResult"))
			result = body;
		if(!strcmp((char *)body->name, "Results"))
			break;
	}
	
	VEServiceResponse *response = nil;
	
	if(body)
		response = [[VEServiceResponse alloc] initWithXMLNode:body resultClass:[MPFindResult class] resultName:@"FindResult"];
	return response;
}

@end
