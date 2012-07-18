//
//  GTIOTakePhotoView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GTIOPostALookViewController.h"

@class GTIOTakePhotoView;

typedef void(^GTIOLaunchCameraHandler)(GTIOPostPhotoSection photoSection);
typedef void(^GTIOAddFilterHandler)(GTIOPostPhotoSection photoSection, UIImage *originalPhoto);
typedef void(^GTIOSwapPhotoHandler)(GTIOTakePhotoView *takePhotoView, GTIOPostPhotoSection swapWithSection);

typedef enum GTIOEditPhotoButtonPosition {
    GTIOEditPhotoButtonPositionLeft = 0,
    GTIOEditPhotoButtonPositionRight,
} GTIOEditPhotoButtonPosition;

@interface GTIOTakePhotoView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *filteredImage;
@property (nonatomic, strong) NSString *filterName;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) GTIOEditPhotoButtonPosition editPhotoButtonPosition;

@property (nonatomic, assign) GTIOPostPhotoSection photoSection;
@property (nonatomic, assign, getter = isPhotoSet) BOOL photoSet;

@property (nonatomic, copy) GTIOLaunchCameraHandler launchCameraHandler;
@property (nonatomic, copy) GTIOAddFilterHandler addFilterHandler;
@property (nonatomic, copy) GTIOSwapPhotoHandler swapPhotoHandler;

- (void)hideEditPhotoButton:(BOOL)hidden;
- (void)reset;

@end