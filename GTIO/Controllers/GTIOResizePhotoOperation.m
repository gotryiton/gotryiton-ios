//
//  GTIOResizePhotoOperation.m
//  GTIO
//
//  Created by Scott Penrose on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOResizePhotoOperation.h"

#import "UIImage+Resize.h"

static NSInteger const kGTIOPhotoResizeWidth = 640;

@implementation GTIOResizePhotoOperation

@synthesize photo = _photo;
@synthesize completionHandler = _completionHandler;
//@synthesize executing = _executing, finished = _finished;

- (id)initWithPhoto:(UIImage *)photo completionHandler:(GTIOPhotoResizeCompletionHandler)completionHandler
{
    self = [super init];
    if (self) {
        _photo = photo;
        _completionHandler = completionHandler;
        
//        _executing = NO;
//        _finished = NO;
    }
    return self;
}

- (void)main 
{        
    NSLog(@"Resize Photo");
    UIImage *resizedImage = [self.photo resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:(CGSize){ kGTIOPhotoResizeWidth, CGFLOAT_MAX } interpolationQuality:kCGInterpolationHigh];
    
    if (self.completionHandler) {
        NSLog(@"Photo completed resizing");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completionHandler(resizedImage);
//            [self completeOperation];
        });
    } else {
//        [self completeOperation];
    }
}

//- (void)completeOperation {
//    [self willChangeValueForKey:@"isFinished"];
//    [self willChangeValueForKey:@"isExecuting"];
//    
//    _executing = NO;
//    _finished = YES;
//    
//    [self didChangeValueForKey:@"isExecuting"];
//    [self didChangeValueForKey:@"isFinished"];
//}
//
//- (BOOL)isConcurrent
//{
//    return NO;
//}
//
//- (void)start
//{
//    // Always check for cancellation before launching the task.
//    if ([self isCancelled])
//    {
//        // Must move the operation to the finished state if it is canceled.
//        [self willChangeValueForKey:@"isFinished"];
//        _finished = YES;
//        [self didChangeValueForKey:@"isFinished"];
//        return;
//    }
//    
//    // If the operation is not canceled, begin executing the task.
//    [self willChangeValueForKey:@"isExecuting"];
//    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
//    _executing = YES;
//    [self didChangeValueForKey:@"isExecuting"];
//}

@end
