//
//  GTIOConfig.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOConfig.h"

NSString * const kGTIOIntroScreensKey = @"GTIOIntroScreensKey";

@implementation GTIOConfig

@synthesize introScreens = _introScreens;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.introScreens = [coder decodeObjectForKey:kGTIOIntroScreensKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (self.introScreens) {
        [coder encodeObject:self.introScreens forKey:kGTIOIntroScreensKey];
    }
}

@end
