//
//  GTIOPost.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOUser.h"
#import "GTIOPhoto.h"

@interface GTIOPost : NSObject

@property (nonatomic, copy) NSString *postID;
@property (nonatomic, strong) GTIOUser *user;

typedef void(^GTIOPostCompletionHandler)(GTIOPost *post, NSError *error);

+ (void)postGTIOPhoto:(GTIOPhoto *)photo description:(NSString *)description votingEnabled:(BOOL)votingEnabled completionHandler:(GTIOPostCompletionHandler)completionHandler;

@end