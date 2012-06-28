//
//  GTIOPostAutoCompleteView.m
//  GTIO
//
//  Created by Scott Penrose on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostAutoCompleteView.h"

@implementation GTIOPostAutoCompleteView

@synthesize textViewDidEndHandler = _textViewDidEndHandler, textViewWillBecomeActiveHandler = _textViewWillBecomeActiveHandler, textViewDidBecomeActiveHandler = _textViewDidBecomeActiveHandler;
@synthesize forceBecomeFirstResponder = _forceBecomeFirstResponder;

- (id)initWithFrame:(CGRect)frame outerBox:(CGRect) outerFrame
{
    self = [super initWithFrame:frame outerBox:outerFrame];
    if (self) {
        [self.textInput setDelegate:self];
    }
    return self;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [super textView:textView shouldChangeTextInRange:range replacementText:text];
    
    if([text isEqualToString:@"\n"]) {
        if (self.textViewDidEndHandler) {
            self.textViewDidEndHandler(self, YES);
        } else {
            [self.textInput resignFirstResponder];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.textViewWillBecomeActiveHandler && !self.forceBecomeFirstResponder) {
        [self setForceBecomeFirstResponder:YES];
        self.textViewWillBecomeActiveHandler(self);
        return NO;
    } else {
        [self setForceBecomeFirstResponder:NO];
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.textViewDidBecomeActiveHandler) {
        self.textViewDidBecomeActiveHandler(self);
    }
}

@end
