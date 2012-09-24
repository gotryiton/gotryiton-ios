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
CGFloat const kGTIOIphoneDefaultScreenHeight = 480.0;

#import "GTIOIntroScreen.h"

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
    return [NSString stringWithFormat:@"%@%@", self.introScreenID, [self retinaImageString]];
}

- (NSURL*)deviceSpecificImageURL
    if (self.universalImageURL) {
        NSError *error = NULL;
        NSString *template = [NSString stringWithFormat:@"%@.$1", [self retinaImageString]];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".(png|jpg|jpeg)$" options:NSRegularExpressionCaseInsensitive error:&error];
        NSString *url = [regex stringByReplacingMatchesInString:[self.universalImageURL absoluteString] options:0 range:NSMakeRange(0, [[self.universalImageURL absoluteString] length]) withTemplate:template];
        return [NSURL URLWithString:url];
    }
    return [[NSURL alloc] init];
}

- (NSString*)retinaImageString
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        if([[UIScreen mainScreen] bounds].size.height != kGTIOIphoneDefaultScreenHeight){
            // @2x on iphone 5
            return [NSString stringWithFormat:@"-%ih@2x",(int)[[UIScreen mainScreen] bounds].size.height];
        }
        // @2x on old phone
        return @"@2x";
    } 
    return @"";
}
@end
