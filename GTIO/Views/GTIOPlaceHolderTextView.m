//
//  TTPlaceholderTextView.m
//
//  Created by Joshua Johnson on 1/6/12.
//  Copyright (c) 2012 Two Toasters. All rights reserved.
//

#import "GTIOPlaceHolderTextView.h"

@interface GTIOPlaceHolderTextView ()

@property (nonatomic, assign) BOOL shouldDrawPlaceholder;

- (void)contentDidChange:(NSNotification *)notification;
- (CGRect)proportionalInsetRectFromRect:(CGRect)rect inset:(CGFloat)inset;

@end


@implementation GTIOPlaceHolderTextView

#pragma mark - synth

@synthesize placeholderText = _placeholderText, placeholderColor = _placeholderColor;
@synthesize shouldDrawPlaceholder = _shouldDrawPlaceholder;

#pragma mark - lifecycle

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentDidChange:) name:UITextViewTextDidChangeNotification object:self];
        
        _placeholderColor = [UIColor lightGrayColor];
        _shouldDrawPlaceholder = YES;
        [self setNeedsDisplay];
    }
    return self;
}

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self contentDidChange:nil];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect 
{
    [super drawRect:rect];
    
    if (self.shouldDrawPlaceholder) {
        [self.placeholderColor set];
        [self.placeholderText drawInRect:[self proportionalInsetRectFromRect:rect inset:8.0] withFont:[self font]];
    }
}

#pragma mark - helpers

- (CGRect)proportionalInsetRectFromRect:(CGRect)rect inset:(CGFloat)inset
{
    CGFloat insets = inset * 2;
    return (CGRect){ rect.origin.x + inset, rect.origin.y + inset, rect.size.width - insets, rect.size.height - insets };
}

#pragma mark - notification

- (void)contentDidChange:(NSNotification *)notification
{
    BOOL previousState = self.shouldDrawPlaceholder;
    NSString *emptyCheck = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.shouldDrawPlaceholder = self.placeholderText && self.placeholderColor && [emptyCheck length] == 0;
    if (previousState != self.shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}

@end
