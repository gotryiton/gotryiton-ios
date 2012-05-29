//
//  GTIOPhotoSelectBoxButton.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoSelectBoxButton.h"

@implementation GTIOPhotoSelectBoxButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"frame-camera-icon-OFF.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"frame-camera-icon-ON.png"] forState:UIControlStateHighlighted];
        [self setContentMode:UIViewContentModeCenter];
    }
    return self;
}

@end
