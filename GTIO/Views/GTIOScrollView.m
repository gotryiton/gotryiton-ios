//
//  GTIOScrollView.m
//  GTIO
//
//  Created by Scott Penrose on 6/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOScrollView.h"

static CGFloat const kGTIOKeyboardInputAccessoryViewHeight = 50.0f;

@interface GTIOScrollView ()

@property (nonatomic, retain) UITapGestureRecognizer* singleTap;

@end

@implementation GTIOScrollView

@synthesize keyboardShowing = _keyboardShowing;
@synthesize resizeForKeyboard = _resizeForKeyboard;
@synthesize offsetFromBottom = _offsetFromBottom;
@synthesize singleTap = _singleTap;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyboardShowing = NO;
        self.resizeForKeyboard = YES;
        self.offsetFromBottom = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIKeyboardNotifications

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardBounds;
    [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];

    if (!self.keyboardShowing && self.resizeForKeyboard) {
        self.keyboardShowing = YES;
        
        [UIView animateWithDuration:0.3f animations:^{
            UIEdgeInsets contentInset = self.contentInset;
            UIEdgeInsets scrollInset = self.scrollIndicatorInsets;
            
            CGFloat offset = keyboardBounds.size.height - self.offsetFromBottom - kGTIOKeyboardInputAccessoryViewHeight;
            contentInset.bottom += offset;
            scrollInset.bottom += offset;
            
            self.contentInset = contentInset;
            self.scrollIndicatorInsets = scrollInset;
            [self scrollRectToVisible:(CGRect){ 0, self.contentSize.height - 1, 1, 1 } animated:NO];
        } completion:nil];
    } else if (!self.keyboardShowing) {
        self.keyboardShowing = YES;
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGRect keyboardBounds;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    if (self.keyboardShowing && self.resizeForKeyboard) {
        self.keyboardShowing = NO;
        
        [UIView animateWithDuration:0.3f animations:^{
            UIEdgeInsets contentInset = self.contentInset;
            UIEdgeInsets scrollInset = self.scrollIndicatorInsets;
            
            CGFloat offset = keyboardBounds.size.height - self.offsetFromBottom - kGTIOKeyboardInputAccessoryViewHeight;
            contentInset.bottom -= offset;
            scrollInset.bottom -= offset;
            
            self.contentInset = contentInset;
            self.scrollIndicatorInsets = scrollInset;
        }];
    } else if (self.keyboardShowing) {
        self.keyboardShowing = NO;
    }
}

@end
