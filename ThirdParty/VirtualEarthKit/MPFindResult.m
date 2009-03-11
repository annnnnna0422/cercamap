//
//  MPFindResult.m
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 11/20/08.
//  Copyright 2008 Consonance Software. All rights reserved.
//

#import "MPFindResult.h"


@implementation MPFindResult

-(id)initWithContentsNode:(xmlNodePtr)node
{
	self = [super init];
	xmlNodePtr currentNode = nil;
	for(currentNode = node->children; currentNode; currentNode = currentNode->next)
	{
	}
	return self;
}

@end
