//
//  GTIOScrollView.m
//  GTIO
//
//  Created by Scott Penrose on 6/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOScrollView.h"

@interface GTIOScrollView ()

@property (nonatomic, retain) UITapGestureRecognizer* singleTap;

@property (nonatomic, assign) BOOL keyboardShowing;

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
        
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [self.singleTap setDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeGestureRecognizer:_singleTap];
}

-(void)dismissKeyboard:(UIGestureRecognizer*)sender
{
//    [[self.window findFirstResponder] resignFirstResponder];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    if (gestureRecognizer == self.singleTap) {
//        CGPoint touchPoint = [touch locationInView:self];
//        
//        UITableViewCell* cell = nil;
//        
//        // hit is in this table view, find out 
//        // which cell it is in (if any)
//        for (UITableViewCell* aCell in self.visibleCells) {
//            if ([aCell pointInside:[self convertPoint:touchPoint toView:aCell] withEvent:nil]) {
//                cell = aCell;
//                break;
//            }
//        }
//        
//        // if it doesn't touch a cell resign first responder
//        if (!cell) {
//            return YES;
//        }
//        
//        return NO;
//    }
//    return YES;
    return YES;
}

#pragma mark - UIKeyboardNotifications

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardBounds;
    [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    
    if (!self.keyboardShowing && self.resizeForKeyboard) {
        self.keyboardShowing = YES;
        [self addGestureRecognizer:self.singleTap];
        
        [UIView animateWithDuration:0.3f animations:^{
            UIEdgeInsets contentInset = self.contentInset;
            UIEdgeInsets scrollInset = self.scrollIndicatorInsets;
            
            CGFloat offset = keyboardBounds.size.height - self.offsetFromBottom;
            contentInset.bottom += offset;
            scrollInset.bottom += offset;
            
            self.contentInset = contentInset;
            self.scrollIndicatorInsets = scrollInset;
        } completion:^(BOOL finished) {
            [self scrollRectToVisible:(CGRect){ 0, self.contentSize.height - 1, 1, 1 } animated:YES];
        }];
    } else if (!self.keyboardShowing) {
        // Add the gesture recognizer even if we don't resize
        self.keyboardShowing = YES;
        [self addGestureRecognizer:self.singleTap];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGRect keyboardBounds;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    if (self.keyboardShowing && self.resizeForKeyboard) {
        self.keyboardShowing = NO;
        [self removeGestureRecognizer:self.singleTap];
        
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
        // Remove the gesture recognizer even if we don't resize
        self.keyboardShowing = NO;
        [self removeGestureRecognizer:self.singleTap];
    }
}

@end
