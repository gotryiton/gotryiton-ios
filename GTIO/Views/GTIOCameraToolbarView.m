//
//  GTIOPhotoToolbarView.m
//  GTIO
//
//  Created by Scott Penrose on 5/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOCameraToolbarView.h"

NSString * const kGTIODividerImageName = @"upload.bottom.bar.divider.png";

@interface GTIOCameraToolbarView ()

@property (nonatomic, strong) UIImageView *photoShootGridDivider;

@end

@implementation GTIOCameraToolbarView

@synthesize closeButton = _closeButton, photoPickerButton = _photoPickerButton, photoShootGridButton = _photoShootGridButton, shutterButton = _shutterButton, photoModeSwitch = _photoModeSwitch;
@synthesize photoShootGridDivider = _photoShootGridDivider;
@synthesize photoModeSwitchChangedHandler = _photoModeSwitchChangedHandler;

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
        
        _photoModeSwitch = [[GTIOSwitch alloc] initWithFrame:(CGRect){ { shutterButtonDivider.frame.origin.x + shutterButtonDivider.frame.size.width + 9, 30 }, { 61, 17 } }];
        [_photoModeSwitch setTrack:[UIImage imageNamed:@"upload.bottom.bar.switch.track.shadow.png"]];
        [_photoModeSwitch setTrackFrame:[UIImage imageNamed:@"upload.bottom.bar.switch.track.png"]];
        [_photoModeSwitch setTrackFrameMask:[UIImage imageNamed:@"upload.bottom.bar.switch.mask.png"]];
        [_photoModeSwitch setKnob:[UIImage imageNamed:@"upload.bottom.bar.switch.knob.png"]];

        [_photoModeSwitch setChangeHandler:^(BOOL on) {
            // Normal mode (default)
            NSString *shutterButtonImage = @"upload.bottom.bar.camera.button.icon.normal.png";
            
            if (self.photoModeSwitch.isOn) {
                // Photo shoot mode
                shutterButtonImage = @"upload.bottom.bar.camera.button.icon.photoshoot.png";
            } 
            
            [self.shutterButton setImage:[UIImage imageNamed:shutterButtonImage] forState:UIControlStateNormal];
            
            if (self.photoModeSwitchChangedHandler) {
                self.photoModeSwitchChangedHandler(on);
            }
        }];
        [self addSubview:_photoModeSwitch];
        
        [self showPhotoShootGrid:NO];
    }
    return self;
}
     
- (void)showPhotoShootGrid:(BOOL)showPhotoShootGrid
{
    // Normal mode (default)
    CGRect shutterButtonFrame = (CGRect){ { (self.frame.size.width - _shutterButton.frame.size.width) / 2, 6 }, _shutterButton.frame.size };

    if (showPhotoShootGrid) {
        // Photo shoot mode
        shutterButtonFrame = CGRectOffset(shutterButtonFrame, 20, 0);
    } 

    [self.photoShootGridButton setHidden:!showPhotoShootGrid];
    [self.photoShootGridDivider setHidden:!showPhotoShootGrid];
    [self.shutterButton setFrame:shutterButtonFrame];
}

- (void)enableAllButtons:(BOOL)enable
{
    [self.closeButton setEnabled:enable];
    [self.photoPickerButton setEnabled:enable];
    [self.photoShootGridButton setEnabled:enable];
    [self.shutterButton setEnabled:enable];
    [self.photoModeSwitch setEnabled:enable];
}

@end
