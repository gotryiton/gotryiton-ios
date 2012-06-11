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

@synthesize postID = _postID, user = _user;

+ (void)postGTIOPhoto:(GTIOPhoto *)photo description:(NSString *)description votingEnabled:(BOOL)votingEnabled completionHandler:(GTIOPostCompletionHandler)completionHandler
{
    NSString *postPhotoResourcePath = @"/post/create";
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:postPhotoResourcePath usingBlock:^(RKObjectLoader *loader) {
        NSDictionary *params = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                description, @"description",
                                [NSNumber numberWithBool:votingEnabled], @"voting_enabled",
                                photo.photoID, @"photo_id",
                                nil] forKey:@"post"];
        
        loader.params = GTIOJSONParams(params);
        loader.method = RKRequestMethodPOST;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {
            // Find user object
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