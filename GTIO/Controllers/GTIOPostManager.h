//
//  GTIOPostManager.h
//  GTIO
//
//  Created by Scott Penrose on 7/3/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTIOPost.h"

typedef enum GTIOPostState {
    GTIOPostStateNone = 0,
    GTIOPostStateUploadingImage,
    GTIOPostStateUploadingImageComplete,
    GTIOPostStateSavingPost,
    GTIOPostStateComplete, 
    GTIOPostStateError,
    GTIOPostStateCancelled
} GTIOPostState;

@interface GTIOPostManager : NSObject

@property (nonatomic, assign) BOOL postPhotoButtonTouched;
@property (nonatomic, copy) GTIOPostCompletionHandler postCompletionHandler;
@property (nonatomic, assign, readonly) GTIOPostState state;
@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, strong, readonly) GTIOPost *post;

+ (GTIOPostManager *)sharedManager;

- (void)uploadImage:(UIImage *)image framed:(BOOL)framed filterName:(NSString *)filterName;
- (void)cancelUploadImage;

- (void)savePostWithDescription:(NSString *)description completionHandler:(GTIOPostCompletionHandler)completionHandler;

@end
