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

typedef void(^GTIOProfileInitCompletionHandler)(id sender);

@interface GTIOProfileHeaderView : UIView <GTIOFollowRequestAcceptBarViewDelegate>

@property (nonatomic, strong) GTIOUserProfile *userProfile;
@property (nonatomic, weak) id<GTIOFollowRequestAcceptBarViewDelegate> delegate;

- (void)setUserProfile:(GTIOUserProfile *)userProfile completionHandler:(GTIOProfileInitCompletionHandler)completionHandler;

@end