/*
 *  CercaMapPixel.h
 *  Cerca
 *
 *  Created by Peter Zion on 10/03/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma mark CercaMapPixel

typedef struct
{
	int x;
	int y;
} CercaMapPixel;

static inline CercaMapPixel CercaMapPixelMake( int x, int y )
{
	CercaMapPixel result = { x, y };
	return result;
}

