//
//  GTIOCameraViewController.h
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

#import "GTIOPostALookViewController.h"

typedef void(^GTIOImageCapturedHandler)(UIImage *image);

extern NSString * const kGTIOPhotoAcceptedNotification;

@interface GTIOCameraViewController : UIViewController

@property (nonatomic, copy) GTIODismissHandler dismissHandler;
@property (nonatomic, assign, getter = isFlashOn) BOOL flashOn;
@property (nonatomic, strong) GTIOPostALookViewController *postALookViewController;

@end
