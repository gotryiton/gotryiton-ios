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
@property (nonatomic, strong) GTIODoneToolBar *accessoryToolBar;

@end

@implementation GTIOPostALookDescriptionBox

@synthesize textView = _textView, placeHolderView = _placeHolderView, backgroundView = _backgroundView, nextTextView = _nextTextView, accessoryToolBar = _accessoryToolBar;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andIcon:(UIImage *)icon andNextTextView:(UITextView *)nextTextView
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
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 5, 5, self.placeHolderView.bounds.size.width - iconView.bounds.size.width - 15, 15 }];
        [titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:10.0]];
        [titleLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
        [titleLabel setAlpha:0.5];
        [titleLabel setText:title];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.placeHolderView addSubview:titleLabel];
        
        self.nextTextView = nextTextView;
        self.accessoryToolBar = [[GTIODoneToolBar alloc] initWithTarget:self andAction:@selector(accessoryButtonTapped:)];
                
        self.textView = [[UITextView alloc] initWithFrame:(CGRect){ 5, 0, self.backgroundView.bounds.size.width - 10, self.backgroundView.bounds.size.height - 10 }];
        [self.textView setBackgroundColor:[UIColor clearColor]];
        [self.textView setContentInset:(UIEdgeInsets){ 0, -4, 0, 0 }];
        [self.textView setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
        [self.textView setTextColor:[UIColor gtio_darkGrayTextColor]];
        [self.textView setDelegate:self];
        if (self.nextTextView) {
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(accessoryButtonTapped:)];
            [self.accessoryToolBar setItems:[NSArray arrayWithObjects:flexibleSpace, nextButton, nil]];
        }
        [self.textView setInputAccessoryView:self.accessoryToolBar];
        [self addSubview:self.textView];
    }
    return self;
}

- (void)accessoryButtonTapped:(id)sender
{
    if (self.nextTextView) {
        [self.nextTextView becomeFirstResponder];
    } else {
        [self.textView resignFirstResponder];
    }
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
