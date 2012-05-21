//
//  GTIOAuth.m
//  GTIO
//
//  Created by Scott Penrose on 5/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAuth.h"

#import <RestKit/RestKit.h>

NSString * const kGTIOAuthTokenKey = @"GTIOAuthTokenKey";

@implementation GTIOAuth

@synthesize token = _token;

- (void)setToken:(NSString *)token
{
    _token = token;
    if ([_token length] > 0) {
        [[RKObjectManager sharedManager].client.HTTPHeaders setObject:_token forKey:kGTIOAuthenticationHeaderKey];
        [[NSUserDefaults standardUserDefaults] setObject:_token forKey:kGTIOAuthTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[RKObjectManager sharedManager].client.HTTPHeaders removeObjectForKey:kGTIOAuthTokenKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGTIOAuthTokenKey];
    }
}

- (NSString *)token
{
    if (![_token length] > 0) {
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:kGTIOAuthTokenKey];
    }
    return _token;
}

@end
