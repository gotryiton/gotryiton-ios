//
//  GTIOTakePhotoView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GTIOPostALookViewController.h"

typedef void(^GTIOLaunchCameraHandler)(GTIOPostPhotoSection photoSection);

@interface GTIOTakePhotoView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) GTIODeleteButtonPosition deleteButtonPosition;

@property (nonatomic, assign) GTIOPostPhotoSection photoSection;

@property (nonatomic, copy) GTIOLaunchCameraHandler launchCameraHandler;

- (void)hideDeleteButton:(BOOL)hidden;

@end