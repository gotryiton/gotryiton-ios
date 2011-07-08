//
//  GTIOUserIconOptionDataSource.m
//  GTIO
//
//  Created by Daniel Hammond on 5/23/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOUserIconOptionDataSource.h"


@implementation GTIOUserIconOptionDataSource

+ (void)iconOptionRequestWithDelegate:(id)delegate {
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[[GTIOUser currentUser] token], @"gtioToken",nil];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/user-icons") delegate:delegate];
    loader.params = params;
    loader.method = RKRequestMethodPOST;
    [loader send];
}

@end
