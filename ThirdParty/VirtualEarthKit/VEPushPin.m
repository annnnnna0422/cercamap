//
//  VEPushPin.m
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 10/30/08.
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

#import "VEPushPin.h"
#import "VELocationUtilities.h"


@implementation VEPushPin

@synthesize iconStyle = m_iconStyle, label = m_label, location = m_location;

-(xmlNodePtr)xmlNode
{
	
	xmlNodePtr pushpin = xmlNewNode(NULL, BAD_CAST "b:Pushpin");
	
	xmlNodePtr style = xmlNewNode(NULL, BAD_CAST "b:IconStyle");
	//xmlNewProp(style, BAD_CAST "i:nil", BAD_CAST "true");
	NSString * styleAsString = [NSString stringWithFormat:@"%i", self.iconStyle];
	xmlNodeSetContent(style, BAD_CAST [styleAsString cStringUsingEncoding:NSASCIIStringEncoding]);
	xmlAddChild(pushpin, style);
	
	
	xmlNodePtr label = xmlNewNode(NULL, BAD_CAST "b:Label");
	if(!self.label)
	{
		xmlNewProp(label, BAD_CAST "i:nil", BAD_CAST "true");
	}else{
		xmlNodeSetContent(label, BAD_CAST [self.label cStringUsingEncoding:NSASCIIStringEncoding]);
	}
	xmlAddChild(pushpin, label);
	
	xmlNodePtr location = xmlNewNode(NULL, BAD_CAST "b:Location");
	[VELocationUtilities addLocation:self.location toNode:location];
	xmlAddChild(pushpin, location);
	
	return pushpin;
	
}

@end
