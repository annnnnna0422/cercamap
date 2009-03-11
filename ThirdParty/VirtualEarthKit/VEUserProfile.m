//
//  VEUserProfile.m
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

#import "VEUserProfile.h"


@implementation VEUserProfile

@synthesize unit=m_unit, deviceType=m_deviceType;

-(void)appendUserDataToNode:(xmlNodePtr)node
{
	xmlNodePtr userProfile = xmlNewNode(NULL, BAD_CAST "UserProfile");
    xmlNewProp(userProfile, BAD_CAST "xmlns", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
	xmlAddChild(node, userProfile);
	
	xmlNodePtr heading = xmlNewNode(NULL, BAD_CAST "CurrentHeading");
    xmlNewProp(heading, BAD_CAST "i:nil", BAD_CAST "true");
	xmlAddChild(userProfile, heading);
	
	char * deviceType = "Desktop";
	
	if(self.deviceType==VEDeviceMobile)
		deviceType = "Mobile";
	
	xmlNodePtr deviceTypeNode = xmlNewNode(NULL, BAD_CAST "DeviceType");
	xmlNodeSetContent(deviceTypeNode, BAD_CAST deviceType);
	xmlAddChild(userProfile, deviceTypeNode);
	
	int unit = self.unit;
	
	if(unit==0)
	{
		unit = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
		if([[[NSLocale currentLocale] objectForKey:@"NSLocaleCountryCode"] isEqualToString:@"GB"])
			unit = NO;
	}
	char * unitString;
	if(unit==1)
		unitString = "Kilometer";
	else
		unitString = "Mile";
	
	xmlNodePtr unitNode = xmlNewNode(NULL, BAD_CAST "DistanceUnit");
	xmlNodeSetContent(unitNode, BAD_CAST unitString);
	xmlAddChild(userProfile, unitNode);
	
	xmlNodePtr ipAddress = xmlNewNode(NULL, BAD_CAST "IPAddress");
    xmlNewProp(ipAddress, BAD_CAST "i:nil", BAD_CAST "true");
	xmlAddChild(userProfile, ipAddress);
	
	xmlNodePtr mapView = xmlNewNode(NULL, BAD_CAST "MapView");
    xmlNewProp(mapView, BAD_CAST "i:nil", BAD_CAST "true");
	xmlAddChild(userProfile, mapView);
	
	xmlNodePtr screenSize = xmlNewNode(NULL, BAD_CAST "ScreenSize");
    xmlNewProp(screenSize, BAD_CAST "i:nil", BAD_CAST "true");
	xmlAddChild(userProfile, screenSize);
	
	xmlNodePtr currentLocation = xmlNewNode(NULL, BAD_CAST "CurrentLocation");
    xmlNewProp(currentLocation, BAD_CAST "i:nil", BAD_CAST "true");
	xmlAddChild(userProfile, currentLocation);
}

@end
