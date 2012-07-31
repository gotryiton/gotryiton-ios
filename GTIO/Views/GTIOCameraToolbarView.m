//
//  GTIOPhotoToolbarView.m
//  GTIO
//
//  Created by Scott Penrose on 5/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOCameraToolbarView.h"

static NSString * const kGTIODividerImageName = @"divider.png";
static CGFloat const kGTIOButtonPadding = 14.0f;
static CGFloat const kGTIODividerPadding = 50.0f;
static CGFloat const kGTIOButtonTapAreaPadding = 15.0f;

@interface GTIOCameraToolbarView ()

@property (nonatomic, strong) UIImageView *leftButtonDivider;

@end

@implementation GTIOCameraToolbarView

@synthesize closeButton = _closeButton, photoSourceButton = _photoSourceButton, photoShootGridButton = _photoShootGridButton, shutterButton = _shutterButton;
@synthesize leftButtonDivider = _leftButtonDivider;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ frame.origin, { frame.size.width, 53 } }];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ 0, -5, frame.size.width, 58 }];
        [backgroundImageView setImage:[UIImage imageNamed:@"upload.bottom.bar.png"]];
        [self addSubview:backgroundImageView];
        
        // Close Button
        _closeButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypePhotoClose];
        [_closeButton setFrame:(CGRect){ { self.frame.size.width - _closeButton.frame.size.width - kGTIOButtonPadding, (self.frame.size.height - _closeButton.frame.size.height) / 2 }, _closeButton.frame.size }];
        [_closeButton setTapAreaPadding:kGTIOButtonTapAreaPadding];
        [self addSubview:_closeButton];
        
        UIImageView *closeButtonDivider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kGTIODividerImageName]];
        [closeButtonDivider setFrame:(CGRect){ { self.frame.size.width - kGTIODividerPadding, (self.frame.size.height - closeButtonDivider.image.size.height) / 2 }, closeButtonDivider.image.size }];
        [self addSubview:closeButtonDivider];
        
        // Photo Picker Button
        _photoSourceButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypePhotoSource];
        [_photoSourceButton setFrame:(CGRect){ { kGTIOButtonPadding, (self.frame.size.height - _photoSourceButton.frame.size.height) / 2 }, _photoSourceButton.frame.size }];
        [_photoSourceButton setTapAreaPadding:kGTIOButtonTapAreaPadding];
        [self addSubview:_photoSourceButton];
        
        // Left Button Divider
        _leftButtonDivider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kGTIODividerImageName]];
        [self addSubview:_leftButtonDivider];
        
        // Photo Shoot Grid button
        _photoShootGridButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypePhotoShootGrid];
        [_photoShootGridButton setFrame:(CGRect){ { _photoSourceButton.frame.origin.x + _photoSourceButton.frame.size.width + kGTIOButtonPadding, (self.frame.size.height - _photoShootGridButton.frame.size.height) / 2 }, _photoShootGridButton.frame.size }];
        [_photoShootGridButton setTapAreaPadding:kGTIOButtonTapAreaPadding];
        [self addSubview:_photoShootGridButton];
        
        // Shutter Button
        _shutterButton = [[GTIOCameraShutterControl alloc] initWithFrame:CGRectZero];
        [self addSubview:_shutterButton];
        
        [self showPhotoShootGrid:NO];
    }
    return self;
}
     
- (void)showPhotoShootGrid:(BOOL)showPhotoShootGrid
{
    // Normal mode (default)
    CGRect shutterButtonFrame = (CGRect){ { (self.frame.size.width - _shutterButton.frame.size.width) / 2, 2 }, _shutterButton.frame.size };
    CGRect leftButtonDividerFrame = (CGRect){ { kGTIODividerPadding, (self.frame.size.height - self.leftButtonDivider.image.size.height) / 2 }, self.leftButtonDivider.image.size };

    if (showPhotoShootGrid) {
        // Photo shoot mode
        shutterButtonFrame = CGRectOffset(shutterButtonFrame, 20, 0);
        leftButtonDividerFrame = (CGRect){ { 89, (self.frame.size.height - self.leftButtonDivider.image.size.height) / 2 }, self.leftButtonDivider.image.size };
    } 

    [self.photoShootGridButton setHidden:!showPhotoShootGrid];
    [self.shutterButton setFrame:shutterButtonFrame];
    [self.leftButtonDivider setFrame:leftButtonDividerFrame];
}

- (void)enableAllButtons:(BOOL)enable
{
    [self.photoSourceButton setEnabled:enable];
    [self.photoShootGridButton setEnabled:enable];
    [self.shutterButton setEnabled:enable];
}

@end
