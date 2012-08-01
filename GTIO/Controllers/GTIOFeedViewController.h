//
//  GTIOFeedViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/15/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"
#import "GTIOPost.h"

@protocol GTIOFeedHeaderViewDelegate <NSObject>

@required
- (void)postHeaderViewTapWithUserId:(NSString *)userID;

@end

@protocol GTIOFeedCellDelegate <NSObject>

@required
- (void)buttonTap:(GTIOButton *)button;

@end



@interface GTIOFeedViewController : GTIOViewController

- (id)initWithPostID:(NSString *)postID;
- (id)initWithPost:(GTIOPost *)post;

@end
