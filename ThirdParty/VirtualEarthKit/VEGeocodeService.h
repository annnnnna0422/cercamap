//
//  VEGeocodeService.h
//  LiveEarthTestApp
//
//  Created by Colin Cornaby on 9/27/08.
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
#import "VEService.h"
#import "VEServiceResponse.h"
#import "VEGeocodeRequest.h"
#import "VEReverseGeocodeRequest.h"

/*!
 @class VEGeocodeService
 VEGeocodeService provides access to Virtual Earth's Geocoding and Reverse Geocoding services. It is analogous to the GeocodeServiceClient class provided by the Windows Communication Foundation API.
 @abstract Provides access to geocode services.
 @updated 2008-10-25
 */


@interface VEGeocodeService : VEService {

}

/*!
 @function geocode:
 @abstract Returns a Virtual Earth service response containing the results of the given geocode request
 @discussion Use this function to pass geocode requests to the Virtual Earth servers. You can create the geocode request using the VEGeocodeRequest class. Reverse geocodes are handled by the reverseGeocode:error: function.
 @param request The request to send to Virtual Earth.
 @result A VEServiceResponse class containing the results from the server. Nil if the geocode function failed. Check error for more information if this function returns nil.
 */
-(VEServiceResponse *)geocode:(VEGeocodeRequest *)request;

/*!
 @function reverseGeocode:
 @abstract Returns a Virtual Earth service response containing the results of the given reverse geocode request
 @discussion Use this function to pass geocode requests to the Virtual Earth servers. You can create the geocode request using the VEGeocodeRequest class. Forward geocodes are handled by the geocode:error: function.
 @param request The request to send to Virtual Earth.
 @result A VEServiceResponse class containing the results from the server. Nil if the geocode function failed. Check error for more information if this function returns nil.
 */
-(VEServiceResponse *)reverseGeocode:(VEReverseGeocodeRequest *)request;

@end
