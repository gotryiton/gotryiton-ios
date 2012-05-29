//
//  GTIOLookSelectorView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOLookSelectorView.h"
#import "GTIODeletableImageView.h"
#import "GTIOPhotoSelectBoxButton.h"
#import <QuartzCore/QuartzCore.h>

@interface GTIOLookSelectorView()

@property (nonatomic, strong) UIView *photoSetView;
@property (nonatomic, strong) GTIODeletableImageView *singlePhotoView;
@property (nonatomic, assign) BOOL isPhotoSet;

@end

@implementation GTIOLookSelectorView

@synthesize  isPhotoSet = _isPhotoSet, photoSetView = _photoSetView, singlePhotoView = _singlePhotoView;

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
        
        self.singlePhotoView = [[GTIODeletableImageView alloc] initWithFrame:(CGRect){ 5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10 }];
        
        self.photoSetView = [[UIView alloc] initWithFrame:(CGRect){ 5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10 }];
        UIImage *backgroundImage = [UIImage imageNamed:@"photo-frame.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [backgroundImageView setFrame:(CGRect){ 0, 0, self.photoSetView.bounds.size }];
        [self.photoSetView addSubview:backgroundImageView];
        GTIODeletableImageView *tallLeftPhoto = [[GTIODeletableImageView alloc] initWithFrame:(CGRect){ 5, 5, 105, 291 }];
        [self.photoSetView addSubview:tallLeftPhoto];
        GTIODeletableImageView *tallRightPhoto = [[GTIODeletableImageView alloc] initWithFrame:(CGRect){ 116, 5, 105, 180 }];
        [self.photoSetView addSubview:tallRightPhoto];
        GTIODeletableImageView *smallRightPhoto = [[GTIODeletableImageView alloc] initWithFrame:(CGRect){ 116, 190, 105, 106 }];
        [self.photoSetView addSubview:smallRightPhoto];
        
        [self refreshView];
    }
    return self;
}

- (void)setIsPhotoSet:(BOOL)isPhotoSet
{
    _isPhotoSet = isPhotoSet;
    [self refreshView];
}

- (void)refreshView
{
    [self.singlePhotoView removeFromSuperview];
    [self.photoSetView removeFromSuperview];
    
    if (self.isPhotoSet) {
        [self addSubview:self.photoSetView];
        [self bringSubviewToFront:self.photoSetView];
    } else {
        [self addSubview:self.singlePhotoView];
        [self bringSubviewToFront:self.singlePhotoView];
    }
}

@end
