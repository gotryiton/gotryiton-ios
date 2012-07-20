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

@synthesize reviewID = _reviewID, user = _user, text = _text, createdWhen = _createdWhen, buttons = _buttons, hearted = _hearted, flagged = _flagged, heartCount = _heartCount;

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

- (void)setButtons:(NSArray *)buttons
{
    _buttons = buttons;
    
    for (GTIOButton *button in _buttons) {
        if ([button.name isEqualToString:kGTIOReviewAgreeButton]) {
            self.hearted = button.state.boolValue;
            self.heartCount = button.count.intValue;
        }
        if ([button.name isEqualToString:kGTIOReviewFlagButton]) {
            self.flagged = button.state.boolValue;
        }
    }
}

@end
