//
//  VEService.m
//  LiveEarthTestApp
//
//  Created by Colin Cornaby on 9/27/08.
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

#import "VEService.h"
#import "VESOAPRequest.h"
#import "VEServicePrivate.h"


@implementation VEService

@synthesize session=m_session;
@synthesize userProfile=m_userProfile;
@synthesize realm=m_realm;

-(id)initWithParentSession:(VESession *)session
{
	self = [super init];
	m_session = [session retain];
	m_userProfile=nil;
	return self;
}
/*
-(void)addStandardAttributesToRequest:(xmlNodePtr)node
{
	xmlNodePtr Credentials = NULL;
	Credentials = xmlNewNode(NULL, BAD_CAST "Credentials");
    xmlNewProp(Credentials, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(node, Credentials);
	
	xmlNodePtr culture = xmlNewNode(NULL, BAD_CAST "Culture");
    xmlNewProp(culture, BAD_CAST "i:nil", BAD_CAST "true");
    xmlNewProp(culture, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(node, culture);
	
	xmlNodePtr execOptions = xmlNewNode(NULL, BAD_CAST "ExecutionOptions");
    xmlNewProp(execOptions, BAD_CAST "i:nil", BAD_CAST "true");
    xmlNewProp(execOptions, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(node, execOptions);
	
	if(self.userProfile)
	{
		[self.userProfile appendUserDataToNode:node];
	}else{
		xmlNodePtr userProfile = xmlNewNode(NULL, BAD_CAST "UserProfile");
		xmlNewProp(userProfile, BAD_CAST "i:nil", BAD_CAST "true");
		xmlNewProp(userProfile, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
		xmlAddChild(node, userProfile);
	}
	
    xmlNewChild(Credentials, NULL, BAD_CAST "Token",
                BAD_CAST [self.session.token cStringUsingEncoding:NSASCIIStringEncoding]);
	xmlNodePtr applicationId = xmlNewNode(NULL, BAD_CAST "ApplicationId");
    xmlNewProp(applicationId, BAD_CAST "i:nil", BAD_CAST "true");
	xmlAddChild(Credentials, applicationId);
}*/

-(xmlNodePtr)sendVERequestWithBody:(xmlNodePtr)body action:(NSString *)action server:(NSURL *)server userid:(NSString *)userid password:(NSString *)password error:(NSError **)error
{
	VESOAPRequest *connection = [[VESOAPRequest alloc] init];
	connection.userID = userid;
	connection.password = password;
	error = nil;
	xmlNodePtr result = [connection sendSOAPBody:body toServer:server action:action error:error];
	[connection release];
	return result;
}


-(xmlNodePtr)sendVERequestWithBody:(xmlNodePtr)body action:(NSString *)action server:(NSURL *)server error:(NSError **)error
{
	return [self sendVERequestWithBody:body action:action server:server userid:nil password:nil error:error];
}

@end
