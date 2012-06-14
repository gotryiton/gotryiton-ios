//
//  GTIOMyManagementScreen.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMyManagementScreen.h"
#import <RestKit/RestKit.h>
#import "GTIOUser.h"

@implementation GTIOMyManagementScreen

@synthesize userInfo = _userInfo, management = _management;

+ (void)loadScreenLayoutDataWithCompletionHandler:(GTIOCompletionHandler)completionHandler
{
    NSString *managementResourcePath = @"/user/management";
    
    BOOL authToken = NO;
    if ([[RKObjectManager sharedManager].client.HTTPHeaders objectForKey:kGTIOAuthenticationHeaderKey]) {
        authToken = YES;
    }
    if (authToken) {
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:managementResourcePath usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *objects) {
                
                for (id object in objects) {
                    if ([object isMemberOfClass:[GTIOUser class]]) {
                        [[GTIOUser currentUser] populateWithUser:(GTIOUser *)object];
                    }
                }
                
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