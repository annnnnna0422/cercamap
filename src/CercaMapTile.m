//
//  CercaMapTile.m
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CercaMapTile.h"

@implementation CercaMapTile

#pragma mark Lifecycle

-(id) initWithTileURL:(NSURL *)tileURL
{
	if ( self = [super init] )
	{
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:tileURL];
		connection = [[NSURLConnection connectionWithRequest:urlRequest delegate:self] retain];
	}
	return self;
}

+(id) tileWithURL:(NSURL *)url
{
	return [[[self alloc] initWithTileURL:url] autorelease];
}

-(void) dealloc
{
	[connection cancel];
	[connection release];
	[imageData release];
	[super dealloc];
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	imageData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_
{
	self.image = [UIImage imageWithData:imageData];
	[imageData release];
	imageData = nil;
	[connection autorelease];
	connection = nil;
}

- (void)connection:(NSURLConnection *)_ didFailWithError:(NSError *)error
{
	[imageData release];
	imageData = nil;
	[connection autorelease];
	connection = nil;
}

@end
