//
//  VEGeocodeResult.m
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

#import "VEGeocodeResult.h"
#import <AddressBook/AddressBook.h>


@implementation VEGeocodeResult

@synthesize name=m_name;
@synthesize location=m_location;
@synthesize address=m_address;

-(id)initWithContentsNode:(xmlNodePtr)node
{
	self = [super init];
	xmlNodePtr currentNode = nil;
	m_address=[[NSMutableDictionary alloc] init];
	for(currentNode = node->children; currentNode; currentNode = currentNode->next)
	{
		if(!strcmp((char *)currentNode->name, "DisplayName"))
			m_name = [[NSString alloc] initWithCString:(char *)xmlNodeGetContent(currentNode) encoding:NSUTF8StringEncoding];
		if(!strcmp((char *)currentNode->name, "Locations"))
		{
			xmlNodePtr location = currentNode->children;
			double lat, longitude, alt;
			xmlNodePtr currentElement = nil;
			for(currentElement = location->children; currentElement; currentElement = currentElement->next)
			{
				if(!strcmp((char *)currentElement->name, "Latitude"))
					lat = [[NSString stringWithCString:(char *)xmlNodeGetContent(currentElement)] floatValue];
				if(!strcmp((char *)currentElement->name, "Longitude"))
					longitude = [[NSString stringWithCString:(char *)xmlNodeGetContent(currentElement)] floatValue];
				if(!strcmp((char *)currentElement->name, "Altitude"))
					alt = [[NSString stringWithCString:(char *)xmlNodeGetContent(currentElement)] floatValue];
			}
			CLLocationCoordinate2D locationStruct;
			locationStruct.latitude = lat;
			locationStruct.longitude = longitude;
			m_location = [[CLLocation alloc] initWithCoordinate:locationStruct altitude:alt horizontalAccuracy:0 verticalAccuracy:-1 timestamp:[NSDate dateWithTimeIntervalSinceNow:0]];
		}
		if(!strcmp((char *)currentNode->name, "Address"))
		{
			xmlNodePtr currentElement = nil;
			for(currentElement = currentNode->children; currentElement; currentElement = currentElement->next)
			{
				if(!strcmp((char *)currentElement->name, "AddressLine"))
					[m_address setValue:[NSString stringWithCString:(char *)xmlNodeGetContent(currentElement)] forKey:(NSString *)
						#ifdef __IPHONE
							kABPersonAddressStreetKey
						#else
							kABAddressStreetKey
						#endif
					 ];
				if(!strcmp((char *)currentElement->name, "AdminDistrict"))
					[m_address setValue:[NSString stringWithCString:(char *)xmlNodeGetContent(currentElement)] forKey:(NSString *)
						#ifdef __IPHONE
							kABPersonAddressStateKey
						#else
							kABAddressStateKey
						#endif
						];
				if(!strcmp((char *)currentElement->name, "CountryRegion"))
					[m_address setValue:[NSString stringWithCString:(char *)xmlNodeGetContent(currentElement)] forKey:(NSString *)
						#ifdef __IPHONE
							kABPersonAddressCountryKey
						#else
							kABAddressCountryKey
						#endif
					 ];
				if(!strcmp((char *)currentElement->name, "Locality"))
					[m_address setValue:[NSString stringWithCString:(char *)xmlNodeGetContent(currentElement)] forKey:(NSString *)
						#ifdef __IPHONE
							kABPersonAddressCityKey
						#else
							kABAddressCityKey
						#endif
					 ];
				if(!strcmp((char *)currentElement->name, "PostalCode"))
					[m_address setValue:[NSString stringWithCString:(char *)xmlNodeGetContent(currentElement)] forKey:(NSString *)
						#ifdef __IPHONE
							kABPersonAddressZIPKey
						#else
							kABAddressZIPKey
						#endif
					];
			}
		}
	}
	return self;
}

@end
