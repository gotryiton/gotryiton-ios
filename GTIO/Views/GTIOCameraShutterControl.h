//
//  GTIOCameraShutterControl.h
//  GTIO
//
//  Created by Scott Penrose on 7/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GTIOPhotoModeSwitchChangedHandler)(BOOL on);

@interface GTIOCameraShutterControl : UIControl

@property (nonatomic, assign, getter = isPhotoShootMode) BOOL photoShootMode;

@property (nonatomic, copy) GTIOButtonDidTapHandler shutterButtonTapHandler;
@property (nonatomic, copy) GTIOPhotoModeSwitchChangedHandler photoModeSwitchChangedHandler;

@end
