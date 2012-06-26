//
//  ACScrollView.m
//  WebViewDemo
//
//  Created by Simon Holroyd on 6/10/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//

static CGFloat const kGTIOHorizontalButtonPadding = 5.0f;

#import "GTIOAutoCompleteScrollView.h"

#import "GTIOAutoCompleteButton.h"

@implementation GTIOAutoCompleteScrollView

@synthesize autoCompleteDelegate = _autoCompleteDelegate;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canCancelContentTouches = YES;
        self.userInteractionEnabled = YES;
        self.delaysContentTouches = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.exclusiveTouch = NO;
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view 
{ 
    return ![view isKindOfClass:[UISlider class]]; 
}

#pragma mark UIScrollView methods

- (void) clearScrollView 
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[GTIOAutoCompleteButton class]])
            [view removeFromSuperview];
    }
    [self setContentSize:CGSizeMake( 0, 50 )];
}

- (void) showButtonsWithAutoCompleters:(NSArray *) buttons 
{
    [self clearScrollView];
    [self addButtonOptionsToScrollViewWithAutoCompleters:buttons];
}

- (void) addButtonOptionsToScrollViewWithAutoCompleters:(NSArray *) buttons
{
    int xOrigin = kGTIOHorizontalButtonPadding;
    
    for (GTIOAutoCompleter *option in buttons) {
        GTIOAutoCompleteButton *optionButton = [[GTIOAutoCompleteButton alloc] initWithFrame:(CGRect){ xOrigin, 11, 30, 34 } completer:option];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [optionButton addGestureRecognizer: singleTap];
        [self addSubview:optionButton];
        
        xOrigin += optionButton.frame.size.width + kGTIOHorizontalButtonPadding;
    }
    
    [self setContentSize:CGSizeMake( xOrigin, 50 )];
}

#pragma mark - Buttons

- (void)AutoCompleterButtonTouched:(GTIOAutoCompleteButton* )button
{
    GTIOAutoCompleter *completer = button.completer;
    if([self.autoCompleteDelegate respondsToSelector:@selector(autoCompleterIdSelected:)]) {
        [self.autoCompleteDelegate autoCompleterIdSelected:completer.completerID];
    }
    
    [self clearScrollView];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer 
{
    [self AutoCompleterButtonTouched:(GTIOAutoCompleteButton *)gestureRecognizer.view];
}

@end
