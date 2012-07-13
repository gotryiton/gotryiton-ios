//
//  GTIOToolBarButton.m
//  GTIO
//
//  Created by Scott Penrose on 7/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOToolBarButton.h"

static CGFloat kGTIOButtonHeight = 44.0f;
static CGFloat kGTIOButtonWidthPadding = 14.0f;

@implementation GTIOToolBarButton

+ (id)buttonWithToolBarButtonType:(GTIOToolBarButtonType)toolBarButtonType tapHandler:(GTIOButtonDidTapHandler)tapHandler
{
    UIImage *imageName = [UIImage imageNamed:[NSString stringWithFormat:@"webview-button-%@-inactive.png", GTIOToolBarButtonName[toolBarButtonType]]];
    UIImage *selectedImageName = [UIImage imageNamed:[NSString stringWithFormat:@"webview-button-%@-active.png", GTIOToolBarButtonName[toolBarButtonType]]];
    UIImage *disabledImageName = [UIImage imageNamed:[NSString stringWithFormat:@"webview-button-%@-disabled.png", GTIOToolBarButtonName[toolBarButtonType]]];
    
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:imageName forState:UIControlStateNormal];
    [button setImage:selectedImageName forState:UIControlStateHighlighted];
    [button setImage:disabledImageName forState:UIControlStateDisabled];
    [button setFrame:(CGRect){ CGPointZero, { imageName.size.width + kGTIOButtonWidthPadding, kGTIOButtonHeight } }];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setTapHandler:tapHandler];
    
    GTIOToolBarButton *barButton = [[GTIOToolBarButton alloc] initWithCustomView:button];
    return barButton;
}

@end
