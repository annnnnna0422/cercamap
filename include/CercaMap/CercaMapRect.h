/*
 *  CercaMapRect.h
 *  Cerca
 *
 *  Created by Peter Zion on 11/03/09.
 *  Copyright 2009 Peter Zion. All rights reserved.
 *
 */

#import <CercaMap/CercaMapLocation.h>
#import <CercaMap/CercaMapSize.h>

#pragma mark CercaMapRect

typedef struct
{
	CercaMapLocation origin;
	CercaMapSize size;
} CercaMapRect;

static inline CercaMapRect CercaMapRectMake( int x, int y, int w, int h )
{
	CercaMapRect result = { CercaMapLocationMake( x, y ), CercaMapSizeMake( w, h ) };
	return result;
}

static inline CercaMapRect CercaMapRectIntersect( CercaMapRect r1, CercaMapRect r2 )
{
	int x = r1.origin.x;
	if ( r2.origin.x > x )
		x = r2.origin.x;
	int maxX = r1.origin.x + r1.size.width;
	if ( r2.origin.x + r2.size.width < maxX )
		maxX = r2.origin.x + r2.size.width;
	int y = r1.origin.y;
	if ( r2.origin.y > y )
		y = r2.origin.y;
	int maxY = r1.origin.y + r1.size.height;
	if ( r2.origin.y + r2.size.height < maxY )
		maxY = r2.origin.y + r2.size.height;
	return CercaMapRectMake( x, y, maxX - x, maxY - y );
}

static inline BOOL CercaMapRectIsNonEmpty( CercaMapRect r )
{
	return r.size.width > 0 && r.size.height > 0;
}
