//
//  GTIOPost.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPost.h"
#import <RestKit/RestKit.h>

@implementation GTIOPost

+ (void)postGTIOPhoto:(GTIOPhoto *)photo description:(NSString *)description facebookShare:(BOOL)facebookShare attachedProducts:(NSDictionary *)attachedProducts completionHandler:(GTIOPostCompletionHandler)completionHandler
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/post/create" usingBlock:^(RKObjectLoader *loader) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                description, @"description",
                                [NSNumber numberWithBool:facebookShare], @"facebook_share",
                                photo.photoID, @"photo_id",
                                nil];
        
        if ([[attachedProducts allKeys] count] > 0) {
            [params setValue:attachedProducts forKey:@"attached_products"];
        }
        
        NSDictionary *postParams = @{ @"post" : params };
        
        loader.params = GTIOJSONParams(postParams);
        loader.method = RKRequestMethodPOST;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {
            // Find post object
            GTIOPost *post = nil;
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOPost class]]) {
                    post = object;
                    break;
                }
            }            
            if (completionHandler) {
                completionHandler(post, nil);
            }
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
}

@end
