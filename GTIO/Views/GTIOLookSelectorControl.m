//
//  GTIOLookSelectorControl.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOLookSelectorControl.h"

@interface GTIOLookSelectorControl()

@property (nonatomic, strong) UIButton *singlePhotoSelector;
@property (nonatomic, strong) UIButton *photoSetSelector;
@property (nonatomic, strong) UIImageView *backgroundView;

@property (nonatomic, strong) UIImage *singleBackground;
@property (nonatomic, strong) UIImage *multiBackground;

@end

@implementation GTIOLookSelectorControl

@synthesize singlePhotoSelector = _singlePhotoSelector, photoSetSelector = _photoSetSelector, backgroundView = _backgroundView, delegate = _delegate, singleBackground = _singleBackground, multiBackground = _multiBackground;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.singleBackground = [UIImage imageNamed:@"frames-toggle-single.png"];
        self.multiBackground = [UIImage imageNamed:@"frames-toggle-multiple.png"];
        
        self.backgroundView = [[UIImageView alloc] initWithImage:self.singleBackground];
        [self.backgroundView setFrame:(CGRect){ 0, 0, self.backgroundView.bounds.size }];
        [self addSubview:self.backgroundView];
        
        self.singlePhotoSelector = [[UIButton alloc] initWithFrame:(CGRect){ 0, 0, self.backgroundView.bounds.size.width, self.backgroundView.bounds.size.height / 2 }];
        [self.singlePhotoSelector addTarget:self action:@selector(selectSinglePhotoLayout:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.singlePhotoSelector];
        
        self.photoSetSelector = [[UIButton alloc] initWithFrame:(CGRect){ 0, self.backgroundView.bounds.size.height / 2, self.backgroundView.bounds.size.width, self.backgroundView.bounds.size.height / 2 }];
        [self.photoSetSelector addTarget:self action:@selector(selectMultiPhotoLayout:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.photoSetSelector];
    }
    return self;
}

- (void)selectSinglePhotoLayout:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(setIsPhotoSet:)]) {
        [self.delegate setIsPhotoSet:NO];
        [self.backgroundView setImage:self.singleBackground];
    }
}

- (void)selectMultiPhotoLayout:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(setIsPhotoSet:)]) {
        [self.delegate setIsPhotoSet:YES];
        [self.backgroundView setImage:self.multiBackground];
    }
}

@end
