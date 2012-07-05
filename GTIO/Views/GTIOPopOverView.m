//
//  GTIOPopOverView.m
//  GTIO
//
//  Created by Scott Penrose on 6/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPopOverView.h"

#import "GTIOButton.h"
#import "GTIOPopOverButton.h"

static CGFloat const kGTIOButtonWidth = 164.0f;

@implementation GTIOPopOverView

@synthesize buttonModels = _buttonModels;

- (id)initWithButtonModels:(NSArray *)buttonModels
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _buttonModels = buttonModels;
        
        __block CGFloat yOrigin = 0.0f;
        [_buttonModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GTIOPopOverButton *button = nil;
            if (idx == 0) { // Top
                button = [GTIOPopOverButton gtio_popOverButtonWithPosition:GTIOPopOverButtonPositionTop];
            } else if (idx == [_buttonModels count] - 1) { // bottom
                button = [GTIOPopOverButton gtio_popOverButtonWithPosition:GTIOPopOverButtonPositionBottom];
            } else { // Middle
                button = [GTIOPopOverButton gtio_popOverButtonWithPosition:GTIOPopOverButtonPositionMiddle];
            }
            [button setButtonModel:obj];
            [button setTapHandler:^(id sender) {
                // TODO: handle button tap
            }];
            [button setFrame:(CGRect){ { 0, yOrigin }, button.frame.size }];
            [self addSubview:button];
            yOrigin += button.frame.size.height;
        }];
        
        [self setFrame:(CGRect){ CGPointZero, { kGTIOButtonWidth, yOrigin } }];
    }
    return self;
}

@end
