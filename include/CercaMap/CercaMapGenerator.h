//
//  CercaMapGenerator.h
//  Cerca
//
//  Created by Peter Zion on 12/03/09.
//  Copyright 2009 Peter Zion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CercaMap/CercaMapType.h>
#import <CercaMap/CercaMapLocation.h>
#import <CercaMap/CercaMapZoomLevel.h>

#pragma mark Forward Declarations
@class CercaMapQuad;
@protocol CercaMapGeneratorDelegate;

@interface CercaMapGenerator : NSObject
{
}

#pragma mark CercaMapGenerator - Authentication
+(void) setMapServiceUsername:(NSString *)_username password:(NSString *)_password;
+(NSString *) mapServiceUsername;
+(NSString *) mapServicePassword;

#pragma mark CercaMapGenerator - Drawing Maps
+(void) drawToDstRect:(CGRect)dstRect
	centerPoint:(CercaMapLocation)centerPoint
	zoomLevel:(CercaMapZoomLevel)zoomLevel
	mapType:(CercaMapType)mapType;

#pragma mark CercaMapGenerator - Refresh Notifications
+(NSNotificationCenter *) refreshNotificationCenter;
+(NSString *) refreshNotificationName;
+(void) addRefreshObserver:(id)observer
	selector:(SEL)selector;
+(void) removeRefreshObserver:(id)observer;

#pragma mark CercaMapGenerator - Memory Warnings
+(void) didReceiveMemoryWarning;

#pragma mark CercaMapGenerator - Persistence
+(void) loadState;
+(void) saveState;

@end
