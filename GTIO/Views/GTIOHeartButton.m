//
//  GTIOHeartButton.m
//  GTIO
//
//  Created by Scott Penrose on 6/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOHeartButton.h"

@implementation GTIOHeartButton

@synthesize hearted = _hearted;

+ (id)heartButtonWithTapHandler:(GTIOButtonDidTapHandler)tapHandler
{    
    id button = [self buttonWithType:UIButtonTypeCustom];
    [button setHearted:NO];
    [button setFrame:(CGRect){ CGPointZero, { 34,34 } }];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setTapHandler:tapHandler];
    return button;
}

- (void)setHearted:(BOOL)hearted
{
    _hearted = hearted;
    
    [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"heart-toggle-%@-inactive.png", _hearted ? @"on" : @"off"]] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"heart-toggle-%@-active.png", _hearted ? @"on" : @"off"]] forState:UIControlStateHighlighted];
}

@end
