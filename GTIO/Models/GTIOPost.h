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
#import "GTIOPagination.h"

typedef enum GTIOPostType {
    GTIOPostTypeNone = 0,
    GTIOPostTypeHeart,
    GTIOPostTypeStar
} GTIOPostType;

@interface GTIOPost : NSObject

// Fields
@property (nonatomic, copy) NSString *postID;
@property (nonatomic, strong) NSString *postDescription;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, copy) NSString *createdWhen;
@property (nonatomic, assign, getter = isStared) BOOL stared;
@property (nonatomic, strong) NSString *whoHearted;

// Relationships
@property (nonatomic, strong) GTIOUser *user;
@property (nonatomic, strong) GTIOPhoto *photo;
@property (nonatomic, strong) NSArray *dotOptionsButtons;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSArray *brandsButtons;
@property (nonatomic, strong) GTIOPagination *pagination;

typedef void(^GTIOPostCompletionHandler)(GTIOPost *post, NSError *error);

+ (void)postGTIOPhoto:(GTIOPhoto *)photo description:(NSString *)description votingEnabled:(BOOL)votingEnabled completionHandler:(GTIOPostCompletionHandler)completionHandler;

@end