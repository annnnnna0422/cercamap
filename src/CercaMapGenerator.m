//
//  CercaMapGenerator.m
//  Cerca
//
//  Created by Peter Zion on 12/03/09.
//  Copyright 2009 Peter Zion. All rights reserved.
//

#import "CercaMapGenerator.h"
#import "CercaMapQuad.h"
#import "CercaMapInternal.h"

@implementation CercaMapGenerator

static CercaMapQuad *rootMapQuad;

#pragma mark Private

+(NSString *) keyedArchiveFilename
{
	NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:@"CercaMapGeneratorState.keyedArchive"];
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
			coverage:CercaMapRectMake( 0, 0, CM_TOTAL_PIXELS, CM_TOTAL_PIXELS )
			logZoom:CM_ZOOM_LEVEL_LOG_MAX+1];
	}
	
	CGSize srcSize = CGSizeMake( CGRectGetWidth(dstRect)*zoomLevel, CGRectGetHeight(dstRect)*zoomLevel );
	CercaMapRect srcRect = CercaMapRectMake( roundf( centerPoint.x - srcSize.width/2 ), roundf( centerPoint.y - srcSize.height/2 ),
		roundf( srcSize.width ), roundf( srcSize.height ) );
	[rootMapQuad drawToDstRect:dstRect srcRect:srcRect zoomLevel:zoomLevel mapType:mapType];

#ifdef CERCA_MAP_TRIAL
	UIFont *font = [UIFont systemFontOfSize:30];
	NSString *text = @"CercaMap\nTrial\nVersion";
	CGSize textSize = [text
		sizeWithFont:font
		constrainedToSize:dstRect.size
		lineBreakMode:UILineBreakModeWordWrap];
	CGRect topLeftTextRect = CGRectMake(
		dstRect.origin.x,
		dstRect.origin.y,
		textSize.width,
		textSize.height
		);
	[[UIColor colorWithWhite:0 alpha:0.25] set];
	[text drawInRect:topLeftTextRect
		withFont:font
		lineBreakMode:UILineBreakModeWordWrap
		alignment:UITextAlignmentLeft];
	CGRect bottomRightTextRect = CGRectMake(
		dstRect.origin.x + dstRect.size.width - textSize.width,
		dstRect.origin.y + dstRect.size.height - textSize.height,
		textSize.width,
		textSize.height
		);
	[[UIColor colorWithWhite:0 alpha:0.25] set];
	[text drawInRect:bottomRightTextRect
		withFont:font
		lineBreakMode:UILineBreakModeWordWrap
		alignment:UITextAlignmentRight];
#endif
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
