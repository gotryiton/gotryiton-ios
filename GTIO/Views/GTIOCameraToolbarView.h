//
//  GTIOPhotoToolbarView.h
//  GTIO
//
//  Created by Scott Penrose on 5/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GTIOSwitch.h"

typedef void(^GTIOPhotoModeSwitchChangedHandler)(BOOL on);

@interface GTIOCameraToolbarView : UIView

@property (nonatomic, strong) GTIOUIButton *closeButton;
@property (nonatomic, strong) GTIOUIButton *photoPickerButton;
@property (nonatomic, strong) GTIOUIButton *photoShootGridButton;
@property (nonatomic, strong) GTIOUIButton *shutterButton;
@property (nonatomic, strong) GTIOSwitch *photoModeSwitch;

@property (nonatomic, copy) GTIOPhotoModeSwitchChangedHandler photoModeSwitchChangedHandler;

- (void)showPhotoShootGrid:(BOOL)showPhotoShootGrid;

- (void)enableAllButtons:(BOOL)enable;

@end
