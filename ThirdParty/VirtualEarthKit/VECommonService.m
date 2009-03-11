//
//  VECommonService.m
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 10/21/08.
//  Copyright 2008 Consonance Software. All rights reserved.
//

//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions
//are met:
//1. Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//2. Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//3. Neither the name of the author nor the names of any co-contributors
//   may be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
//FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
//OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
//OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
//SUCH DAMAGE.
//

#import <Foundation/Foundation.h>
#import <VirtualEarthKit/VEService.h>

#import "VECommonService.h"
#import "VEServicePrivate.h"
#include <libxml/parser.h>
#include <libxml/tree.h>


@implementation VECommonService

-(NSError *)getToken:(NSString **)token forUserID:(NSString *)userID password:(NSString *)password ipAddress:(NSString *)ipAddress
{
	NSString *tokenFromPrefs = [[NSUserDefaults standardUserDefaults] objectForKey:@"VEKitToken"];
	NSDate *tokenDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"VEKitTokenExpiration"];
	int timeIntervalSinceNow = [tokenDate timeIntervalSinceNow];
	if(tokenFromPrefs&&timeIntervalSinceNow>0)
	{
		*token = [tokenFromPrefs retain];
		return NULL;
	}
	xmlNodePtr GetClientToken = NULL, specification = NULL;
	GetClientToken = xmlNewNode(NULL, BAD_CAST "GetClientToken");
    xmlNewProp(GetClientToken, BAD_CAST "xmlns", BAD_CAST "http://s.mappoint.net/mappoint-30/");
	specification = xmlNewNode(NULL, BAD_CAST "specification");
	xmlAddChild(GetClientToken, specification);
    xmlNewChild(specification, NULL, BAD_CAST "ClientIPAddress",
                BAD_CAST [ipAddress cStringUsingEncoding:NSASCIIStringEncoding]);
    xmlNewChild(specification, NULL, BAD_CAST "TokenValidityDurationMinutes",
                BAD_CAST "480");
	
	NSString *server = @"http://common.virtualearth.net/find-30/common.asmx";
	if(self.realm == kVEStagingRealm)
		server = @"http://staging.common.virtualearth.net/find-30/common.asmx";
	
	xmlNodePtr result = [super sendVERequestWithBody:GetClientToken action:@"http://s.mappoint.net/mappoint-30/GetClientToken"
											  server:[NSURL URLWithString:server] userid:userID password:password error:nil];
	xmlFreeNode(GetClientToken);
	
    xmlNodePtr tokenNode = NULL;
	for(tokenNode = result->children; tokenNode; tokenNode = tokenNode->next)
	{
		if(!strcmp((char *)tokenNode->name, "GetClientTokenResult"))
			break;
	}
	const char * tokenAsCharStar = (const char *)xmlNodeGetContent(tokenNode);
	*token = [[NSString alloc] initWithCString:tokenAsCharStar encoding:NSASCIIStringEncoding];
	[[NSUserDefaults standardUserDefaults] setObject:*token forKey:@"VEKitToken"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSinceNow:28800] forKey:@"VEKitTokenExpiration"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	return NULL;
}

@end
