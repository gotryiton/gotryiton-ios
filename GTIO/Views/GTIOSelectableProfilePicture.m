//
//  GTIOSelectableProfilePicture.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOSelectableProfilePicture.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface GTIOSelectableProfilePicture()
{
    @private
    UIImageView *imageView;
    UITapGestureRecognizer *tapGestureRecognizer;
}

@end

@implementation GTIOSelectableProfilePicture

@synthesize isSelectable = _isSelectable, isSelected = _isSelected, imageURL = _imageURL, delegate = _delegate;

- (id)initWithFrame:(CGRect)frame andImageURL:(NSString*)url
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:3.0f];
        [self.layer setMasksToBounds:YES];
        
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setIsSelectedGesture:)];
        
        imageView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,frame.size}];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setImageWithURL:[NSURL URLWithString:url]];
        [self addSubview:imageView];
        [self fadeInImageView];
        
        self.isSelected = NO;
        self.isSelectable = YES;
        self.imageURL = url;
    }
    return self;
}

- (void)setImageWithURL:(NSString*)url
{
    self.imageURL = url;
    [imageView setImageWithURL:[NSURL URLWithString:url]];
    [self fadeInImageView];
}

- (void)setImage:(UIImage*)image
{
    [imageView setImage:image];
    [self fadeInImageView];
}

- (void)setIsSelectable:(BOOL)isSelectable
{
    _isSelectable = isSelectable;
    if (self.isSelectable) {
        [self addGestureRecognizer:tapGestureRecognizer];
    } else {
        [self removeGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (self.isSelected) {
        [self.layer setBorderColor:[UIColor gtio_greenBorderColor].CGColor];
        [self.layer setBorderWidth:2.0f];
    } else {
        [self.layer setBorderColor:nil];
        [self.layer setBorderWidth:0.0f];
    }
}

- (void)setIsSelectedGesture:(UITapGestureRecognizer *)sender
{
    if ([_delegate respondsToSelector:@selector(pictureWasTapped:)]) {
        [_delegate pictureWasTapped:self];
    }
    [self setIsSelected:!self.isSelected];
}

- (void)fadeInImageView {
    [imageView setAlpha:0.0];
    [UIView animateWithDuration:0.25 animations:^{
        [imageView setAlpha:1.0];
    }];
}

@end
