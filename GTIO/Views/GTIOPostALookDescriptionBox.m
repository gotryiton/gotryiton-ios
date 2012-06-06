//
//  GTIOPostALookDescriptionBox.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostALookDescriptionBox.h"
#import "GTIODoneToolBar.h"

@interface GTIOPostALookDescriptionBox()

@property (nonatomic, strong) UIView *placeHolderView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UITextView *nextTextView;

@end

@implementation GTIOPostALookDescriptionBox

@synthesize textView = _textView, placeHolderView = _placeHolderView, backgroundView = _backgroundView, nextTextView = _nextTextView;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title icon:(UIImage *)icon nextTextView:(UITextView *)nextTextView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"description-box.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 4.0, 4.0, 6.0, 4.0 }]];
        [self.backgroundView setFrame:(CGRect){ 0, 0, self.bounds.size }];
        [self addSubview:self.backgroundView];
        
        self.placeHolderView = [[UIView alloc] initWithFrame:(CGRect){ 5, 5, self.backgroundView.bounds.size.width - 10, 30 }];
        [self addSubview:self.placeHolderView];
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        [iconView setFrame:(CGRect){ self.backgroundView.bounds.size.width - iconView.bounds.size.width - 15, 5, iconView.bounds.size }];
        [self.placeHolderView addSubview:iconView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 7, 9, self.placeHolderView.bounds.size.width - iconView.bounds.size.width - 17, 15 }];
        [titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:12.0]];
        [titleLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
        [titleLabel setAlpha:0.5];
        [titleLabel setText:title];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.placeHolderView addSubview:titleLabel];
        
        self.nextTextView = nextTextView;
                
        self.textView = [[UITextView alloc] initWithFrame:(CGRect){ 5, 0, self.backgroundView.bounds.size.width, self.backgroundView.bounds.size.height - 10 }];
        [self.textView setBackgroundColor:[UIColor clearColor]];
        [self.textView setContentInset:(UIEdgeInsets){ 0, -4, 0, 0 }];
        [self.textView setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:12.0]];
        [self.textView setTextColor:[UIColor gtio_darkGrayTextColor]];
        [self.textView setScrollsToTop:NO];
        [self.textView setDelegate:self];
        if (self.nextTextView) {
            [self.textView setReturnKeyType:UIReturnKeyNext];
        } else {
            [self.textView setReturnKeyType:UIReturnKeyDone];
        }
        [self addSubview:self.textView];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"] && self.nextTextView) {
        [self.nextTextView becomeFirstResponder];
        return NO;
    } else if([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.textView setTextColor:[UIColor gtio_reallyDarkGrayTextColor]];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.textView setTextColor:[UIColor gtio_darkGrayTextColor]];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        [self.placeHolderView removeFromSuperview];
    } else {
        [self addSubview:self.placeHolderView];
    }
}

@end
