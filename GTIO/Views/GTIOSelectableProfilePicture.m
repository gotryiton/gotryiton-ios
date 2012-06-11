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
@property (nonatomic, strong) UIView *canvas;
@property (nonatomic, strong) UIView *border;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation GTIOSelectableProfilePicture

@synthesize isSelectable = _isSelectable, isSelected = _isSelected, imageURL = _imageURL, delegate = _delegate, image = _image;
@synthesize imageView = _imageView, tapGestureRecognizer = _tapGestureRecognizer, border = _border, canvas = _canvas;

- (id)initWithFrame:(CGRect)frame andImageURL:(NSURL*)url
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:NO];
        
        self.canvas = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, frame.size }];
        [self.canvas.layer setCornerRadius:3.0f];
        [self.canvas.layer setMasksToBounds:YES];
        [self addSubview:self.canvas];
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setIsSelectedGesture:)];
        
        self.imageView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,frame.size}];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setImageWithURL:url];
        [self.canvas addSubview:self.imageView];
        [self fadeInImageView];
        
        self.border = [[UIView alloc] initWithFrame:(CGRect){ -2, -2, self.frame.size.width + 4, self.frame.size.height + 4 }];
        [self.border.layer setCornerRadius:3.0f];
        [self.border setBackgroundColor:[UIColor gtio_greenBorderColor]];
        
        self.isSelected = NO;
        self.isSelectable = YES;
        self.imageURL = url;
    }
    return self;
}

- (void)setImageWithURL:(NSURL*)url
{
    self.imageURL = url;
    
    __block GTIOSelectableProfilePicture *blockSelf = self;
    
    [self.imageView setImageWithURL:url placeholderImage:nil success:^(UIImage *image) {
        [blockSelf fadeInImageView];
    } failure:^(NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)setImage:(UIImage*)image
{
    _image = image;
    [_imageView setImage:image];
    [self fadeInImageView];
}

- (void)setIsSelectable:(BOOL)isSelectable
{
    _isSelectable = isSelectable;
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

- (void)setIsSelectedGesture:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(pictureWasTapped:)]) {
        [self.delegate pictureWasTapped:self];
    }
    [self setIsSelected:!self.isSelected];
}

- (void)fadeInImageView
{
    [self.imageView setAlpha:0.0];
    [UIView animateWithDuration:0.25 animations:^{
        [self.imageView setAlpha:1.0];
    }];
}

@end
