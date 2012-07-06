//
//  GTIOMyPostsViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"
#import "SSPullToRefresh.h"
#import "GTIOPost.h"

@interface GTIOMyPostsViewController : GTIOViewController <SSPullToRefreshViewDelegate>

- (id)initWithGTIOPostType:(GTIOPostType)postsType forUserID:(NSString *)userID;

@end