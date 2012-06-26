//
//  GTIOLargeButton.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOLargeButton.h"

@implementation GTIOLargeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)largeButtonWithGTIOStyle:(GTIOLargeButtonStyle)largeButtonStyle
{
    GTIOLargeButton *button = [GTIOLargeButton buttonWithType:UIButtonTypeCustom];
    
    NSString *backgroundImageNormal;
    NSString *backgroundImageHighlighted;
    switch (largeButtonStyle) {
        case GTIOLargeButtonStyleGray:
            backgroundImageNormal = @"large.button.grey.off.png";
            backgroundImageHighlighted = @"large.button.grey.on.png";
            break;
        case GTIOLargeButtonStyleGreen:
            backgroundImageNormal = @"large.button.green.off.png";
            backgroundImageHighlighted = @"large.button.green.on.png";
            break;
        case GTIOLargeButtonStyleRed:
            backgroundImageNormal = @"large.button.red.off.png";
            backgroundImageHighlighted = @"large.button.red.on.png";
            break;
        default:
            backgroundImageNormal = @"large.button.grey.off.png";
            backgroundImageHighlighted = @"large.button.grey.on.png";
            break;
    }
    
    [button setBackgroundImage:[[UIImage imageNamed:backgroundImageNormal] stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:backgroundImageHighlighted] stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor gtio_ActionSheetButtonTextColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:14.0]];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_largeCancelButton
{
    GTIOLargeButton *button = [self largeButtonWithGTIOStyle:GTIOLargeButtonStyleGray];
    [button setTitleColor:[UIColor gtio_signInColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:14.0]];
    [button setTitle:@"cancel" forState:UIControlStateNormal];
    return button;
}

@end