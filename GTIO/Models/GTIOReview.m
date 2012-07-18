//
//  GTIOReview.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/10/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOReview.h"
#import <RestKit/RestKit.h>

@implementation GTIOReview

@synthesize reviewID = _reviewID, user = _user, text = _text, createdWhen = _createdWhen, buttons = _buttons;

+ (void)postReviewComment:(NSString *)reviewComment forPostID:(NSString *)postID completionHandler:(GTIOCompletionHandler)completionHandler
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/review/create" usingBlock:^(RKObjectLoader *loader) {
        NSDictionary *params = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithKeysAndObjects:
                                                                   @"post_id", postID,
                                                                   @"text", reviewComment,
                                                                   nil] 
                                                           forKey:@"review"];
        loader.params = GTIOJSONParams(params);
        loader.method = RKRequestMethodPOST;
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            if (completionHandler) {
                completionHandler(loadedObjects, nil);
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
