//
//  GTIOPostBrandButtonsView.m
//  GTIO
//
//  Created by Scott Penrose on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostBrandButtonsView.h"

#import "GTIOBrandButton.h"

static CGFloat const kGTIOPaddingBetweenButtons = 8.0f;
static CGFloat const kGTIORowPadding = 8.0f;
static CGFloat const kGTIOButtonHeight = 26.0f;

@implementation GTIOPostBrandButtonsView

@synthesize buttons = _buttons, tapHandler = _tapHandler;

- (id)initWithFrame:(CGRect)frame buttons:(NSArray *)buttons tapHandler:(GTIOBrandButtonTapHandler)tapHandler
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setButtons:(NSArray *)buttons
{
    _buttons = buttons;
    
    CGFloat xOrigin = 0.0f;
    CGFloat yOrigin = 0.0f;
    for (GTIOButton *button in buttons) {
        GTIOBrandButton *brandButton = [GTIOBrandButton gtio_brandButton:button tapHandler:^(id sender) {
            GTIOBrandButton *touchedBrandButton = sender;
            if (self.tapHandler) {
                self.tapHandler(touchedBrandButton.buttonModel);
            }
        }];
        [self addSubview:brandButton];
        
        if (self.frame.size.width - xOrigin >= brandButton.frame.size.width) {
            // place button on current row
            [brandButton setFrame:(CGRect){ { xOrigin, yOrigin }, brandButton.frame.size }];
        } else {
            // button to long for row, place on next row
            xOrigin = 0.0f;
            yOrigin += kGTIOButtonHeight + kGTIORowPadding;
            [brandButton setFrame:(CGRect){ { xOrigin, yOrigin }, brandButton.frame.size }];
        }
        
        xOrigin += brandButton.frame.size.width + kGTIOPaddingBetweenButtons;
    }
    
    if ([_buttons count] > 0) {
        [self setFrame:(CGRect){ self.frame.origin, { self.frame.size.width, yOrigin + kGTIOButtonHeight } }];
    } else {
        [self setFrame:(CGRect){ self.frame.origin, { self.frame.size.width, 0 } }];
    }
}

@end
