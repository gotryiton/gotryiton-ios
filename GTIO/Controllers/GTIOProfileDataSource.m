//
//  GTIOProfileDataSource.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProfileDataSource.h"

@implementation GTIOProfileDataSource

+ (GTIOProfileDataSource *)sharedDataSource
{
    static GTIOProfileDataSource *sharedDataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[self alloc] init];
    });
    return sharedDataSource;
}

#pragma mark - User Icons

- (void)loadUserIconsWithUserID:(NSString *)userID andCompletionHandler:(GTIOCompletionHandler)completionHandler
{
    NSString *userIconResourcePath = [NSString stringWithFormat:@"/users/%@/icons", userID];
    
    BOOL authToken = NO;
    if ([[RKObjectManager sharedManager].client.HTTPHeaders objectForKey:kGTIOAuthenticationHeaderKey]) {
        authToken = YES;
    }
    if (authToken) {
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:userIconResourcePath usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *objects) {
                if (completionHandler) {
                    completionHandler(objects, nil);
                }
            };
            loader.onDidFailWithError = ^(NSError *error) {
                if (completionHandler) {
                    completionHandler(nil, error);
                }
            };
        }];
    } else {
        NSLog(@"no auth token");
    }
}

@end
