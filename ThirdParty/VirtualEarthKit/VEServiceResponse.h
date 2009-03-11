//
//  VEServiceResponse.h
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
#include <libxml/parser.h>
#include <libxml/tree.h>
#include "VEResult.h"

/*!
 @class VEServiceResponse
 This function wraps the response from the Virtual Earth servers. It can contain an error, if applicable, or one or more results from a server operation. Any results will be a provided will subclass VEResult. It is analogous to the ResponseBase class provided by the Windows Communication Foundation API.
 @abstract Provides access to geocode services.
 @updated 2008-10-25
 */

@interface VEServiceResponse : NSObject {
	NSString *m_authenticationResultsCode;
	NSString *m_copyright;
	NSString *m_faultReason;
	NSString *m_statusCode;
	NSString *m_traceID;
	NSMutableArray *m_results;
}

/*!
 @function results
 @abstract Array of VEResult subclasses
 @discussion This property returns an array of results based on the kind of query you made. For example, a geocode query would return VEGeocodeResult classes. Multiple results are returned in certain instances. For example, a reverse geocode might return multiple possible addresses.
 */

@property (readonly) NSArray *results;
-(id)initWithXMLNode:(xmlNodePtr)node resultClass:(id)resultClass;
-(id)initWithXMLNode:(xmlNodePtr)node resultClass:(id)resultClass resultName:(char *)resultName;
-(void)loadResponseDataFromNode:(xmlNodePtr)node;

@end
