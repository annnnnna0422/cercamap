//
//  VERequest.m
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

#import "VERequest.h"
#import "VERequestPrivate.h"


@implementation VERequest

NSString *m_defaultToken = nil;

@synthesize userProfile = m_userProfile;
@synthesize token = m_token;

-(id)init
{
	self = [super init];
	if(m_defaultToken)
		self.token = m_defaultToken;
	return self;
}

+(void)setDefaultToken:(NSString *)token
{
	if(m_defaultToken)
		[m_defaultToken release];
	m_defaultToken = [token retain];
}

-(NSError *)addStandardAttributesToNode:(xmlNodePtr)query
{
	xmlNodePtr Credentials = NULL;
	Credentials = xmlNewNode(NULL, BAD_CAST "Credentials");
    xmlNewProp(Credentials, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(query, Credentials);
	
	xmlNodePtr culture = xmlNewNode(NULL, BAD_CAST "Culture");
    xmlNewProp(culture, BAD_CAST "i:nil", BAD_CAST "true");
    xmlNewProp(culture, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(query, culture);
	
	xmlNodePtr execOptions = xmlNewNode(NULL, BAD_CAST "ExecutionOptions");
    xmlNewProp(execOptions, BAD_CAST "i:nil", BAD_CAST "true");
    xmlNewProp(execOptions, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(query, execOptions);
	
	if(self.userProfile)
	{
		[self.userProfile appendUserDataToNode:query];
	}else{
		xmlNodePtr userProfile = xmlNewNode(NULL, BAD_CAST "UserProfile");
		xmlNewProp(userProfile, BAD_CAST "i:nil", BAD_CAST "true");
		xmlNewProp(userProfile, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
		xmlAddChild(query, userProfile);
	}
	
    xmlNewChild(Credentials, NULL, BAD_CAST "Token",
                BAD_CAST [self.token cStringUsingEncoding:NSASCIIStringEncoding]);
	xmlNodePtr applicationId = xmlNewNode(NULL, BAD_CAST "ApplicationId");
    xmlNewProp(applicationId, BAD_CAST "i:nil", BAD_CAST "true");
	xmlAddChild(Credentials, applicationId);
	return nil;
}

-(NSError *)serializeToXMLQuery:(xmlNodePtr *)query
{
	return nil;
}

@end
