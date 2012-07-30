//
//  GTIOTableView.m
//  GTIO
//
//  Created by Scott Penrose on 7/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTableView.h"

@implementation GTIOTableView

@synthesize keyboardShowing = _keyboardShowing;
@synthesize resizeForKeyboard = _resizeForKeyboard;
@synthesize offsetFromBottom = _offsetFromBottom;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
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
            
            CGFloat offset = keyboardBounds.size.height - self.offsetFromBottom;
            contentInset.bottom += offset;
            scrollInset.bottom += offset;
            
            self.contentInset = contentInset;
            self.scrollIndicatorInsets = scrollInset;
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
            
            CGFloat offset = keyboardBounds.size.height - self.offsetFromBottom;
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
