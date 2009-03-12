/*
 *  CercaMapSize.h
 *  Cerca
 *
 *  Created by Peter Zion on 11/03/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma mark CercaMapSize

typedef struct
{
	int width;
	int height;
} CercaMapSize;

static inline CercaMapSize CercaMapSizeMake( int width, int height )
{
	CercaMapSize result = { width, height };
	return result;
}

