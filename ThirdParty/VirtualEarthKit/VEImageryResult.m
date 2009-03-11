//
//  VEImageryResult.m
//  MapViewTest
//
//  Created by Colin Cornaby on 10/12/08.
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

#import "VEImageryResult.h"


@implementation VEImageryResult

@synthesize imageURL = m_imageURL;

-(id)initWithXMLNode:(xmlNodePtr)node resultClass:(id)resultClass
{
	self = [super init];
	xmlNodePtr currentNode = nil;
	for(currentNode = node->children; currentNode; currentNode = currentNode->next)
	{
		if(!strcmp((char *)currentNode->name, "Results"))
		{
			xmlNodePtr childNode = nil;
			for(childNode = currentNode->children; childNode; childNode = childNode->next)
			{
				if(!strcmp((char *)childNode->name, "ImageryMetadataResult"))
				{
					xmlNodePtr grandchildNode = nil;
					for(grandchildNode = childNode->children; grandchildNode; grandchildNode = grandchildNode->next)
					{
						if(!strcmp((char *)grandchildNode->name, "ImageUri"))
						{
							NSString *urlString = [[NSString alloc] initWithCString:(char *)xmlNodeGetContent(grandchildNode) encoding:NSUTF8StringEncoding];
							NSString *correctedString = [urlString stringByReplacingOccurrencesOfString:@"{culture}" withString:@""];
							correctedString = [correctedString stringByReplacingOccurrencesOfString:@"{token}" withString:@""];
							correctedString = [correctedString stringByReplacingOccurrencesOfString:@"hill" withString:@"none"];
							m_imageURL = [[NSURL alloc] initWithString:correctedString];
							[urlString release];
						}
					}
				}
			}
		}
	}
	return self;
}

-(void)dealloc
{
	if(m_imageURL)
		[m_imageURL release];
	[super dealloc];
}

@end
