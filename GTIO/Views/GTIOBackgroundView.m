//
//  GTIOBackgroundView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOBackgroundView.h"

@implementation GTIOBackgroundView

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setFrame:(CGRect){ 0, -20, 320, 480 }];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
        UIImageView *statusBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status-bar-bg.png"]];
        [self addSubview:statusBarBg];
    }
    return self;
}

@end
