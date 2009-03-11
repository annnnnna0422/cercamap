//
//  VEImageryMetadataRequest.m
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 10/28/08.
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

#import "VEImageryMetadataRequest.h"


@implementation VEImageryMetadataRequest


@synthesize heading=m_heading;
@synthesize location = m_location;
@synthesize returnImageryProviders = m_returnImageryProviders;
@synthesize zoomLevel = m_zoomLevel;
@synthesize style = m_style;

-(NSError *)serializeToXMLQuery:(xmlNodePtr *)query
{
	
	xmlNodePtr ImageryRequest = NULL;
	ImageryRequest = xmlNewNode(NULL, BAD_CAST "GetImageryMetadata");
    xmlNewProp(ImageryRequest, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/imagery/contracts");
	
	
	xmlNodePtr request = xmlNewNode(NULL, BAD_CAST "request");
    xmlNewProp(request, BAD_CAST "xmlns:a", BAD_CAST "http://dev.virtualearth.net/webservices/v1/imagery");
    xmlNewProp(request, BAD_CAST "xmlns:i", BAD_CAST "http://www.w3.org/2001/XMLSchema-instance");
	xmlAddChild(ImageryRequest, request);
	[self addStandardAttributesToNode:request];
	
	xmlNodePtr options = xmlNewNode(NULL, BAD_CAST "a:Options");
	xmlAddChild(request, options);
	
	xmlNodePtr location = xmlNewNode(NULL, BAD_CAST "a:Location");
    xmlNewProp(location, BAD_CAST "xmlns:b", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(options, location);
	
	xmlNodePtr altitude = xmlNewNode(NULL, BAD_CAST "b:Altitude");
	xmlNodeSetContent(altitude, BAD_CAST [[NSString stringWithFormat:@"%g", self.location.altitude] cString]);
	xmlAddChild(location, altitude);
	
	xmlNodePtr Latitude = xmlNewNode(NULL, BAD_CAST "b:Latitude");
	xmlNodeSetContent(Latitude, BAD_CAST [[NSString stringWithFormat:@"%g", self.location.coordinate.latitude] cString]);
	xmlAddChild(location, Latitude);
	
	xmlNodePtr Longitude = xmlNewNode(NULL, BAD_CAST "b:Longitude");
	xmlNodeSetContent(Longitude, BAD_CAST [[NSString stringWithFormat:@"%g", self.location.coordinate.longitude] cString]);
	xmlAddChild(location, Longitude);
	
	xmlNodePtr zoomLevelNode = xmlNewNode(NULL, BAD_CAST "a:ZoomLevel");
	xmlNodeSetContent(zoomLevelNode, BAD_CAST [[NSString stringWithFormat:@"%i", self.zoomLevel] cString]);
	xmlAddChild(options, zoomLevelNode);
	
	
	xmlNodePtr returnImager = xmlNewNode(NULL, BAD_CAST "a:ReturnImageryProvider");
	if(self.returnImageryProviders)
		xmlNodeSetContent(returnImager, BAD_CAST "true");
	else
		xmlNodeSetContent(returnImager, BAD_CAST "false");
	xmlAddChild(options, returnImager);
	
	xmlNodePtr uriScheme = xmlNewNode(NULL, BAD_CAST "a:UriScheme");
	xmlNodeSetContent(uriScheme, BAD_CAST "Http");
	xmlAddChild(options, uriScheme);
	
	xmlNodePtr heading = xmlNewNode(NULL, BAD_CAST "a:Heading");
    xmlNewProp(heading, BAD_CAST "i:nil", BAD_CAST "true");
    xmlNewProp(heading, BAD_CAST "xmlns:b", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(options, heading);
	
	xmlNodePtr mapType = xmlNewNode(NULL, BAD_CAST "a:Style");
	if(self.style==kVEMapStyleRoad)
		xmlNodeSetContent(mapType, BAD_CAST "Road");
	if(self.style==kVEMapStyleAerial)
		xmlNodeSetContent(mapType, BAD_CAST "Aerial");
	if(self.style==kVEMapStyleAerialWithLabels)
		xmlNodeSetContent(mapType, BAD_CAST "AerialWithLabels");
	if(self.style==kVEMapStyleBirdseye)
		xmlNodeSetContent(mapType, BAD_CAST "Birdseye");
	if(self.style==kVEMapStyleBirdseyeWithLabels)
		xmlNodeSetContent(mapType, BAD_CAST "BirdseyeWithLabels");
	
	xmlAddChild(request, mapType);
	
	*query=ImageryRequest;
	return nil;
}

-(void)dealloc
{
	self.location = nil;
	[super dealloc];
}

@end
