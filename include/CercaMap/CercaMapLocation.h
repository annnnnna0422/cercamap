/*
 *  CercaMapLocation.h
 *  Cerca
 *
 *  Created by Peter Zion on 10/03/09.
 *  Copyright 2009 Peter Zion. All rights reserved.
 *
 */

#pragma mark CercaMapLocation

typedef struct
{
	int x;
	int y;
} CercaMapLocation;

static inline CercaMapLocation CercaMapLocationMake( int x, int y )
{
	CercaMapLocation result = { x, y };
	return result;
}

