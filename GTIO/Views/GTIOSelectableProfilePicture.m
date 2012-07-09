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

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *innerShadow;
@property (nonatomic, strong) UIView *canvas;
@property (nonatomic, strong) UIView *border;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation GTIOSelectableProfilePicture

@synthesize isSelectable = _isSelectable, isSelected = _isSelected, imageURL = _imageURL, delegate = _delegate, image = _image, hasInnerShadow = _hasInnerShadow, hasOuterShadow = _hasOuterShadow;
@synthesize imageView = _imageView, tapGestureRecognizer = _tapGestureRecognizer, border = _border, canvas = _canvas, innerShadow = _innerShadow;

- (id)initWithFrame:(CGRect)frame andImageURL:(NSURL*)url
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:NO];
        
        _isSelected = NO;
        _isSelectable = YES;
        _imageURL = url;
        _hasInnerShadow = YES;
        _hasOuterShadow = NO;
        
        _canvas = [[UIView alloc] initWithFrame:CGRectZero];
        [_canvas.layer setCornerRadius:3.0f];
        [_canvas.layer setMasksToBounds:YES];
        [self addSubview:_canvas];
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setIsSelectedGesture:)];
        if (_isSelectable) {
            [self addGestureRecognizer:_tapGestureRecognizer];
        }
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        _innerShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"edit.profile.pic.thumb.mask.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 5.0, 5.0, 5.0, 5.0 }]];
        [_innerShadow setFrame:CGRectZero];
        _innerShadow.opaque = YES;
        _innerShadow.hidden = !_hasInnerShadow;
        [_canvas addSubview:_imageView];
        [_canvas addSubview:_innerShadow];
        
        _border = [[UIView alloc] initWithFrame:CGRectZero];
        [_border.layer setCornerRadius:3.0f];
        [_border setBackgroundColor:[UIColor gtio_greenBorderColor]];
        
        [self setImageWithURL:url];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.canvas setFrame:(CGRect){ 0, 0, self.bounds.size }];
    [self.imageView setFrame:(CGRect){ 0, 0, self.bounds.size }];
    [self.innerShadow setFrame:(CGRect){ 0, 0, self.bounds.size }];
    [self.border setFrame:(CGRect){ -2, -2, self.frame.size.width + 4, self.frame.size.height + 4 }];
    [self.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.bounds].CGPath];
}

- (void)setImageWithURL:(NSURL*)url
{
    BOOL animated = ![self.imageURL isEqual:url];
    self.imageURL = url;
    __block GTIOSelectableProfilePicture *blockSelf = self;
    [self.imageView setImageWithURL:url placeholderImage:nil success:^(UIImage *image) {
        [blockSelf showImageViewAnimated:animated];
    } failure:^(NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)setImage:(UIImage*)image
{
    _image = image;
    [_imageView setImage:image];
    [self showImageViewAnimated:YES];
}

- (void)setIsSelectable:(BOOL)isSelectable
{
    _isSelectable = isSelectable;
    self.userInteractionEnabled = _isSelectable;
    [self removeGestureRecognizer:_tapGestureRecognizer];
    if (self.isSelectable) {
        [self addGestureRecognizer:_tapGestureRecognizer];
    } else {
        [self removeGestureRecognizer:_tapGestureRecognizer];
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (self.isSelected) {
        [self addSubview:self.border];
        [self sendSubviewToBack:self.border];
    } else {
        [self.border removeFromSuperview];
    }
}

- (void)setHasOuterShadow:(BOOL)hasOuterShadow
{
    _hasOuterShadow = hasOuterShadow;
    if (_hasOuterShadow) {
        [self.layer setShadowRadius:5.0];
        [self.layer setShadowOffset:(CGSize){ 0, 0 }];
        [self.layer setShadowOpacity:0.50];
    } else {
        [self.layer setShadowRadius:0.0];
        [self.layer setShadowOffset:(CGSize){ 0, 0 }];
        [self.layer setShadowOpacity:0.0];
    }
}

- (void)setIsSelectedGesture:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(pictureWasTapped:)]) {
        [self.delegate pictureWasTapped:self];
    }
    [self setIsSelected:!self.isSelected];
}

- (void)showImageViewAnimated:(BOOL)animated
{
    self.innerShadow.hidden = !self.hasInnerShadow;
    [self.imageView setAlpha:0.0];
    [self.innerShadow setAlpha:0.0];
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self showImageView];
        }];
    } else {
        [self showImageView];
    }
}

- (void)showImageView
{
    [self.imageView setAlpha:1.0];
    [self.innerShadow setAlpha:1.0];
}

@end
