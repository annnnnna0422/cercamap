//
//  VESOAPRequest.m
//  LiveEarthTest
//
//  Created by Colin Cornaby on 9/26/08.
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

#import "VESOAPRequest.h"



@implementation VESOAPRequest

@synthesize userID = m_userID, password = m_password;

-(xmlNodePtr)sendSOAPBody:(xmlNodePtr)contents toServer:(NSURL *)server action:(NSString *)action error:(NSError **)error
{
	xmlNodePtr soapBody= NULL;
    xmlDocPtr doc = NULL;       /* document pointer */
    xmlNodePtr root_node = NULL;/* node pointers */
    doc = xmlNewDoc(BAD_CAST "1.0");
	xmlChar * xmlDoc;
	int size;
	
	m_error = nil;
	
    root_node = xmlNewNode(NULL, BAD_CAST "soap:Envelope");
    xmlDocSetRootElement(doc, root_node);
    xmlNewProp(root_node, BAD_CAST "xmlns:soap", BAD_CAST "http://schemas.xmlsoap.org/soap/envelope/");
	xmlNewProp(root_node, BAD_CAST "xmlns:xsi", BAD_CAST "http://www.w3.org/2001/XMLSchema-instance");
	xmlNewProp(root_node, BAD_CAST "xmlns:xsd", BAD_CAST "http://www.w3.org/2001/XMLSchema");
	xmlNewProp(root_node, BAD_CAST "xmlns:i0", BAD_CAST "http://dev.virtualearth.net/webservices/v1");
	
	xmlNodePtr soapHeader = xmlNewNode(NULL, BAD_CAST "soap:Header");
    xmlNewChild(soapHeader, NULL, BAD_CAST "DefaultDistanceUnit",
                BAD_CAST "Kilometer");
	//xmlAddChild(root_node, soapHeader);

	soapBody = xmlNewNode(NULL, BAD_CAST "soap:Body");
	xmlAddChild(root_node, soapBody);
	
	xmlNodePtr soapBodyCopy = xmlCopyNode(contents, 1);
	xmlAddChild(soapBody, soapBodyCopy);
	
	xmlDocDumpFormatMemory(doc, &xmlDoc, &size, 1);
	NSString *nsStringRep = [[NSString alloc] initWithBytes:(const void *)xmlDoc length:size encoding:NSASCIIStringEncoding];
	
	
    NSDictionary *headerFieldsDict = [NSDictionary
									  dictionaryWithObjectsAndKeys:@"CSLiveEarthClient",@"User-Agent",
                                      @"text/xml; charset=utf-8", @"Content-Type",
									  action ,@"SOAPAction", 
                                      [server host],@"Host", 
									  [NSString stringWithFormat:@"%d", [[nsStringRep dataUsingEncoding:NSUTF8StringEncoding] length]],@"Content-Length", nil];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:server];
	xmlFreeDoc(doc);
	[request setHTTPBody:[nsStringRep dataUsingEncoding:NSUTF8StringEncoding]];
	[request setAllHTTPHeaderFields:headerFieldsDict];
	[request setHTTPMethod:@"POST"];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	while(!m_isDone)
	{
		CFRunLoopRunInMode (kCFRunLoopDefaultMode, 0.1, false);
	}
	if(m_error)
		*error = m_error;
	nsStringRep = [[NSString alloc] initWithData:m_bytes encoding:NSASCIIStringEncoding];
	xmlDocPtr docToReturn = xmlReadMemory([m_bytes bytes], [m_bytes length], NULL, NULL, 0);
	xmlDocDumpFormatMemory(docToReturn, &xmlDoc, &size, 1);
	nsStringRep = [[NSString alloc] initWithBytes:(const void *)xmlDoc length:size encoding:NSASCIIStringEncoding];
	xmlNodePtr root = xmlDocGetRootElement(docToReturn);
    xmlNodePtr soapBodyResult = nil;//xmlHasNsProp(root, BAD_CAST "Body",  BAD_CAST "http://schemas.xmlsoap.org/soap/envelope/");
	for(soapBodyResult = root->children; soapBodyResult; soapBodyResult = soapBodyResult->next)
	{
		if(!strcmp((char *)soapBodyResult->name, "Body"))
			break;
	}
	xmlNodePtr noteToReturn = xmlCopyNodeList(soapBodyResult->children);
	xmlFreeDoc(docToReturn);
	return noteToReturn;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	NSURLCredential *credential = [NSURLCredential credentialWithUser:self.userID password:self.password persistence:NSURLCredentialPersistenceForSession];
	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	NSLog(@"authentication canceled..");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[m_bytes appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
	if(m_bytes)
		[m_bytes release];
	m_bytes = [[NSMutableData alloc] init];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	m_isDone=YES;
	[connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	m_error = error;
}

@end
