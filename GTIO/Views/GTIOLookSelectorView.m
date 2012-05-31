//
//  GTIOLookSelectorView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOLookSelectorView.h"
#import "GTIOTakePhotoView.h"
#import "GTIOPhotoSelectBoxButton.h"
#import <QuartzCore/QuartzCore.h>

@interface GTIOLookSelectorView()

@property (nonatomic, strong) UIView *photoSetView;
@property (nonatomic, strong) GTIOTakePhotoView *singlePhotoView;

@property (nonatomic, strong) GTIOTakePhotoView *tallLeftPhoto;
@property (nonatomic, strong) GTIOTakePhotoView *tallRightPhoto;
@property (nonatomic, strong) GTIOTakePhotoView *smallRightPhoto;

@end

@implementation GTIOLookSelectorView

@synthesize  isPhotoSet = _isPhotoSet, photoSetView = _photoSetView, singlePhotoView = _singlePhotoView, tallLeftPhoto = _tallLeftPhoto, tallRightPhoto = _tallRightPhoto, smallRightPhoto = _smallRightPhoto, photoCanvasSize = _photoCanvasSize;

- (id)initWithFrame:(CGRect)frame asPhotoSet:(BOOL)photoSet
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isPhotoSet = photoSet;
        
        UIImageView *selfBackgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"border-bg.png"] stretchableImageWithLeftCapWidth:1.0 topCapHeight:1.0]];
        [selfBackgroundImageView setFrame:(CGRect){ 0, 0, self.bounds.size }];
        [self addSubview:selfBackgroundImageView];
        [self.layer setShadowColor:[UIColor grayColor].CGColor];
        [self.layer setShadowOffset:(CGSize){ 0.1, 3.0 }];
        [self.layer setShadowOpacity:0.20];
        [self.layer setShadowRadius:2.0];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        [self.layer setShadowPath:path.CGPath]; // scroll performance
        
        self.singlePhotoView = [[GTIOTakePhotoView alloc] initWithFrame:(CGRect){ 5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10 }];
        self.photoCanvasSize = (CGSize){ self.singlePhotoView.frame.size.width, self.singlePhotoView.frame.size.height };
        
        self.photoSetView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, self.bounds.size.width, self.bounds.size.height }];
        UIImage *backgroundImage = [UIImage imageNamed:@"photo-frame.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [backgroundImageView.layer setBorderColor:[UIColor gtio_photoBorderColor].CGColor];
        [backgroundImageView.layer setBorderWidth:0.5];
        [backgroundImageView setFrame:(CGRect){ 0, 0, self.photoSetView.bounds.size }];
        [self.photoSetView addSubview:backgroundImageView];
        self.tallLeftPhoto = [[GTIOTakePhotoView alloc] initWithFrame:(CGRect){ 6, 6, 109, 300 }];
        [self.photoSetView addSubview:self.tallLeftPhoto];
        self.tallRightPhoto = [[GTIOTakePhotoView alloc] initWithFrame:(CGRect){ 122, 6, 109, 184 }];
        [self.tallRightPhoto setDeleteButtonPosition:GTIODeleteButtonPositionRight];
        [self.photoSetView addSubview:self.tallRightPhoto];
        self.smallRightPhoto = [[GTIOTakePhotoView alloc] initWithFrame:(CGRect){ 122, 197, 109, 109 }];
        [self.smallRightPhoto setDeleteButtonPosition:GTIODeleteButtonPositionRight];
        [self.photoSetView addSubview:self.smallRightPhoto];
        
        [self refreshView]; 
    }
    return self;
}

- (void)setDeleteButtonsHidden:(BOOL)hidden
{
    [self.singlePhotoView setDeleteButtonHidden:hidden];
    [self.tallLeftPhoto setDeleteButtonHidden:hidden];
    [self.tallRightPhoto setDeleteButtonHidden:hidden];
    [self.smallRightPhoto setDeleteButtonHidden:hidden];
}

- (UIView *)getCompositeCanvas
{
    if (self.isPhotoSet) {
        return self.photoSetView;
    } else {
        return self.singlePhotoView;
    }
}

- (void)setIsPhotoSet:(BOOL)isPhotoSet
{
    _isPhotoSet = isPhotoSet;
    [self refreshView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
}

- (BOOL)selectionsComplete
{
    if (self.isPhotoSet) {
        return (self.tallLeftPhoto.imageView.image && self.tallRightPhoto.imageView.image && self.smallRightPhoto.imageView.image);
    } else {
        return (self.singlePhotoView.imageView.image != nil);
    }
}

- (void)refreshView
{
    [self.singlePhotoView removeFromSuperview];
    [self.photoSetView removeFromSuperview];
    
    if (self.isPhotoSet) {
        if (self.singlePhotoView.imageView.image && !self.tallLeftPhoto.imageView.image) {
            [self.tallLeftPhoto setImage:self.singlePhotoView.imageView.image];
        }
        [self addSubview:self.photoSetView];
        [self bringSubviewToFront:self.photoSetView];
    } else {
        if (!self.singlePhotoView.imageView.image && self.tallLeftPhoto.imageView.image) {
            [self.singlePhotoView setImage:self.tallLeftPhoto.imageView.image];
        }
        [self addSubview:self.singlePhotoView];
        [self bringSubviewToFront:self.singlePhotoView];
    }
}

@end
