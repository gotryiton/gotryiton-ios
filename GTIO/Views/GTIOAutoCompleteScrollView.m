//
//  ACScrollView.m
//  WebViewDemo
//
//  Created by Simon Holroyd on 6/10/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//

static CGFloat const kGTIOHorizontalButtonPadding = 6.0f;
static CGFloat const kGTIOVerticalButtonPadding = 12.0f;
static CGFloat const kGTIONavTextPadding = 7.0f;
static CGFloat const kGTIONavTextFontSize = 14.0f;
static CGFloat const kGTIONavTextLineHeight = 18.0f;
static CGFloat const kGTIONavTextBaseline = 5.0f;
static CGFloat const kGTIONavArrowBaseline = 9.0f;
static CGFloat const kGTIOAutoCompleterButtonYPosition = 12.0f;

static NSString * const kGTIOAtTagHelperText = @"start typing a friend's name...";
static NSString * const kGTIOHashTagHelperText = @"type a hashtag to group with other similar looks!";
static NSString * const kGTIOBrandTagHelperText = @"start typing a brand...";

#import "GTIOAutoCompleteScrollView.h"

#import "GTIOAutoCompleteButton.h"

@implementation GTIOAutoCompleteScrollView

@synthesize autoCompleteDelegate = _autoCompleteDelegate;
@synthesize autoCompleteNav = _autoCompleteNav, autoCompleteHelperText = _autoCompleteHelperText;
@synthesize isScrollViewNavShowing = _isScrollViewNavShowing;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canCancelContentTouches = YES;
        self.userInteractionEnabled = YES;
        self.delaysContentTouches = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.exclusiveTouch = NO;

        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"keyboard-top-control-bg.png"]];

        _autoCompleteNav = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.bounds), 50)];

        GTIOAutoCompleteScrollView *blockSelf = self;
	
        GTIOUIButton *attagBtn = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeAutoCompleteAttag tapHandler:^(id sender) {
            if([blockSelf.autoCompleteDelegate respondsToSelector:@selector(autoCompleterModeSelected:)]) {
                [blockSelf.autoCompleteDelegate autoCompleterModeSelected:@"@"];
            }
        }];

        [attagBtn setFrame:(CGRect){ { kGTIOHorizontalButtonPadding, kGTIOVerticalButtonPadding    }, attagBtn.bounds.size }];
        [_autoCompleteNav addSubview:attagBtn];

        GTIOUIButton *hashtagBtn = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeAutoCompleteHashtag tapHandler:^(id sender) {
            if([blockSelf.autoCompleteDelegate respondsToSelector:@selector(autoCompleterModeSelected:)]) {
                [blockSelf.autoCompleteDelegate autoCompleterModeSelected:@"#"];
            }

        }];

        [hashtagBtn setFrame:(CGRect){ { CGRectGetMaxX(attagBtn.frame) + kGTIOHorizontalButtonPadding, kGTIOVerticalButtonPadding }, hashtagBtn.bounds.size }];
        [_autoCompleteNav addSubview:hashtagBtn];

        // GTIOUIButton *brandtagBtn = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeAutoCompleteBrandtag tapHandler:^(id sender) {
        //     if([blockSelf.autoCompleteDelegate respondsToSelector:@selector(autoCompleterModeSelected:)]) {
        //         [blockSelf.autoCompleteDelegate autoCompleterModeSelected:@"b"];
        //     }

        // }];

        // [brandtagBtn setFrame:(CGRect){ { CGRectGetMaxX(hashtagBtn.frame) + kGTIOHorizontalButtonPadding, kGTIOVerticalButtonPadding }, brandtagBtn.bounds.size }];
        // [_autoCompleteNav addSubview:brandtagBtn];

        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyboard-top-control-arrow.png"]];
        [arrowView setFrame:(CGRect){ { CGRectGetMaxX(hashtagBtn.frame) + kGTIONavTextPadding , CGRectGetMaxY(self.bounds) - arrowView.bounds.size.height  - kGTIONavArrowBaseline   }, arrowView.bounds.size }];
        [_autoCompleteNav addSubview:arrowView];

        UILabel *instructions = [[UILabel alloc] initWithFrame:(CGRect){ CGRectGetMaxX(arrowView.frame)+ kGTIOHorizontalButtonPadding, CGRectGetMaxY(self.bounds)- kGTIONavTextBaseline -kGTIONavTextLineHeight, 150, kGTIONavTextLineHeight }];
        [instructions setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:kGTIONavTextFontSize]];
        [instructions setTextColor:[UIColor gtio_grayTextColorACACAC]];
        [instructions setBackgroundColor:[UIColor clearColor]];
        [instructions setText:@"tag something!"];
        [_autoCompleteNav addSubview:instructions];
        _isScrollViewNavShowing = YES;

       [self addSubview:self.autoCompleteNav];


        _autoCompleteHelperText = [[UILabel alloc]  initWithFrame:(CGRect){ {self.bounds.size.width, CGRectGetMaxY(self.bounds)- kGTIONavTextBaseline - kGTIONavTextLineHeight}, {self.bounds.size.width, kGTIONavTextLineHeight  }}];
        [_autoCompleteHelperText setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:kGTIONavTextFontSize]];
        [_autoCompleteHelperText setTextColor:[UIColor gtio_pinkTextColor]];
        [_autoCompleteHelperText setBackgroundColor:[UIColor clearColor]];
        self.autoCompleteHelperText.hidden = YES;
        [self addSubview:self.autoCompleteHelperText];


    }
    return self;
}

