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

+ (id)gtio_brandButton:(GTIOButton *)buttonModel tapHandler:(GTIOButtonDidTapHandler)tapHandler
{
    GTIOBrandButton *uiButton = [self buttonWithType:UIButtonTypeCustom];
    [uiButton setButtonModel:buttonModel];
    [uiButton setBackgroundImage:[[UIImage imageNamed:@"button-brand-inactive.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 5.0f, 12.0f, 5.0f, 14.0f }] forState:UIControlStateNormal];
    [uiButton setBackgroundImage:[[UIImage imageNamed:@"button-brand-active.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 5.0f, 12.0f, 5.0f, 14.0f }] forState:UIControlStateHighlighted];
    [uiButton setTitle:buttonModel.text forState:UIControlStateNormal];
    [uiButton setTitleColor:[UIColor gtio_grayTextColor585858] forState:UIControlStateNormal];
    [uiButton.titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:13.0]];
    [uiButton setTitleEdgeInsets:(UIEdgeInsets){ 3, 0, 0, 0 }];
    [uiButton addTarget:uiButton action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [uiButton setTapHandler:tapHandler];
    
    CGSize textSize = [buttonModel.text sizeWithFont:uiButton.titleLabel.font forWidth:200 lineBreakMode:UILineBreakModeTailTruncation];
    [uiButton setFrame:(CGRect){ 0, 0, textSize.width + 14, 26 }];
    
    return uiButton;
}

@end
