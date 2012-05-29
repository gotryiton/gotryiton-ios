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
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation GTIOSelectableProfilePicture

@synthesize isSelectable = _isSelectable, isSelected = _isSelected, imageURL = _imageURL, delegate = _delegate, image = _image;
@synthesize imageView = _imageView, tapGestureRecognizer = _tapGestureRecognizer;

- (id)initWithFrame:(CGRect)frame andImageURL:(NSString*)url
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:3.0f];
        [self.layer setMasksToBounds:YES];
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setIsSelectedGesture:)];
        
        _imageView = [[UIImageView alloc] initWithFrame:(CGRect){ { 0, 0 }, frame.size }];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setImageWithURL:[NSURL URLWithString:url]];
        [self addSubview:_imageView];
        [self fadeInImageView];
        
        self.isSelected = NO;
        self.isSelectable = YES;
        self.imageURL = url;
    }
    return self;
}

- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    [_imageView setImageWithURL:[NSURL URLWithString:imageURL]];
    [self fadeInImageView];
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
        [self.layer setBorderColor:[UIColor gtio_greenBorderColor].CGColor];
        [self.layer setBorderWidth:2.0f];
    } else {
        [self.layer setBorderColor:nil];
        [self.layer setBorderWidth:0.0f];
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
