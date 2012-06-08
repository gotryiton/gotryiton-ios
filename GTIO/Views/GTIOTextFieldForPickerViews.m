//
//  GTIOTextFieldForPickerViews.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTextFieldForPickerViews.h"

@interface GTIOTextFieldForPickerViews()

@property (nonatomic, assign) BOOL firstSettingOfTheText;

@end

@implementation GTIOTextFieldForPickerViews

@synthesize usesPicker = _usesPicker, firstSettingOfTheText = _firstSettingOfTheText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.usesPicker = NO;
        self.firstSettingOfTheText = YES;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (self.firstSettingOfTheText && self.usesPicker) {
        [self setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:14.0]];
        [self setTextColor:[UIColor gtio_signInColor]];
    } else {
        [self setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:14.0]];
        [self setTextColor:[UIColor gtio_signInColor]];
    }
    self.firstSettingOfTheText = NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.usesPicker) {
        if (action == @selector(paste:) ||
            action == @selector(cut:) ||
            action == @selector(select:) ||
            action == @selector(selectAll:)) {
            return NO;
        }
    }
    return [super canPerformAction:action withSender:sender];
}


@end
