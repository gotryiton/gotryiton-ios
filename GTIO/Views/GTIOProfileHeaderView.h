//
//  GTIOProfileHeaderView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOUserProfile.h"
#import "GTIOFollowRequestAcceptBarView.h"
#import "GTIOMeTableHeaderView.h"

typedef void(^GTIOProfileInitCompletionHandler)(id sender);
typedef void(^GTIOProfileOpenURLHandler)(NSURL *URL);

@protocol GTIOProfileHeaderViewDelegate <NSObject>

@required
- (void)refreshUserProfileRefreshPostsOnly:(BOOL)refreshPostsOnly;
- (void)bannerTapWithUrl:(NSString *)url;

@end

@interface GTIOProfileHeaderView : UIView <GTIOFollowRequestAcceptBarViewDelegate>

@property (nonatomic, strong) GTIOUserProfile *userProfile;
@property (nonatomic, weak) id<GTIOFollowRequestAcceptBarViewDelegate> acceptBarDelegate;
@property (nonatomic, weak) id<GTIOMeTableHeaderViewDelegate> meTableHeaderViewDelegate;
@property (nonatomic, weak) id<GTIOProfileHeaderViewDelegate> delegate;
@property (nonatomic, copy) GTIOProfileOpenURLHandler profileOpenURLHandler;

- (void)setUserProfile:(GTIOUserProfile *)userProfile completionHandler:(GTIOProfileInitCompletionHandler)completionHandler;

@end