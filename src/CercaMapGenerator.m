//
//  CercaMapGenerator.m
//  Cerca
//
//  Created by Peter Zion on 12/03/09.
//  Copyright 2009 Peter Zion. All rights reserved.
//

#import "CercaMapGenerator.h"
#import "CercaMapQuad.h"

@implementation CercaMapGenerator

static CercaMapQuad *rootMapQuad;

#pragma mark Private

+(NSString *) keyedArchiveFilename
{
	NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:@"CercaMapGeneratorState.keyedArchive"];
}

#pragma mark CercaMapGenerator - Authentication

static NSString *mapServiceUsername;
static NSString *mapServicePassword;

+(void) setMapServiceUsername:(NSString *)_username password:(NSString *)_password
{
	[mapServiceUsername release];
	mapServiceUsername = [_username retain];
	
	[mapServicePassword release];
	mapServicePassword = [_password retain];
}

+(NSString *) mapServiceUsername
{
	return mapServiceUsername;
}

+(NSString *) mapServicePassword
{
	return mapServicePassword;
}

#pragma mark CercaMapGenerator - Drawing Maps

+(void) drawToDstRect:(CGRect)dstRect
	centerPoint:(CercaMapLocation)centerPoint
	zoomLevel:(CercaMapZoomLevel)zoomLevel
	mapType:(CercaMapType)mapType
{
	if ( rootMapQuad == nil )
	{
		rootMapQuad = [[CercaMapQuad alloc] initWithParentQuad:nil
			coverage:CercaMapRectMake( 0, 0, 1<<27, 1<<27 )
			urlBaseString:@""
			logZoom:0];
	}
	CGFloat mult = (1<<18) / zoomLevel;
	CGSize srcSize = CGSizeMake( CGRectGetWidth(dstRect)*mult, CGRectGetHeight(dstRect)*mult );
	CercaMapRect srcRect = CercaMapRectMake( roundf( centerPoint.x - srcSize.width/2 ), roundf( centerPoint.y - srcSize.height/2 ),
		roundf( srcSize.width ), roundf( srcSize.height ) );
	[rootMapQuad drawToDstRect:dstRect srcRect:srcRect zoomLevel:zoomLevel mapType:mapType];
}

#pragma mark CercaMapGenerator - Refresh Notifications

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

#pragma mark CercaMapGenerator - Memory Warnings

+(void) didReceiveMemoryWarning
{
	[rootMapQuad shouldKeepAfterPurgingMemory];
}

#pragma mark CercaMapGenerator - Persistence

static NSString *rootMapQuadPK = @"rootMapQuad_1";

+(void) loadState
{
	NSString *keyedArchiveFilename = [self keyedArchiveFilename];
	NSData *keyedArchiveData = [NSData dataWithContentsOfFile:keyedArchiveFilename];
	unlink( [keyedArchiveFilename cStringUsingEncoding:NSUTF8StringEncoding] );
	
	NSKeyedUnarchiver *keyedUnarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:keyedArchiveData] autorelease];
	rootMapQuad = [[keyedUnarchiver decodeObjectForKey:rootMapQuadPK] retain];
	[keyedUnarchiver finishDecoding];
}

+(void) saveState
{
	NSMutableData *keyedArchiveData = [NSMutableData data];
	NSKeyedArchiver *keyedArchiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:keyedArchiveData] autorelease];
	[keyedArchiver encodeObject:rootMapQuad forKey:rootMapQuadPK];
	[keyedArchiver finishEncoding];
	
	NSString *keyedArchiveFilename = [self keyedArchiveFilename];
	[keyedArchiveData writeToFile:keyedArchiveFilename atomically:YES];
}

@end
