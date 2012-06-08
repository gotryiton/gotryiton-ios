//
//  GTIOLookSelectorView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOLookSelectorControlDelegate.h"

#import "GTIOTakePhotoView.h"

@interface GTIOLookSelectorView : UIView <GTIOLookSelectorControlDelegate>

@property (nonatomic, assign) CGSize photoCanvasSize;
@property (nonatomic, assign) BOOL photoSet;

@property (nonatomic, strong) GTIOTakePhotoView *singlePhotoView;

@property (nonatomic, strong) GTIOTakePhotoView *tallLeftPhoto;
@property (nonatomic, strong) GTIOTakePhotoView *tallRightPhoto;
@property (nonatomic, strong) GTIOTakePhotoView *smallRightPhoto;

@property (nonatomic, copy) GTIOLaunchCameraHandler launchCameraHandler;

- (id)initWithFrame:(CGRect)frame photoSet:(BOOL)photoSet launchCameraHandler:(GTIOLaunchCameraHandler)launchCameraHandler;
- (void)hideDeleteButtons:(BOOL)hidden;
- (BOOL)selectionsComplete;
- (UIView *)compositeCanvas;

@end
