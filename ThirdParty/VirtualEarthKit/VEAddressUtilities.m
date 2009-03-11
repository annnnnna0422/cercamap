//
//  VEAddressUtilities.m
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 10/26/08.
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

#import "VEAddressUtilities.h"
#import <AddressBook/AddressBook.h>


@implementation VEAddressUtilities

+(void)addForDictionaryName:(NSString *)dictName nodeName:(char *)nodeName dictionary:(NSDictionary *)dictionary node:(xmlNodePtr)xmlNode
{
	NSString *objectForKey = [dictionary objectForKey:dictName];
	xmlNodePtr newNode = xmlNewNode(NULL, BAD_CAST nodeName);
	if(objectForKey)
	{
		xmlNewProp(newNode, BAD_CAST "i:nil", BAD_CAST "true");
	}else{
		xmlNodeSetContent(newNode, BAD_CAST [objectForKey cStringUsingEncoding:NSASCIIStringEncoding]);
	}
	xmlAddChild(xmlNode, newNode);
}

+(xmlNodePtr)addressNodeFromAddressDictionary:(NSDictionary *)dictionary
{
	xmlNodePtr addressNode = NULL;
	addressNode = xmlNewNode(NULL, BAD_CAST "a:Address");
	xmlNewProp(addressNode, BAD_CAST "xmlns:b", BAD_CAST "http://dev.virtualearth.net/webservices/v1/common");
#ifdef __IPHONE 
	[VEAddressUtilities addForDictionaryName:kABPersonAddressStreetKey nodeName:"b:AddressLine" dictionary:dictionary node:addressNode];
#else 
	[VEAddressUtilities addForDictionaryName:kABAddressStreetKey nodeName:"b:AddressLine" dictionary:dictionary node:addressNode];
#endif
#ifdef __IPHONE 
	[VEAddressUtilities addForDictionaryName:kABPersonAddressStateKey nodeName:"b:AdminDistrict" dictionary:dictionary node:addressNode];
#else 
	[VEAddressUtilities addForDictionaryName:kABAddressStateKey nodeName:"b:AdminDistrict" dictionary:dictionary node:addressNode];
#endif
#ifdef __IPHONE 
	[VEAddressUtilities addForDictionaryName:kABPersonAddressCountryKey nodeName:"b:CountryRegion" dictionary:dictionary node:addressNode];
#else 
	[VEAddressUtilities addForDictionaryName:kABAddressCountryKey nodeName:"b:CountryRegion" dictionary:dictionary node:addressNode];
#endif
#ifdef __IPHONE 
	[VEAddressUtilities addForDictionaryName:kABPersonAddressCityKey nodeName:"b:Locality" dictionary:dictionary node:addressNode];
#else 
	[VEAddressUtilities addForDictionaryName:kABAddressCityKey nodeName:"b:Locality" dictionary:dictionary node:addressNode];
#endif
#ifdef __IPHONE 
	[VEAddressUtilities addForDictionaryName:kABPersonAddressZIPKey nodeName:"b:PostalCode" dictionary:dictionary node:addressNode];
#else 
	[VEAddressUtilities addForDictionaryName:kABAddressZIPKey nodeName:"b:PostalCode" dictionary:dictionary node:addressNode];
#endif
	return addressNode;
}

@end
