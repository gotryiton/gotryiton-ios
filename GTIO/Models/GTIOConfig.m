//
//  GTIOConfig.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOConfig.h"

NSString * const kGTIOIntroScreensKey = @"GTIOIntroScreensKey";
NSString * const kGTIOFacebookPermissions = @"GTIOFacebookPermissions";
NSString * const kGTIOFacebookShareDefaultOn = @"GTIOFacebookShareDefaultOn";
NSString * const kGTIOVotingDefaultOn = @"GTIOVotingDefaultOn";

@implementation GTIOConfig

@synthesize introScreens = _introScreens;
@synthesize facebookPermissions = _facebookPermissions;
@synthesize facebookShareDefaultOn = _facebookShareDefaultOn, votingDefaultOn = _votingDefaultOn;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.introScreens = [coder decodeObjectForKey:kGTIOIntroScreensKey];
        self.facebookPermissions = [coder decodeObjectForKey:kGTIOFacebookPermissions];
        self.facebookShareDefaultOn = [coder decodeObjectForKey:kGTIOFacebookShareDefaultOn];
        self.votingDefaultOn = [coder decodeObjectForKey:kGTIOVotingDefaultOn];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (self.introScreens) {
        [coder encodeObject:self.introScreens forKey:kGTIOIntroScreensKey];
    }
    if (self.facebookPermissions) {
        [coder encodeObject:self.facebookPermissions forKey:kGTIOFacebookPermissions];
    }
    if (self.facebookShareDefaultOn) {
        [coder encodeObject:self.facebookShareDefaultOn forKey:kGTIOFacebookShareDefaultOn];
    }
    if (self.votingDefaultOn) {
        [coder encodeObject:self.votingDefaultOn forKey:kGTIOVotingDefaultOn];
    }
}

@end
