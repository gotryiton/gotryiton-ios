//
//  GTIOBrowseListTTModel.m
//  GTIO
//
//  Created by Daniel Hammond on 5/24/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOBrowseListTTModel.h"


@implementation GTIOBrowseListTTModel
//GTIOBrowseListTTModel* model = [[[GTIOBrowseListTTModel alloc] initWithResourcePath:_apiEndpoint
//                                                                             params:[GTIOUser paramsByAddingCurrentUserIdentifier:params]
//                                                                             method:RKRequestMethodPOST] autorelease];

- (id)initWithResourcePath:(NSString*)resourcePath params:(NSDictionary*)params method:(RKRequestMethod)method {
//    NSLog(@"resource path:%@ params:%@ method:%@",resourcePath, params, method);
    NSLog(@"%@",resourcePath);
    return [self init];
}

- (BOOL)isOutdated {
    return YES;
}

@end
