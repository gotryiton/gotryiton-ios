//
//  GTIOPostAutoCompleteView.m
//  GTIO
//
//  Created by Scott Penrose on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostAutoCompleteView.h"

static NSString * kGTIOMDefaultPostText = @"Say something about this look! (e.g. How does this Zara top look? @becky #wedding)";

@implementation GTIOPostAutoCompleteView

@synthesize textViewDidEndHandler = _textViewDidEndHandler, textViewWillBecomeActiveHandler = _textViewWillBecomeActiveHandler, textViewDidBecomeActiveHandler = _textViewDidBecomeActiveHandler;

@synthesize placeHolderLabelView = _placeHolderLabelView;

- (id)initWithFrame:(CGRect)frame outerBox:(CGRect) outerFrame title:(NSString *)title icon:(UIImage *)icon
{
    self = [super initWithFrame:frame outerBox:outerFrame placeholder:kGTIOMDefaultPostText];
    if (self) {
        [self.textInput setDelegate:self];

        self.placeHolderLabelView = [[UIView alloc] initWithFrame:(CGRect){ CGRectGetMinX(frame) , 0, frame.size.width + 5, 30 }];
        [self addSubview:self.placeHolderLabelView];
       
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        [iconView setFrame:(CGRect){ self.placeHolderLabelView.bounds.size.width - iconView.bounds.size.width , 5, iconView.bounds.size }];
        [self.placeHolderLabelView addSubview:iconView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 0, 9, self.placeHolderLabelView.bounds.size.width - iconView.bounds.size.width - 17, 15 }];
        [titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:12.0]];
        [titleLabel setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        [titleLabel setAlpha:0.5];
        [titleLabel setText:title];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.placeHolderLabelView addSubview:titleLabel];

        [self bringSubviewToFront:self.textInput];
    }
    return self;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL response = [super textView:textView shouldChangeTextInRange:range replacementText:text];
    
    if([text isEqualToString:@"\n"]) {
        [self hideOrShowPlaceholderLabel];
        if (self.textViewDidEndHandler) {
            self.textViewDidEndHandler(self, YES);
        } else {
            [self.textInput resignFirstResponder];
        }
        return NO;
    }
    else {
        [self hidePlaceholderLabel];
    }
    return response;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self hidePlaceholderLabel];
    [self showPlaceholderText];

    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.textViewDidBecomeActiveHandler) {
        self.textViewDidBecomeActiveHandler(self);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self hideOrShowPlaceholderLabel];
    if (self.textViewDidEndHandler) {
        self.textViewDidEndHandler(self, YES);
    }
}


- (void)hideOrShowPlaceholderLabel
{
    if ([[self.textInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        [self hidePlaceholderLabel];
    } else {
        [self showPlaceholderLabel];
    }
}

- (void)showPlaceholderLabel
{
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
        self.placeHolderLabelView.alpha = 1;
    } completion:^(BOOL finished) {
         [self hidePlaceholderText];
    }];
}

- (void)hidePlaceholderLabel
{
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
        self.placeHolderLabelView.alpha = 0;
    } completion:^(BOOL finished) {
         [self showPlaceholderText];
    }];
}

- (void) resetView 
{
    [super resetView];
    [self showPlaceholderLabel];
}

@end
