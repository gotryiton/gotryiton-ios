//
//  GTIOPhotoConfirmationToolbarView.m
//  GTIO
//
//  Created by Scott Penrose on 5/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoConfirmationToolbarView.h"

@interface GTIOPhotoConfirmationToolbarView ()

@end

@implementation GTIOPhotoConfirmationToolbarView

@synthesize closeButton = _closeButton, confirmButton = _confirmButton;

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
        [_closeButton setFrame:(CGRect){ CGPointZero, { 50, _closeButton.frame.size.height } }];
        [self addSubview:_closeButton];
        
        UIImageView *closeButtonDivider = [[UIImageView alloc] initWithFrame:(CGRect){ _closeButton.frame.size.width + 1, 0, 1, 53 }];
        [closeButtonDivider setImage:[[UIImage imageNamed:@"upload.bottom.bar.divider.png"] resizableImageWithCapInsets:dividerEdgeInsets]];
        [self addSubview:closeButtonDivider];
        
        // Confirm Button
        _confirmButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypePhotoConfirm];
        [_confirmButton setFrame:(CGRect){ { self.frame.size.width - 50, 0 }, { 50, _confirmButton.frame.size.height } }];
        [self addSubview:_confirmButton];
        
        UIImageView *confirmButtonDivider = [[UIImageView alloc] initWithFrame:(CGRect){ self.frame.size.width - _confirmButton.frame.size.width - 1, 0, 1, 53 }];
        [confirmButtonDivider setImage:[[UIImage imageNamed:@"upload.bottom.bar.divider.png"] resizableImageWithCapInsets:dividerEdgeInsets]];
        [self addSubview:confirmButtonDivider];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:18.0f]];
        [titleLabel setText:@"use this photo?"];
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
