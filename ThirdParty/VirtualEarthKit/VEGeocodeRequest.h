//
//  VEGeocodeRequest.h
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 10/22/08.
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

#import <Foundation/Foundation.h>
#include <libxml/parser.h>
#include <libxml/tree.h>
#import <VirtualEarthKit/VERequest.h>

/*!
 @class VEGeocodeRequest
 VEGeocodeRequest is the class used to create a geocode request to be sent to Virtual Earth via a VEGeocodeService. It is analogous to the GeocodeRequest class provided by the Windows Communication Foundation API.
 @abstract Object representation of a geocode request.
 @updated 2008-10-25
 */

@interface VEGeocodeRequest : VERequest {
	NSString *m_query;
	NSDictionary *m_address;
}

/*!
 @function query
 @abstract A plain text query to send to Virtual Earth
 @discussion Set this property to a plain text query to send to Virtual Earth. This query can be "dirty", i.e. not broken out into a street address. It can be grabbed directly from user input. Note: While geocoding is appropriate for finding a location based on a street address, it is not appropriate for finding a location based on a business name. Use search services for locating services based on names. Either the query property or the address property must be non-nil.
 */

@property (retain) NSString *query;

/*!
 @function address
 @abstract A dictionary containing a set of keys and objects for an address.
 @discussion An NSDictionary containing a set of keys and values for the address to be geocoded. Use the keys given in the Address Book Framework, available on both Mac OS X and the iPhone. The address book keys are outlined in the <A HREF="http://developer.apple.com/documentation/UserExperience/Conceptual/AddressBook/AddressBook.html">Address Book Programming Guide</A>. This property can be set to an address dictionary pulled directly from a contact entry. Either the query property or the address property must be non-nil.
 */

@property (retain) NSDictionary *address;

@end
