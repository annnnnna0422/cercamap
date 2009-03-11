//
//  VEServiceResponse.m
//  LiveEarthTestApp
//
//  Created by Colin Cornaby on 10/9/08.
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

#import "VEServiceResponse.h"


@implementation VEServiceResponse

@synthesize results = m_results;

-(id)initWithXMLNode:(xmlNodePtr)node resultClass:(id)resultClass resultName:(char *)resultName
{
	self = [super init];
	m_results = [[NSMutableArray alloc] init];
	xmlNodePtr currentNode = nil;
	for(currentNode = node->children; currentNode; currentNode = currentNode->next)
	{
		if(!strcmp((char *)currentNode->name, "ResponseSummary"))
			[self loadResponseDataFromNode:currentNode];
		if(!strcmp((char *)currentNode->name, resultName))
		{
			xmlNodePtr currentResult = nil;
			for(currentResult = currentNode->children; currentResult; currentResult = currentResult->next)
			{
				VEResult *result = [[resultClass alloc] initWithContentsNode:currentResult];
				[m_results addObject:result];
			}
		}
	}
	return self;
}


-(id)initWithXMLNode:(xmlNodePtr)node resultClass:(id)resultClass
{
	self = [self initWithXMLNode:node resultClass:resultClass resultName:"Results"];
	return self;
}

-(void)loadResponseDataFromNode:(xmlNodePtr)node
{
	xmlNodePtr currentNode = nil;
	for(currentNode = node->children; currentNode; currentNode = currentNode->next)
	{
		if(!strcmp((char *)currentNode->name, "AuthenticationResultCode"))
		{
			char * resultCode = (char *)xmlNodeGetContent(currentNode);
			m_authenticationResultsCode = [[NSString alloc] initWithCString:resultCode];
		}
		if(!strcmp((char *)currentNode->name, "Copyright"))
		{
			char * copyright = (char *)xmlNodeGetContent(currentNode);
			m_copyright = [[NSString alloc] initWithCString:copyright];
		}
		if(!strcmp((char *)currentNode->name, "FaultReason"))
		{
			char * faultReason = (char *)xmlNodeGetContent(currentNode);
			if(faultReason)
				m_faultReason = [[NSString alloc] initWithCString:faultReason];
		}
		if(!strcmp((char *)currentNode->name, "StatusCode"))
		{
			char * statusCode = (char *)xmlNodeGetContent(currentNode);
			if(statusCode)
				m_statusCode = [[NSString alloc] initWithCString:statusCode];
		}
		if(!strcmp((char *)currentNode->name, "TraceId"))
		{
			char * traceID = (char *)xmlNodeGetContent(currentNode);
			if(traceID)
				m_traceID = [[NSString alloc] initWithCString:traceID];
		}
	}
}

@end
