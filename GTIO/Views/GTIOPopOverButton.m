//
//  GTIOPopOverButton.m
//  GTIO
//
//  Created by Scott Penrose on 6/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPopOverButton.h"

@implementation GTIOPopOverButton

@synthesize buttonModel = _buttonModel;

+ (id)gtio_popOverButtonWithButtonType:(GTIOPopOverButtonType)buttonType position:(GTIOPopOverButtonPosition)position 
{
    GTIOPopOverButton *uiButton = [self buttonWithType:UIButtonTypeCustom];
    [uiButton setTitleColor:[UIColor gtio_grayTextColor8F8F8F] forState:UIControlStateNormal];
    [uiButton.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0f]];

    UIEdgeInsets titleEdgeInsets;
    switch (position) {
        case GTIOPopOverButtonPositionTop:
            titleEdgeInsets = (buttonType==GTIOPopOverButtonTypeDot) ? (UIEdgeInsets){ 8, 0, 0, 0 } : (UIEdgeInsets){ 5, 0, 0, 0 };
            break;
        case GTIOPopOverButtonPositionMiddle:
            titleEdgeInsets = (UIEdgeInsets){ 0, 0, 0, 0 };
            break;
        case GTIOPopOverButtonPositionBottom:
            titleEdgeInsets = (buttonType==GTIOPopOverButtonTypeDot) ? (UIEdgeInsets){ 0, 0, 8, 0 } : (UIEdgeInsets){ 0, 0, 8, 0 };
            break;
        default:
            titleEdgeInsets = UIEdgeInsetsZero;
            break;
    }
    [uiButton setTitleEdgeInsets:titleEdgeInsets];
    
    [uiButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-%@-inactive.png", GTIOPopOverButtonTypeImagePrefix[buttonType], GTIOPopOverButtonPositionButtonName[position]]] forState:UIControlStateNormal];
    [uiButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-%@-active.png", GTIOPopOverButtonTypeImagePrefix[buttonType], GTIOPopOverButtonPositionButtonName[position]]] forState:UIControlStateHighlighted];
    [uiButton addTarget:uiButton action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [uiButton setFrame:(CGRect){ CGPointZero, [uiButton backgroundImageForState:UIControlStateNormal].size }];

    return uiButton;
}

- (void)setButtonModel:(GTIOButton *)buttonModel
{
    _buttonModel = buttonModel;
    
    if ([_buttonModel.text length] > 0) {
        [self setTitle:_buttonModel.text forState:UIControlStateNormal];
    }
}

@end
