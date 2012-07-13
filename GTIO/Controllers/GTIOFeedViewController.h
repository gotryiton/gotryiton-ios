//
//  GTIOFeedViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/15/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"
#import "SSPullToRefresh.h"
#import "GTIOPost.h"

@interface GTIOFeedViewController : GTIOViewController <SSPullToRefreshViewDelegate>

- (id)initWithPostID:(NSString *)postID;

@end
