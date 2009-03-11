//
//  VEGetMapURIRequest.m
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 10/29/08.
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

#import "VEGetMapURIRequest.h"
#import "VELocationUtilities.h"
#import "VEPushPin.h"


@implementation VEGetMapURIRequest

@synthesize center = m_center;
@synthesize zoomLevel = m_zoomLevel;
@synthesize pushpins = m_pushpins;
@synthesize mapSize = m_mapSize;

-(id)init
{
	self = [super init];
	self.pushpins = [NSArray array];
	self.mapSize = CGSizeMake(350, 350);
	return self;
}

-(NSError *)serializeToXMLQuery:(xmlNodePtr *)query
{
	
	xmlNodePtr ImageryRequest = NULL;
	ImageryRequest = xmlNewNode(NULL, BAD_CAST "GetMapUri");
    xmlNewProp(ImageryRequest, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/imagery/contracts");
	
	
	xmlNodePtr request = xmlNewNode(NULL, BAD_CAST "request");
    xmlNewProp(request, BAD_CAST "xmlns:a", BAD_CAST "http://dev.virtualearth.net/webservices/v1/imagery");
    xmlNewProp(request, BAD_CAST "xmlns:i", BAD_CAST "http://www.w3.org/2001/XMLSchema-instance");
	xmlAddChild(ImageryRequest, request);
	[self addStandardAttributesToNode:request];
	
	xmlNodePtr location = xmlNewNode(NULL, BAD_CAST "a:Center");
	if(!self.center)
		xmlNewProp(location, BAD_CAST "i:nil", BAD_CAST "true");
	else
	{
		xmlNewProp(location, BAD_CAST "xmlns:b", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
		[VELocationUtilities addLocation:self.center toNode:location];
	}
	xmlAddChild(request, location);
	
	
	xmlNodePtr majorRoutes = xmlNewNode(NULL, BAD_CAST "a:MajorRoutesDestination");
    xmlNewProp(majorRoutes, BAD_CAST "i:nil", BAD_CAST "true");
    xmlNewProp(majorRoutes, BAD_CAST "xmlns:b", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(request, majorRoutes);
	
	//options code
	
	xmlNodePtr options = xmlNewNode(NULL, BAD_CAST "a:Options");
	
	xmlNodePtr displayLayers = xmlNewNode(NULL, BAD_CAST "a:DisplayLayers");
	xmlAddChild(options, displayLayers);
	
	xmlNodePtr imageSize = xmlNewNode(NULL, BAD_CAST "a:ImageSize");
	
	char * widthString = (char *)[[NSString stringWithFormat:@"%i", (int)self.mapSize.width] cStringUsingEncoding:NSASCIIStringEncoding];
	char * heightString = (char *)[[NSString stringWithFormat:@"%i", (int)self.mapSize.height] cStringUsingEncoding:NSASCIIStringEncoding];
	
	xmlNodePtr width = xmlNewNode(NULL, BAD_CAST "b:Width");
	xmlNodeSetContent(width, BAD_CAST widthString);
	xmlAddChild(imageSize, width);
	
	xmlNodePtr height = xmlNewNode(NULL, BAD_CAST "b:Height");
	xmlNodeSetContent(height, BAD_CAST heightString);
	xmlAddChild(imageSize, height);
	
	xmlNodePtr imageType = xmlNewNode(NULL, BAD_CAST "a:ImageType");
	xmlNodeSetContent(imageType, BAD_CAST "Default");
	xmlAddChild(options, imageType);
	
	xmlNodePtr preventCollision = xmlNewNode(NULL, BAD_CAST "a:PreventIconCollision");
	xmlNodeSetContent(preventCollision, BAD_CAST "false");
	xmlAddChild(options, preventCollision);
	
	
	xmlNodePtr style = xmlNewNode(NULL, BAD_CAST "a:Style");
	xmlNodeSetContent(style, BAD_CAST "Road");
	xmlAddChild(options, style);
	
	xmlNodePtr uriScheme = xmlNewNode(NULL, BAD_CAST "a:UriScheme");
	xmlNodeSetContent(uriScheme, BAD_CAST "Http");
	xmlAddChild(options, uriScheme);
	
	char * zoomLevelString = (char *)[[NSString stringWithFormat:@"%i", self.zoomLevel] cStringUsingEncoding:NSASCIIStringEncoding];
	xmlNodePtr ZoomLevel = xmlNewNode(NULL, BAD_CAST "a:ZoomLevel");
	xmlNodeSetContent(ZoomLevel, BAD_CAST zoomLevelString);
	xmlAddChild(options, ZoomLevel);
	
	//end options code
	xmlAddChild(request, options);
	
	xmlNodePtr pushpins = xmlNewNode(NULL, BAD_CAST "a:Pushpins");
	if(!self.pushpins||[self.pushpins count]==0)
		xmlNewProp(pushpins, BAD_CAST "i:nil", BAD_CAST "true");
	else {
		for(VEPushPin *pin in self.pushpins)
		{
			xmlNodePtr nodeForPin = [pin xmlNode];
			xmlAddChild(pushpins, nodeForPin);
		}
	}
    xmlNewProp(pushpins, BAD_CAST "xmlns:b", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(request, pushpins);
	
	*query=ImageryRequest;
	return nil;
}

-(void)dealloc
{
	self.center = nil;
	[super dealloc];
}

@end
