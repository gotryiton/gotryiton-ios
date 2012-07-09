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

@interface GTIOPostBrandButtonsView ()

@property (nonatomic, strong) NSMutableArray *uiButtons;

@end

@implementation GTIOPostBrandButtonsView

@synthesize buttons = _buttons;
@synthesize uiButtons = _uiButtons;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _uiButtons = [NSMutableArray array];
    }
    return self;
}

- (void)setButtons:(NSArray *)buttons
{
    // Remove current buttons
    [self.uiButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.uiButtons removeAllObjects];
    
    _buttons = buttons;
    
    CGFloat xOrigin = 0.0f;
    CGFloat yOrigin = 0.0f;
    for (GTIOButton *button in buttons) {
        GTIOBrandButton *brandButton = [GTIOBrandButton gtio_brandButton:button tapHandler:^(id sender) {
            GTIOBrandButton *touchedBrandButton = sender;
            NSLog(@"Brand button touched: %@", touchedBrandButton.buttonModel.text);
            // TODO: Routes to gtio://ShopBrowse/[title (urlencoded)]/[api path (url encoded)]
        }];
        [self.uiButtons addObject:brandButton];
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

#pragma mark - Height

+ (CGFloat)heightWithWidth:(CGFloat)width buttons:(NSArray *)buttons
{
    CGFloat xOrigin = 0.0f;
    CGFloat yOrigin = 0.0f;
    for (GTIOButton *button in buttons) {
        CGSize textSize = [button.text sizeWithFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:13.0] forWidth:200 lineBreakMode:UILineBreakModeTailTruncation];
        CGFloat buttonWidth = textSize.width + 14;
        
        if (width - xOrigin >= buttonWidth) {
            // place button on current row
        } else {
            // button to long for row, place on next row
            xOrigin = 0.0f;
            yOrigin += kGTIOButtonHeight + kGTIORowPadding;
        }
        
        xOrigin += buttonWidth + kGTIOPaddingBetweenButtons;
    }
    
    if ([buttons count] > 0) {
        return yOrigin + kGTIOButtonHeight;
    } else {
        return 0;
    }
}


@end
