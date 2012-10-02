//
//  GTIOIntroScreen.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

NSString * const kGTIOIntroScreenIDKey = @"GTIOIntroScreenIDKey";
NSString * const kGTIOImageURLKey = @"GTIOImageURLKey";
NSString * const kGTIOUniversalImageURLKey = @"GTIOUniversalImageURLKey";
NSString * const kGTIOTrackKey = @"GTIOTrackKey";

#import "GTIOIntroScreen.h"
#import "GTIOUIImage.h"

@implementation GTIOIntroScreen


- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.introScreenID = [coder decodeObjectForKey:kGTIOIntroScreenIDKey];
        self.imageURL = [coder decodeObjectForKey:kGTIOImageURLKey];
        self.universalImageURL = [coder decodeObjectForKey:kGTIOUniversalImageURLKey];
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
    if (self.universalImageURL) {
        [coder encodeObject:self.universalImageURL forKey:kGTIOUniversalImageURLKey];
    }
}

- (NSString *)deviceSpecificId
{
    return [NSString stringWithFormat:@"%@%@", self.introScreenID, [GTIOUIImage retinaImageStringForUIImage:NO]];
}

- (NSURL*)deviceSpecificImageURL {
    if (self.universalImageURL) {
        return [GTIOUIImage deviceSpecificURL:self.universalImageURL];
    }
    return [[NSURL alloc] init];
}

@end
