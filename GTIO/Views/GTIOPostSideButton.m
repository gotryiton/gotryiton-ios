//
//  GTIOPostSideButton.m
//  GTIO
//
//  Created by Scott Penrose on 6/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostSideButton.h"

@implementation GTIOPostSideButton

+ (id)gtio_postSideButtonType:(GTIOPostSideButtonType)postSideButton tapHandler:(GTIOButtonDidTapHandler)tapHandler
{
    GTIOPostSideButton *uiButton = [self buttonWithType:UIButtonTypeCustom];
    [uiButton setTitleColor:[UIColor gtio_postReviewCountButtonTextColor] forState:UIControlStateNormal];
    [uiButton.titleLabel setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBook size:12.0f]];
    [uiButton setTitleEdgeInsets:(UIEdgeInsets){ 3.5, 1, 0, 0 }];
    [uiButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"button-%@-inactive.png", GTIOPostSideButtonTypeName[postSideButton]]] forState:UIControlStateNormal];
    [uiButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"button-%@-active.png", GTIOPostSideButtonTypeName[postSideButton]]] forState:UIControlStateHighlighted];
    [uiButton addTarget:uiButton action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [uiButton setTapHandler:tapHandler];
    [uiButton setFrame:(CGRect){ CGPointZero, { 44, 44 } }];
    return uiButton;
}

@end
