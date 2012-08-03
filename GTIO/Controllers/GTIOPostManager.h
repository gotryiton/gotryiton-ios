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
    GTIOPostStateCancelledImageUpload,
    GTIOPostStateCancelledPost
} GTIOPostState;

@interface GTIOPostManager : NSObject

@property (nonatomic, assign) BOOL postPhotoButtonTouched;
@property (nonatomic, assign, readonly) GTIOPostState state;
@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, strong, readonly) GTIOPost *post;
@property (nonatomic, assign) BOOL framed;

+ (GTIOPostManager *)sharedManager;

- (void)retry;

- (void)uploadImage:(UIImage *)image framed:(BOOL)framed filterNames:(NSDictionary *)filterNames forceSavePost:(BOOL)forceSavePost;
- (void)cancelUploadImage;

- (void)savePostWithDescription:(NSString *)description attachedProducts:(NSDictionary *)attachedProducts;

@end
