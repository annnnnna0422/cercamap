//
//  CercaMapTile.m
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CercaMapTile.h"

@implementation CercaMapTile

#pragma mark Private

-(void) cleanupConnection
{
	[imageData release];
	imageData = nil;
	[connection autorelease];
	connection = nil;
	[activityIndicatorView stopAnimating];
}

#pragma mark Lifecycle

-(id) initWithTileURL:(NSURL *)tileURL
{
	if ( self = [super init] )
	{
		self.backgroundColor = [UIColor clearColor];
	
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicatorView.hidesWhenStopped = YES;
		[self addSubview:activityIndicatorView];
		
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:tileURL];
		connection = [[NSURLConnection connectionWithRequest:urlRequest delegate:self] retain];
		[activityIndicatorView startAnimating];
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
	[activityIndicatorView release];
	[super dealloc];
}

#pragma mark UIView

-(void) layoutSubviews
{
	[super layoutSubviews];
	activityIndicatorView.center = self.center;
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
	[self cleanupConnection];
}

- (void)connection:(NSURLConnection *)_ didFailWithError:(NSError *)error
{
	[self cleanupConnection];
}

@end
