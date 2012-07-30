//
//  GTIOPhoto.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOPhoto : NSObject

@property (nonatomic, copy) NSString *photoID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;

@property (nonatomic, strong) NSURL *mainImageURL;
@property (nonatomic, strong) NSURL *squareThumbnailURL;
@property (nonatomic, strong) NSURL *smallThumbnailURL;
@property (nonatomic, strong) NSURL *smallSquareThumbnailURL;

@property (nonatomic, assign) BOOL isStarred;

typedef void(^GTIOPhotoCreationHandler)(GTIOPhoto *photo, NSError *error);

- (CGSize)photoSize;

@end
