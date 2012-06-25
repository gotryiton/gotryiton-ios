//
//  GTIOBadge.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOBadge.h"

@implementation GTIOBadge

@synthesize path = _path;

- (NSURL *)badgeImageURL
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        return [NSString stringWithFormat:@"%@38_38.png", self.path];
    } else {
        return [NSString stringWithFormat:@"%@17_17.png", self.path];
    }
}

@end
