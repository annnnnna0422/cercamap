//
//  VEReverseGeocodeRequest.m
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

#import "VEReverseGeocodeRequest.h"


@implementation VEReverseGeocodeRequest

@synthesize location = m_location;

-(NSError *)serializeToXMLQuery:(xmlNodePtr *)query
{
	
	xmlNodePtr GeocodeRequest = NULL;
	GeocodeRequest = xmlNewNode(NULL, BAD_CAST "ReverseGeocode");
    xmlNewProp(GeocodeRequest, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/geocode/contracts");
	
	
	xmlNodePtr request = xmlNewNode(NULL, BAD_CAST "request");
    xmlNewProp(request, BAD_CAST "xmlns:a", BAD_CAST "http://dev.virtualearth.net/webservices/v1/geocode");
    xmlNewProp(request, BAD_CAST "xmlns:i", BAD_CAST "http://www.w3.org/2001/XMLSchema-instance");
	xmlAddChild(GeocodeRequest, request);
	[self addStandardAttributesToNode:request];
	
	
	xmlNodePtr location = xmlNewNode(NULL, BAD_CAST "a:Location");
    xmlNewProp(location, BAD_CAST "xmlns:b", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(request, location);
	
	xmlNodePtr altitude = xmlNewNode(NULL, BAD_CAST "b:Altitude");
	xmlNodeSetContent(altitude, BAD_CAST [[NSString stringWithFormat:@"%g", self.location.altitude] cString]);
	xmlAddChild(location, altitude);
	
	xmlNodePtr Latitude = xmlNewNode(NULL, BAD_CAST "b:Latitude");
	xmlNodeSetContent(Latitude, BAD_CAST [[NSString stringWithFormat:@"%g", self.location.coordinate.latitude] cString]);
	xmlAddChild(location, Latitude);
	
	xmlNodePtr Longitude = xmlNewNode(NULL, BAD_CAST "b:Longitude");
	xmlNodeSetContent(Longitude, BAD_CAST [[NSString stringWithFormat:@"%g", self.location.coordinate.longitude] cString]);
	xmlAddChild(location, Longitude);
	
	*query=GeocodeRequest;
	return nil;
}

@end
