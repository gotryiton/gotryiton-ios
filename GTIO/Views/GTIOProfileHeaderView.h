//
//  GTIOProfileHeaderView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOUserProfile.h"

typedef void(^GTIOProfileInitCompletionHandler)(id sender);

@interface GTIOProfileHeaderView : UIView

@property (nonatomic, strong) GTIOUserProfile *userProfile;

- (void)setUserProfile:(GTIOUserProfile *)userProfile completionHandler:(GTIOProfileInitCompletionHandler)completionHandler;

@end