//
//  GTIOSinglePostViewController.h
//  GTIO
//
//  Created by Simon Holroyd on 7/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//


#import "GTIOViewController.h"
#import "GTIOPost.h"

@protocol GTIOSinglePostViewDelegate <NSObject>

@required
- (void)postHeaderViewTapWithUserId:(NSString *)userID;

@end

@interface GTIOSinglePostViewController : GTIOViewController

- (id)initWithPostID:(NSString *)postID;
- (id)initWithPost:(GTIOPost *)post;

@end
