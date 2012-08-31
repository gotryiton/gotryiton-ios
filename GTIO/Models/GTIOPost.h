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
#import "GTIOGridItem.h"

typedef enum GTIOPostType {
    GTIOPostTypeNone = 0,
    GTIOPostTypeHeart,
    GTIOPostTypeStar,
    GTIOPostTypeHeartedProducts
} GTIOPostType;

@interface GTIOPost : NSObject <GTIOGridItem>

// Fields
@property (nonatomic, copy) NSString *postID;
@property (nonatomic, strong) NSString *postDescription;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, copy) NSString *createdWhen;
@property (nonatomic, strong) NSString *whoHearted;

// Relationships
@property (nonatomic, strong) GTIOButtonAction *action;
@property (nonatomic, strong) GTIOUser *user;
@property (nonatomic, strong) GTIOPhoto *photo;
@property (nonatomic, strong) NSArray *dotOptionsButtons;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSArray *brandsButtons;
@property (nonatomic, strong) GTIOPagination *pagination;
@property (nonatomic, copy) GTIOButtonDidTapHandler reviewsButtonTapHandler;
@property (nonatomic, copy) GTIOButtonDidTapHandler shopTheLookButtonTapHandler;

typedef void(^GTIOPostCompletionHandler)(GTIOPost *post, NSError *error);

+ (void)postGTIOPhoto:(GTIOPhoto *)photo description:(NSString *)description facebookShare:(BOOL)facebookShare attachedProducts:(NSDictionary *)attachedProducts completionHandler:(GTIOPostCompletionHandler)completionHandler;

@end