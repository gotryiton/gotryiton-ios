//
//  GTIOInternalURLHelper.m
//  GTIO
//
//  Created by Jeremy Ellison on 11/17/11.
//  Copyright (c) 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOInternalURLHelper.h"
#import "GTIOUser.h"

@implementation GTIOInternalURLHelper

- (void)showMyLooks {
    if ([[GTIOUser currentUser] isLoggedIn]) {
        TTOpenURL([NSString stringWithFormat:@"gtio://browse/.rest.v3.profile.%@.looks", [[GTIOUser currentUser] UID]]);
    } else {
        TTOpenURL(@"gtio://login");
    }
}

- (void)showMyReviews {
    if ([[GTIOUser currentUser] isLoggedIn]) {
        TTOpenURL([NSString stringWithFormat:@"gtio://browse//.rest.v3.profile.%@.reviews", [[GTIOUser currentUser] UID]]);
    } else {
        TTOpenURL(@"gtio://login");
    }
}

@end
