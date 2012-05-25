//
//  GTIOPhotoToolbarView.m
//  GTIO
//
//  Created by Scott Penrose on 5/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOCameraToolbarView.h"

#import "GTIOSwitch.h"
#import "GTIOSlider.h"

NSString * const kGTIODividerImageName = @"upload.bottom.bar.divider.png";

@interface GTIOCameraToolbarView ()

@property (nonatomic, strong) UIImageView *photoShootGridDivider;

@end

@implementation GTIOCameraToolbarView

@synthesize closeButton = _closeButton, photoPickerButton = _photoPickerButton, photoShootGridButton = _photoShootGridButton, shutterButton = _shutterButton;
@synthesize photoShootGridDivider = _photoShootGridDivider;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ frame.origin, { frame.size.width, 53 } }];
        
        UIEdgeInsets dividerEdgeInsets = (UIEdgeInsets){ 0, 0, 0, 0 };
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ 0, -5, frame.size.width, 58 }];
        [backgroundImageView setImage:[[UIImage imageNamed:@"upload.bottom.bar.bg.png"] resizableImageWithCapInsets:dividerEdgeInsets]];
        [self addSubview:backgroundImageView];
        
        // Close Button
        _closeButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypePhotoClose];
        [_closeButton setFrame:(CGRect){ CGPointZero, _closeButton.frame.size }];
        [self addSubview:_closeButton];
        
        UIImageView *closeButtonDivider = [[UIImageView alloc] initWithFrame:(CGRect){ 39, 0, 1, 53 }];
        [closeButtonDivider setImage:[[UIImage imageNamed:kGTIODividerImageName] resizableImageWithCapInsets:dividerEdgeInsets]];
        [self addSubview:closeButtonDivider];
        
        // Photo Picker Button
        _photoPickerButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypePhotoPicker];
        [_photoPickerButton setFrame:(CGRect){ { _closeButton.frame.origin.x + _closeButton.frame.size.width + 1, 0 }, _photoPickerButton.frame.size }];
        [self addSubview:_photoPickerButton];
        
        UIImageView *photoPickerDivider = [[UIImageView alloc] initWithFrame:(CGRect){ _photoPickerButton.frame.origin.x + _photoPickerButton.frame.size.width, 0, 1, 53 }];
        [photoPickerDivider setImage:[[UIImage imageNamed:kGTIODividerImageName] resizableImageWithCapInsets:dividerEdgeInsets]];
        [self addSubview:photoPickerDivider];
        
        // Photo Shoot Grid button
        _photoShootGridButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypePhotoShootGrid];
        [_photoShootGridButton setFrame:(CGRect){ { _photoPickerButton.frame.origin.x + _photoPickerButton.frame.size.width + 1, 0 }, _photoShootGridButton.frame.size }];
        [self addSubview:_photoShootGridButton];
        
        _photoShootGridDivider = [[UIImageView alloc] initWithFrame:(CGRect){ _photoShootGridButton.frame.origin.x + _photoShootGridButton.frame.size.width, 0, 1, 53 }];
        [_photoShootGridDivider setImage:[[UIImage imageNamed:kGTIODividerImageName] resizableImageWithCapInsets:dividerEdgeInsets]];
        [self addSubview:_photoShootGridDivider];
        
        // Shutter Button
        _shutterButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypePhotoShutter];
        [_shutterButton setFrame:(CGRect){ { (self.frame.size.width - _shutterButton.frame.size.width) / 2, 6 }, _shutterButton.frame.size }];
        [self addSubview:_shutterButton];
        
        UIImageView *shutterButtonDivider = [[UIImageView alloc] initWithFrame:(CGRect){ 240, 0, 1 , 53 }];
        [shutterButtonDivider setImage:[[UIImage imageNamed:kGTIODividerImageName] resizableImageWithCapInsets:dividerEdgeInsets]];
        [self addSubview:shutterButtonDivider];
        
        // Shooting Mode
        UIImageView *cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload.bottom.bar.icon.small.normalcamera.png"]];
        [cameraImageView setFrame:(CGRect){ { shutterButtonDivider.frame.origin.x + shutterButtonDivider.frame.size.width + 13, 10 }, cameraImageView.image.size }];
        [self addSubview:cameraImageView];
        
        UIImageView *photoShootCameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload.bottom.bar.icon.small.photoshootcamera.png"]];
        [photoShootCameraImageView setFrame:(CGRect){ { cameraImageView.frame.origin.x + cameraImageView.frame.size.width + 25, 10 }, photoShootCameraImageView.image.size }];
        [self addSubview:photoShootCameraImageView];
        
        GTIOSwitch *photoModeSwitch = [[GTIOSwitch alloc] initWithFrame:(CGRect){ { shutterButtonDivider.frame.origin.x + shutterButtonDivider.frame.size.width + 9, 30 }, { 61, 17 } }];
        [photoModeSwitch setTrackOff:[[UIImage imageNamed:@"upload.bottom.bar.switch.bg.png"] resizableImageWithCapInsets:(UIEdgeInsets){17,17,17,17}]];
        [photoModeSwitch setTrackOn:[[UIImage imageNamed:@"upload.bottom.bar.switch.bg.on.png"] resizableImageWithCapInsets:(UIEdgeInsets){17, 17, 17, 17}]];
        [photoModeSwitch setKnob:[UIImage imageNamed:@"upload.bottom.bar.switch.png"]];
        [self addSubview:photoModeSwitch];
        
//        GTIOSlider *customSlider = [[GTIOSlider alloc] initWithFrame:(CGRect){ { shutterButtonDivider.frame.origin.x + shutterButtonDivider.frame.size.width + 9, 28 }, { 61, 17 } }];
//        [customSlider setThumbImage:[UIImage imageNamed:@"upload.bottom.bar.switch.png"] forState:UIControlStateNormal];
//        [customSlider setMinimumTrackImage:[[UIImage imageNamed:@"upload.bottom.bar.switch.bg.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 5, 15, 5, 15 }] forState:UIControlStateNormal];
//        [customSlider setMaximumTrackImage:[[UIImage imageNamed:@"upload.bottom.bar.switch.bg.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 5, 15, 5, 15 }] forState:UIControlStateNormal];
//        [customSlider setMinimumValue:0.0f];
//        [customSlider setMaximumValue:1.0f];
//        [self addSubview:customSlider];
        
    }
    return self;
}

@end
