//
//  VEImageryMetadataRequest.h
//  VirtualEarthKit
//
//  Created by Colin Cornaby on 10/28/08.
//  Copyright 2008 Consonance Software. All rights reserved.
//

//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions
//are met:
//1. Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//2. Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//3. Neither the name of the author nor the names of any co-contributors
//   may be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
//FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
//OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
//OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
//SUCH DAMAGE.
//

#import <Foundation/Foundation.h>
#import <VirtualEarthKit/VEService.h>

#import <Foundation/Foundation.h>
#import <VirtualEarthKit/VERequest.h>
#import <CoreLocation/CoreLocation.h>


/*!
 @class VEImageryMetadataRequest
 This class allows you to return various information about the map tiles that the Virtual Earth service provides. Can be used both to find copyright information and the url for the tiles themselves. Analogous to the ImageryMetadataRequest and ImageryMetadataOptions classes of the Virtual Earth Windows Communication Foundation API.
 @abstract Used for finding information for a certain map tile for Virtual Earth. Use for fetching map tiles.
 @updated 2008-10-25
 */


/*! \def kVEMapStyleAerial 0
 \brief The constant for the aerial map style
 
 This map style uses actual imagery to construct the map.
 */
#define kVEMapStyleAerial 0

/*! \def kVEMapStyleAerialWithLabels 1
 \brief The constant for the aerial map style with labels
 
 This map style uses actual imagery to construct the map. Road information is overlaid the real imagery.
 */
#define kVEMapStyleAerialWithLabels 1

/*! \def kVEMapStyleBirdseye 2
 \brief Constant for map imagery at an angle.
 
 This map style uses actual imagery at a slight angle.
 */
#define kVEMapStyleBirdseye 2

/*! \def kVEMapStyleBirdseyeWithLabels 3
 \brief Constant for map imagery at an angle with road overlays.
 
 This map style uses actual imagery at a slight angle, and includes road overlays.
 */
#define kVEMapStyleBirdseyeWithLabels 3


/*! \def kVEMapStyleRoad 4
 \brief Constant for map imagery with just roads.
 
 This map style uses basic road imagery tiles.
 */
#define kVEMapStyleRoad 4

@interface VEImageryMetadataRequest : VERequest {
	double m_heading;
	CLLocation *m_location;
	BOOL m_returnImageryProviders;
	int m_zoomLevel;
	int m_style;
}

/*!
 @function heading
 @abstract The direction the map is turned.
 @discussion This property is the direction the map should be turned. Defaults to 0.
 */
@property double heading;
/*!
 @function location
 @abstract The location of the tile
 @discussion Set this property to the location of the tile you wish to fetch..
 */
@property (retain) CLLocation *location;
/*!
 @function returnImageryProviders
 @abstract A BOOL for returning the copyright information for the tile.
 @discussion Set this BOOL to yes if you want to return the information for the owners of the tile imagery. Defaults to NO.
 */
@property BOOL returnImageryProviders;
/*!
 @function zoomLevel
 @abstract An int specifying the zoom level of the map.
 @discussion Virtual Earth has a zoom level for each doubling of scale of the map. For example, zoom level 0 would return a single 256x256 tile for the entire world. Zoom level 1 would contain a 2x2 grid of 256x256 tiles for the whole world. Zoom level 2 would contain a 4x4 grid of 256x256 tiles for the whole world, and so on.
 */
@property int zoomLevel;
/*!
 @function style
 @abstract An int specifying what kind of map to fetch.
 @discussion See the defined map styles for the values this can be set to. Defaults to aerial tiles.
 */
@property int style;

@end
