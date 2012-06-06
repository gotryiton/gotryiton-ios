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

typedef void(^GTIOPhotoCreationHandler)(GTIOPhoto *photo, NSError *error);

+ (GTIOPhoto *)createGTIOPhotoWithUIImage:(UIImage *)image framed:(BOOL)framed filter:(NSString *)filterName completionHandler:(GTIOPhotoCreationHandler)completionHandler;

- (void)cancel;

@end
