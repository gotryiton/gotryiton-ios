//
//  GTIOCameraShutterControl.m
//  GTIO
//
//  Created by Scott Penrose on 7/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOCameraShutterControl.h"

static CGFloat const kGTIOFrameWidth = 166.0f;
static CGFloat const kGTIOFrameHeight = 49.0f;

static CGFloat const kGTIOPhotoShootButtonWidth = 50.0f;

@interface GTIOCameraShutterControl ()

@property (nonatomic, strong) UIImageView *buttonImageView;

@property (nonatomic, strong) GTIOUIButton *shutterButton;
@property (nonatomic, strong) GTIOUIButton *photoShootButton;

@end

@implementation GTIOCameraShutterControl

@synthesize buttonImageView = _buttonImageView;
@synthesize shutterButton = _shutterButton, photoShootButton = _photoShootButton;
@synthesize photoShootMode = _photoShootMode;
@synthesize shutterButtonTapHandler = _shutterButtonTapHandler;
@synthesize photoModeSwitchChangedHandler = _photoModeSwitchChangedHandler;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ frame.origin, { kGTIOFrameWidth, kGTIOFrameHeight } }];
        
        _buttonImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_buttonImageView];
        
        __block typeof(self) blockSelf = self;
        
        _photoShootButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeMask];
        [_photoShootButton setFrame:(CGRect){ self.frame.size.width - kGTIOPhotoShootButtonWidth, 0, kGTIOPhotoShootButtonWidth, self.frame.size.height }];
        [_photoShootButton setTapHandler:^(id sender) {
            [blockSelf setPhotoShootMode:!blockSelf.isPhotoShootMode];
        }];
        [self addSubview:_photoShootButton];
        
        __block GTIOUIButton *blockShutterButton = _shutterButton;
        _shutterButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeMask];
        [_shutterButton setFrame:(CGRect){ CGPointZero, { self.frame.size.width - _photoShootButton.frame.size.width, self.frame.size.height } }];
        [_shutterButton setTapHandler:^(id sender) {
            NSString *imageName = @"capture.normal.inactive.png";
            if (self.isPhotoShootMode) {
                imageName = @"capture.pro.inactive.png";
            }
            [self.buttonImageView setImage:[UIImage imageNamed:imageName]];
            
            // Call back to handle taking picture
            if (self.shutterButtonTapHandler) {
                self.shutterButtonTapHandler(blockShutterButton);
            }
        }];
        [_shutterButton setTouchDownHandler:^(id sender) {
            NSString *imageName = @"capture.normal.active.png";
            if (self.isPhotoShootMode) {
                imageName = @"capture.pro.active.png";
            }
            [self.buttonImageView setImage:[UIImage imageNamed:imageName]];
        }];
        [_shutterButton setTouchDragExitHandler:^(id sender) {
            NSString *imageName = @"capture.normal.inactive.png";
            if (self.isPhotoShootMode) {
                imageName = @"capture.pro.inactive.png";
            }
            [self.buttonImageView setImage:[UIImage imageNamed:imageName]];
        }];
        [self addSubview:_shutterButton];
        
        // Starting state
        [self.buttonImageView setImage:[UIImage imageNamed:@"capture.normal.inactive.png"]];
    }
    return self;
}

#pragma mark - Properties

- (void)setPhotoShootMode:(BOOL)photoShootMode
{
    _photoShootMode = photoShootMode;
    
    NSString *imageName = @"capture.normal.inactive.png";
    if (_photoShootMode) {
        imageName = @"capture.pro.inactive.png";
    }
    [self.buttonImageView setImage:[UIImage imageNamed:imageName]];
    
    if (self.photoModeSwitchChangedHandler) {
        self.photoModeSwitchChangedHandler(_photoShootMode);
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self.shutterButton setEnabled:enabled];
    [self.photoShootButton setEnabled:enabled];
}

@end
