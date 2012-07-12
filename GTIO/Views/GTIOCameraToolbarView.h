//
//  GTIOPhotoToolbarView.h
//  GTIO
//
//  Created by Scott Penrose on 5/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GTIOSwitch.h"
#import "GTIOCameraShutterControl.h"

@interface GTIOCameraToolbarView : UIView

@property (nonatomic, strong) GTIOUIButton *closeButton;
@property (nonatomic, strong) GTIOUIButton *photoSourceButton;
@property (nonatomic, strong) GTIOUIButton *photoShootGridButton;
@property (nonatomic, strong) GTIOCameraShutterControl *shutterButton;

- (void)showPhotoShootGrid:(BOOL)showPhotoShootGrid;

- (void)enableAllButtons:(BOOL)enable;

@end
