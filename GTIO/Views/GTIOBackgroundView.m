//
//  GTIOBackgroundView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOBackgroundView.h"

@implementation GTIOBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
        UIImageView *statusBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status-bar-bg.png"]];
        [self addSubview:statusBarBg];
    }
    return self;
}

@end
