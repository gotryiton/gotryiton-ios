//
//  GTIOOutfitReviewControlBar.m
//  GTIO
//
//  Created by Joshua Johnson on 2/8/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import "GTIOOutfitReviewControlBar.h"

const CGFloat kGTIOControlBarLeftOffset = 4.0;
const CGFloat kGTIOControlBarTopOffset = 12.0;

@interface GTIOOutfitReviewControlBar () {
    UIButton *_productSuggest;
    UIButton *_submitReview;
}
- (void)controlBarAction:(id)sender;
@end

@implementation GTIOOutfitReviewControlBar

#pragma mark - synth

@synthesize productSuggestHandler = _productSuggestHandler, submitReviewHandler = _submitReviewHandler;

#pragma mark - lifecycle

- (id)init {
    if (self = [super init]) {
        UIImage *backgroundImage = [[UIImage imageNamed:@"kb-controls-bg.png"] retain];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFrame:(CGRect){CGPointZero, backgroundImage.size}];
        
        UIImageView *backingImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:backingImageView];
        
        _productSuggest = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_productSuggest addTarget:self action:@selector(controlBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [_productSuggest setBackgroundImage:[UIImage imageNamed:@"kb-controls-suggest-OFF.png"] forState:UIControlStateNormal];
        [_productSuggest setBackgroundImage:[UIImage imageNamed:@"kb-controls-suggest-ON.png"] forState:UIControlStateHighlighted];
        [self addSubview:_productSuggest];

        _submitReview = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_submitReview addTarget:self action:@selector(controlBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitReview setBackgroundImage:[UIImage imageNamed:@"kb-controls-done-OFF.png"] forState:UIControlStateNormal];
        [_submitReview setBackgroundImage:[UIImage imageNamed:@"kb-controls-done-ON.png"] forState:UIControlStateHighlighted];
        [self addSubview:_submitReview];
    }
    return self;
}

- (void)dealloc {
    Block_release(_productSuggestHandler);
    Block_release(_submitReviewHandler);
    [_productSuggest release];
    [_submitReview release];
    [super dealloc];
}

#pragma mark - layout

- (void)layoutSubviews {
    UIImage *suggestImage = [_productSuggest backgroundImageForState:UIControlStateNormal];
    [_productSuggest setFrame:(CGRect){{kGTIOControlBarLeftOffset, kGTIOControlBarTopOffset}, suggestImage.size}];

    UIImage *doneImage = [_submitReview backgroundImageForState:UIControlStateNormal];
    [_submitReview setFrame:(CGRect){{self.frame.size.width - doneImage.size.width - kGTIOControlBarLeftOffset, kGTIOControlBarTopOffset}, doneImage.size}];
}

#pragma mark - button methods

- (void)controlBarAction:(id)sender {
    if (sender == _productSuggest && _productSuggestHandler) {
        _productSuggestHandler();
    } else if (sender == _submitReview && _submitReviewHandler) {
        _submitReviewHandler();
    }
}


@end