-(void)showScrollViewNav 
{
    if (!self.isScrollViewNavShowing) {

        self.isScrollViewNavShowing = YES;
        
        [self hidePromptTextTowardsRight:YES];

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect scrollFrameBox = (CGRect){ {0, 0}, self.bounds.size};
            [self.autoCompleteNav setFrame:scrollFrameBox];
            // [self.scrollViewBackground setFrame:scrollFrameBox];

        } completion:nil];
    }
}

-(void)hideScrollViewNav 
{
    if (self.isScrollViewNavShowing) {
        self.isScrollViewNavShowing = NO;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect scrollFrameBox = (CGRect){ {-self.bounds.size.width, 0}, self.bounds.size};
            [self.autoCompleteNav setFrame:scrollFrameBox];
        } completion:nil];
    }
}

-(void)showPromptTextForMode:(NSString *)mode
{
    [self hideScrollViewNav];
    [self.autoCompleteHelperText setText:[self promptTextForType:mode]];
    self.autoCompleteHelperText.hidden = NO;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        CGRect scrollFrameBox = (CGRect){ { kGTIOHorizontalButtonPadding, self.autoCompleteHelperText.frame.origin.y}, self.autoCompleteHelperText.frame.size};
        [self.autoCompleteHelperText setFrame:scrollFrameBox];
        // [self.scrollViewBackground setFrame:scrollFrameBox];

    } completion:nil];
}

-(NSString *)promptTextForType:(NSString *)type
{
    if ([type isEqualToString:@"@"]){
        return kGTIOAtTagHelperText;
    }
    if ([type isEqualToString:@"#"]){
        return kGTIOHashTagHelperText;
    }
    if ([type isEqualToString:@"b"]){
        return kGTIOBrandTagHelperText;
    }
    return @"";
}

-(void)hidePromptTextTowardsRight:(BOOL)rightDirection
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        CGFloat exitDirection = self.bounds.size.width;
        if (!rightDirection){
            exitDirection = -self.autoCompleteHelperText.frame.size.width;
        }
        CGRect scrollFrameBox = (CGRect){ { exitDirection , self.autoCompleteHelperText.frame.origin.y}, self.autoCompleteHelperText.frame.size};
        [self.autoCompleteHelperText setFrame:scrollFrameBox];
        self.autoCompleteHelperText.hidden = YES;

    } completion:nil];
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
    [self hideScrollViewNav];
    [self hidePromptTextTowardsRight:NO];
    [self clearScrollView];
    [self addButtonOptionsToScrollViewWithAutoCompleters:buttons];
}

- (void) addButtonOptionsToScrollViewWithAutoCompleters:(NSArray *) buttons
{
    int xOrigin = kGTIOHorizontalButtonPadding;
    
    for (GTIOAutoCompleter *option in buttons) {
        GTIOAutoCompleteButton *optionButton = [GTIOAutoCompleteButton gtio_autoCompleteButtonWithCompleter:option];
        [optionButton setFrame:(CGRect){ { xOrigin, kGTIOAutoCompleterButtonYPosition }, optionButton.frame.size }];        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [optionButton addGestureRecognizer:singleTap];
        [self addSubview:optionButton];
        
        xOrigin += optionButton.frame.size.width + kGTIOHorizontalButtonPadding;
    }
    
    [self setContentSize:CGSizeMake( xOrigin, 50 )];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    GTIOAutoCompleter *completer = ((GTIOAutoCompleteButton *)gestureRecognizer.view).completer;
    if([self.autoCompleteDelegate respondsToSelector:@selector(autoCompleterIDSelected:)]) {
        [self.autoCompleteDelegate autoCompleterIDSelected:completer.completerID];
    }
    
    [self clearScrollView];
    [self showScrollViewNav];
}

@end
