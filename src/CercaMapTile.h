//
//  CercaMapTile.h
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CercaMapTile : UIImageView 
{
@private
	UIActivityIndicatorView *activityIndicatorView;
	NSURLConnection *connection;
	NSMutableData *imageData;
}

+(id) tileWithURL:(NSURL *)url;

@end
