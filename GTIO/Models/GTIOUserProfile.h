//
//  GTIOUserProfile.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOUser.h"
#import "GTIOFollowRequestAcceptBar.h"
#import "GTIOPostList.h"

@interface GTIOUserProfile : NSObject

@property (nonatomic, strong) GTIOUser *user;
@property (nonatomic, strong) NSArray *userInfoButtons;
@property (nonatomic, strong) NSArray *profileCallOuts;
@property (nonatomic, strong) NSArray *settingsButtons;
@property (nonatomic, strong) GTIOFollowRequestAcceptBar *acceptBar;
@property (nonatomic, strong) GTIOPostList *postsList;
@property (nonatomic, strong) GTIOPostList *heartsList;

@end
