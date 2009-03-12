/*
 *  CercaMapPoint.h
 *  Cerca
 *
 *  Created by Peter Zion on 10/03/09.
 *  Copyright 2009 Peter Zion. All rights reserved.
 *
 */

#pragma mark CercaMapPoint

typedef struct
{
	int x;
	int y;
} CercaMapPoint;

static inline CercaMapPoint CercaMapPointMake( int x, int y )
{
	CercaMapPoint result = { x, y };
	return result;
}

