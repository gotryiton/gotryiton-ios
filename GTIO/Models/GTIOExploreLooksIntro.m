//
//  GTIOExploreLooksIntro.m
//  GTIO
//
//  Created by Simon Holroyd on 10/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOExploreLooksIntro.h"

NSString * const kGTIOPostInteractionTypeKey = @"GTIOPostInteractionTypeKey";
NSString * const kGTIOSignUpButtonImageURLKey = @"GTIOSignUpButtonImageURLKey";
NSString * const kGTIOSignUpButtonTypeKey = @"GTIOSignUpButtonTypeKey";
NSString * const kGTIOIntroOverlayImageURLKey = @"GTIOIntroOverlayImageURLKey";
NSString * const kGTIOIntroOverlayTypeKey = @"GTIOIntroOverlayTypeKey";

@implementation GTIOExploreLooksIntro


- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.postInteractionType = [coder decodeObjectForKey:kGTIOPostInteractionTypeKey];
        self.signUpButtonImageURL = [coder decodeObjectForKey:kGTIOSignUpButtonImageURLKey];
        self.signUpButtonType = [coder decodeObjectForKey:kGTIOSignUpButtonTypeKey];
        self.introOverlayImageURL = [coder decodeObjectForKey:kGTIOIntroOverlayImageURLKey];
        self.introOverlayType = [coder decodeObjectForKey:kGTIOIntroOverlayTypeKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (self.postInteractionType) {
        [coder encodeObject:self.postInteractionType forKey:kGTIOPostInteractionTypeKey];
    }
    if (self.signUpButtonImageURL) {
        [coder encodeObject:self.signUpButtonImageURL forKey:kGTIOSignUpButtonImageURLKey];
    }
    if (self.signUpButtonType) {
        [coder encodeObject:self.signUpButtonType forKey:kGTIOSignUpButtonTypeKey];
    }
    if (self.introOverlayImageURL) {
        [coder encodeObject:self.introOverlayImageURL forKey:kGTIOIntroOverlayImageURLKey];
    }
    if (self.introOverlayType) {
        [coder encodeObject:self.introOverlayType forKey:kGTIOIntroOverlayTypeKey];
    }
}


@end
