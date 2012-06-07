//
//  GTIOResizePhotoOperation.h
//  GTIO
//
//  Created by Scott Penrose on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GTIOPhotoResizeCompletionHandler)(UIImage *resizedPhoto);

@interface GTIOResizePhotoOperation : NSOperation

//@property (nonatomic, readonly, getter = isExecuting) BOOL executing;
//@property (nonatomic, readonly, getter = isFinished) BOOL finished;

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) GTIOPhotoResizeCompletionHandler completionHandler;

- (id)initWithPhoto:(UIImage *)photo completionHandler:(GTIOPhotoResizeCompletionHandler)completionHandler;

@end
