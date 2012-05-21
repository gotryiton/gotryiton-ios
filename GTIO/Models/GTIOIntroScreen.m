//
//  GTIOIntroScreen.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

NSString * const kGTIOIntroScreenIDKey = @"GTIOIntroScreenIDKey";
NSString * const kGTIOImageURLKey = @"GTIOImageURLKey";
NSString * const kGTIOTrackKey = @"GTIOTrackKey";

#import "GTIOIntroScreen.h"

@implementation GTIOIntroScreen

@synthesize introScreenID = _introScreenID, imageURL = _imageURL, track = _track;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.introScreenID = [coder decodeObjectForKey:kGTIOIntroScreenIDKey];
        self.imageURL = [coder decodeObjectForKey:kGTIOImageURLKey];
        self.track = [coder decodeObjectForKey:kGTIOTrackKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (self.introScreenID) {
        [coder encodeObject:self.introScreenID forKey:kGTIOIntroScreenIDKey];
    }
    if (self.imageURL) {
        [coder encodeObject:self.imageURL forKey:kGTIOImageURLKey];
    }
    if (self.track) {
        [coder encodeObject:self.track forKey:kGTIOTrackKey];
    }
}

@end
