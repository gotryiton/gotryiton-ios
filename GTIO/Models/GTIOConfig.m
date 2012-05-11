//
//  GTIOConfig.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOConfig.h"

#import <RestKit/RestKit.h>

@implementation GTIOConfig

@synthesize introScreens = _introScreens;

+ (void)loadConfigUsingBlock:(GTIOConfigHandler)configHandler
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/config" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObject = ^(id object){
            if (configHandler) {
                configHandler(nil, object);
            }
        };
        loader.onDidFailWithError = ^(NSError *error){
            if (configHandler) {
                configHandler(error, nil);
            }
        };
    }];
}

@end
