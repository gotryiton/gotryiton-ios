//
//  GTIOReview.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/10/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOUser.h"

@interface GTIOReview : NSObject

@property (nonatomic, copy) NSString *reviewID;
@property (nonatomic, strong) GTIOUser *user;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *createdWhen;
@property (nonatomic, strong) NSArray *buttons;

// local state attributes
@property (nonatomic, assign) BOOL hearted;
@property (nonatomic, assign) BOOL flagged;
@property (nonatomic, assign) int heartCount;

+ (void)postReviewComment:(NSString *)reviewComment forPostID:(NSString *)postID completionHandler:(GTIOCompletionHandler)completionHandler;

@end
