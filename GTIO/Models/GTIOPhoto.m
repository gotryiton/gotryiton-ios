//
//  GTIOPhoto.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhoto.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>

@implementation GTIOPhoto

@synthesize photoID = _photoID, userID = _userID, url = _url, width = _width, height = _height;
@synthesize mainImageURL = _mainImageURL, squareThumbnailURL = _squareThumbnailURL, smallThumbnailURL = _smallThumbnailURL;

- (CGSize)photoSize
{
    return (CGSize){ [self.width intValue], [self.height intValue] };
}

#warning Used for testing
- (NSNumber *)width
{
    return [NSNumber numberWithInt:454];
}

- (NSNumber *)height
{
    return [NSNumber numberWithInt:604];
}
#warning End Used for testing

@end
