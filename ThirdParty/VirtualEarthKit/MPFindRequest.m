//
//  MPFindRequest.m
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 11/18/08.
//  Copyright 2008 Consonance Software. All rights reserved.
//

#import "MPFindRequest.h"
#import "VELocationUtilities.h"


@implementation MPFindRequest

@synthesize location = m_location, distance = m_distance, filter = m_filter, datasourceName = m_datasourceName;

-(NSError *)serializeToXMLQuery:(xmlNodePtr *)query
{
	
	xmlNodePtr findRequest = NULL;
	findRequest = xmlNewNode(NULL, BAD_CAST "FindNearby");
    xmlNewProp(findRequest, BAD_CAST "xmlns", BAD_CAST "http://s.mappoint.net/mappoint-30/");
	
	
	xmlNodePtr request = xmlNewNode(NULL, BAD_CAST "specification");
	xmlAddChild(findRequest, request);
	[self addStandardAttributesToNode:request];
	
	xmlNodePtr datasourceName = xmlNewNode(NULL, BAD_CAST "DataSourceName");
	xmlNodeSetContent(datasourceName, BAD_CAST [self.datasourceName cStringUsingEncoding:NSASCIIStringEncoding]);
	xmlAddChild(request, datasourceName);
	
	xmlNodePtr location = xmlNewNode(NULL, BAD_CAST "LatLong");
	[VELocationUtilities addMappointLocation:self.location toNode:location];
	xmlAddChild(request, location);
	
	
	xmlNodePtr distance = xmlNewNode(NULL, BAD_CAST "Distance");
	xmlNodeSetContent(distance, BAD_CAST [[NSString stringWithFormat:@"%f", self.distance] cStringUsingEncoding:NSASCIIStringEncoding]);
	xmlAddChild(request, distance);
	
	xmlNodePtr filter = xmlNewNode(NULL, BAD_CAST "Filter");
	xmlNodePtr entityTypeName = xmlNewNode(NULL, BAD_CAST "EntityTypeName");
	xmlNodeSetContent(entityTypeName, BAD_CAST [self.filter cStringUsingEncoding:NSASCIIStringEncoding]);
	xmlAddChild(filter, entityTypeName);
	xmlAddChild(request, filter);
	
	*query=findRequest;
	return nil;
}

@end
