//
//  GTIOTextFieldForPickerViews.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTextFieldForPickerViews.h"

@implementation GTIOTextFieldForPickerViews

@synthesize usesPicker = _usesPicker;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.usesPicker = NO;
    }
    return self;
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
