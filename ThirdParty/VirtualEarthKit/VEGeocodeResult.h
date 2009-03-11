//
//  VEGeocodeResult.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "VEResult.h"


/*!
 @class VEGeocodeResult
 VEGeocodeResult wraps the result of a geocode or reverse geocode operation. It is analogous to the GeocodeResult class provided by the Windows Communication Foundation API.
 @abstract Wraps the results from the geocode service.
 @updated 2008-10-25
 */

@interface VEGeocodeResult : VEResult {
	NSString *m_name;
	CLLocation *m_location;
	NSMutableDictionary *m_address;
}

/*!
 @function address
 @abstract The address resulting from the geocode operation.
 @discussion  Either the address submitted by the geocode, or the address that is the result of a reverse geocode. Use the keys given in the Address Book Framework, available on both Mac OS X and the iPhone. The address book keys are outlined in the <A HREF="http://developer.apple.com/documentation/UserExperience/Conceptual/AddressBook/AddressBook.html">Address Book Programming Guide</A>. This property can be set to an address dictionary pulled directly from a contact entry. Either the query property or the address property must be non-nil.
 */
@property (readonly) NSDictionary *address;

/*!
 @function name
 @abstract The human readable name of the result.
 @discussion This property gives a plain english representation of the result. Usually a "nice" version of the address.
 */
@property (readonly) NSString *name;

/*!
 @function location
 @abstract The location of the result.
 @discussion The best known location for the resulting address. In a geocode operation, this location may be different from the submitted location, but is considered "more correct" for the resulting address.
 */
@property (readonly) CLLocation *location;

@end
