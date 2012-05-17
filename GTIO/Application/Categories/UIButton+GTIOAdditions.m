//
//  UIButton+GTIOAdditions.m
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "UIButton+GTIOAdditions.h"

@implementation UIButton (GTIOAdditions)

+ (UIButton *)gtio_signInButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"intro-bar-sign-in-OFF.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"intro-bar-sign-in-ON.png"] forState:UIControlStateHighlighted];
    [button setFrame:(CGRect){ CGPointZero, { 58, 32 } }];
    return button;
}

+ (UIButton *)gtio_nextButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"intro-bar-next-OFF.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"intro-bar-next-ON.png"] forState:UIControlStateHighlighted];
    [button setFrame:(CGRect){ CGPointZero, { 58, 32 } }];
    return button;
}

+ (UIButton *)gtio_facebookButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"fb-sign-up-OFF.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fb-sign-up-ON.png"] forState:UIControlStateHighlighted];
    [button setFrame:(CGRect){ CGPointZero, { 241, 58 } }];
    return button;
}

+ (UIButton *)gtio_returningUserButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"returning-user-OFF.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"returning-user-ON.png"] forState:UIControlStateHighlighted];
    [button setFrame:(CGRect){ CGPointZero, { 241, 58 } }];
    return button;
}

@end
