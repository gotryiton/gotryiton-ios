//
//  GTIOPhotoConfirmationToolbarView.m
//  GTIO
//
//  Created by Scott Penrose on 5/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoConfirmationToolbarView.h"

static NSString * const kGTIODividerImageName = @"divider.png";
static CGFloat const kGTIOCloseButtonPadding = 16.0f;
static CGFloat const kGTIOConfirmButtonPadding = 13.0f;
static CGFloat const kGTIODividerPadding = 50.0f;
static CGFloat const kGTIOConfirmButtonTapPadding = 15.0f;

@interface GTIOPhotoConfirmationToolbarView ()

@end

@implementation GTIOPhotoConfirmationToolbarView

@synthesize closeButton = _closeButton, confirmButton = _confirmButton;

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
        [_closeButton setFrame:(CGRect){ { kGTIOCloseButtonPadding, (self.frame.size.height - _closeButton.frame.size.height) / 2 }, _closeButton.frame.size }];
        [_closeButton setTapAreaPadding:kGTIOConfirmButtonTapPadding];
        [self addSubview:_closeButton];
        
        UIImageView *closeButtonDivider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kGTIODividerImageName]];
        [closeButtonDivider setFrame:(CGRect){ { kGTIODividerPadding, (self.frame.size.height - closeButtonDivider.image.size.height) / 2 }, closeButtonDivider.image.size }];
        [self addSubview:closeButtonDivider];
        
        // Confirm Button
        _confirmButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypePhotoConfirm];
        [_confirmButton setFrame:(CGRect){ { self.frame.size.width - _confirmButton.frame.size.width - kGTIOConfirmButtonPadding, (self.frame.size.height - _closeButton.frame.size.height) / 2 }, _confirmButton.frame.size }];
        [_confirmButton setTapAreaPadding:kGTIOConfirmButtonTapPadding];
        [self addSubview:_confirmButton];
        
        UIImageView *confirmButtonDivider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kGTIODividerImageName]];
        [confirmButtonDivider setFrame:(CGRect){ { self.frame.size.width - kGTIODividerPadding - 1, (self.frame.size.height - confirmButtonDivider.image.size.height) / 2 }, confirmButtonDivider.image.size }];
        [self addSubview:confirmButtonDivider];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:16.0f]];
        [titleLabel setText:@"use this photo?"];
        [titleLabel setTextColor:[UIColor gtio_grayTextColor8F8F8F]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel sizeToFit];
        [titleLabel setFrame:(CGRect){ { (self.frame.size.width - titleLabel.frame.size.width) / 2, 18 }, titleLabel.frame.size }];
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)showPhotoShootGridButton:(BOOL)showPhotoShootGridButton
{
    NSString *closeImageName = @"upload.bottom.bar.icon.x.png";
    if (showPhotoShootGridButton) {
        closeImageName = @"upload.bottom.bar.icon.photoshootreel.png";
    }
    [self.closeButton setImage:[UIImage imageNamed:closeImageName] forState:UIControlStateNormal];
}

@end
