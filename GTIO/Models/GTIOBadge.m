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

// profiles
- (NSURL *)badgeImageURL
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        return [NSString stringWithFormat:@"%@38_38.png", self.path];
    } else {
        return [NSString stringWithFormat:@"%@17_17.png", self.path];
    }
}
- (CGSize)badgeImageSize
{
	return (CGSize){17, 17};
}

// feed view and comment post owner
- (NSURL *)badgeImageURLForPostOwner
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        return [NSString stringWithFormat:@"%@28_28.png", self.path];
    } else {
        return [NSString stringWithFormat:@"%@14_14.png", self.path];
    }
}
- (CGSize)badgeImageSizeForPostOwner
{
	return (CGSize){14, 14};
}

// quick add, find my friends, followers lists, etc
- (NSURL *)badgeImageURLForUserList
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        return [NSString stringWithFormat:@"%@32_32.png", self.path];
    } else {
        return [NSString stringWithFormat:@"%@16_16.png", self.path];
    }
}
- (CGSize)badgeImageSizeForUserList
{
	return (CGSize){16, 16};
}

// comment owners
- (NSURL *)badgeImageURLForCommenter
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        return [NSString stringWithFormat:@"%@20_20.png", self.path];
    } else {
        return [NSString stringWithFormat:@"%@10_10.png", self.path];
    }
}
- (CGSize)badgeImageSizeForCommenter
{
	return (CGSize){10, 10};
}


@end
