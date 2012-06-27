//
//  GTIOBrandButton.m
//  GTIO
//
//  Created by Scott Penrose on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOBrandButton.h"

@implementation GTIOBrandButton

@synthesize buttonModel = _buttonModel;

+ (id)gtio_brandButton:(GTIOButton *)buttonModel tapHandler:(GTIOButtonDidTapHandler)tapHandler;
{
    GTIOUIButton *uiButton = [self buttonWithType:UIButtonTypeCustom];
    [uiButton setBackgroundImage:[[UIImage imageNamed:@"button-brand-inactive.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 5.0f, 12.0f, 5.0f, 14.0f }] forState:UIControlStateNormal];
    [uiButton setBackgroundImage:[[UIImage imageNamed:@"button-brand-active.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 5.0f, 12.0f, 5.0f, 14.0f }] forState:UIControlStateHighlighted];
    [uiButton setTitle:buttonModel.text forState:UIControlStateNormal];
    [uiButton setTitleColor:[UIColor gtio_grayTextColor] forState:UIControlStateNormal];
    [uiButton.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11.0]];
    [uiButton addTarget:uiButton action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [uiButton setTapHandler:tapHandler];
    
    CGSize textSize = [buttonModel.text sizeWithFont:uiButton.titleLabel.font forWidth:200 lineBreakMode:UILineBreakModeTailTruncation];
    [uiButton setFrame:(CGRect){ 0, 0, textSize.width + 14, 30 }];
    
    return uiButton;
}

@end
