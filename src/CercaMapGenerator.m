//
//  CercaMapGenerator.m
//  Cerca
//
//  Created by Peter Zion on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CercaMapGenerator.h"
#import "CercaMapQuad.h"
#import <VirtualEarthKit/VECommonService.h>

@implementation CercaMapGenerator

static NSString *token;
static CercaMapQuad *rootMapQuad;

+(void) drawToDstRect:(CGRect)dstRect
	centerPoint:(CercaMapPoint)centerPoint
	zoomLevel:(CGFloat)zoomLevel
	mapType:(CercaMapType)mapType
	virtualEarthKitUsername:(NSString *)username
	virtualEarthKitPassword:(NSString *)password
{
	if ( rootMapQuad == nil )
	{
		if ( token == nil )
		{
			VECommonService *commonService = [[[VECommonService alloc] init] autorelease];
			[commonService getToken:&token forUserID:username password:password ipAddress:@"192.168.0.1"];
		}
		
		rootMapQuad = [[CercaMapQuad alloc] initWithParentQuad:nil
			coverage:CercaMapRectMake( 0, 0, 1<<27, 1<<27 )
			token:token
			urlBaseString:@""
			logZoom:0];
	}
	CGFloat mult = (1<<18) / zoomLevel;
	CGSize srcSize = CGSizeMake( CGRectGetWidth(dstRect)*mult, CGRectGetHeight(dstRect)*mult );
	CercaMapRect srcRect = CercaMapRectMake( roundf( centerPoint.x - srcSize.width/2 ), roundf( centerPoint.y - srcSize.height/2 ),
		roundf( srcSize.width ), roundf( srcSize.height ) );
	[rootMapQuad drawToDstRect:dstRect srcRect:srcRect zoomLevel:zoomLevel mapType:mapType];
}

+(NSNotificationCenter *) refreshNotificationCenter
{
	return [NSNotificationCenter defaultCenter];
}

+(NSString *) refreshNotificationName
{
	return @"CercaMapGenerator_Refresh";
}

+(void) addRefreshObserver:(id)observer
	selector:(SEL)selector
{
	[[self refreshNotificationCenter]
		addObserver:observer
		selector:selector
		name:[self refreshNotificationName]
		object:nil];
}

+(void) removeRefreshObserver:(id)observer
{
	[[self refreshNotificationCenter]
		removeObserver:observer
		name:[self refreshNotificationName]
		object:nil];
}

+(void) didReceiveMemoryWarning
{
	[rootMapQuad release];
	rootMapQuad = nil;
}

@end
