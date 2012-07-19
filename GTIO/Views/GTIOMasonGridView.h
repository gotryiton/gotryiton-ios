//
//  GTIOMasonGridView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOPost.h"
#import "GTIOMasonGridItem.h"
#import "GTIOMasonGridItemWithFrameView.h"

#import "SSPullToRefresh.h"
#import "GTIOPullToRefreshContentView.h"
#import "SSPullToLoadMoreView.h"
#import "GTIOPullToLoadMoreContentView.h"

@class GTIOMasonGridView;

typedef void(^GTIOMasonGridPullToRefreshDidStartLoading)(GTIOMasonGridView *masonGridView, SSPullToRefreshView *pullToRefreshView, BOOL showProgressHUD);
typedef void(^GTIOMasonGridPullToLoadMoreDidStartLoading)(GTIOMasonGridView *masonGridView, SSPullToLoadMoreView *pullToLoadMoreView);

@interface GTIOMasonGridView : UIScrollView <GTIOMasonGridItemDelegate>

@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, copy) GTIOMasonGridItemTapHandler gridItemTapHandler;

@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) SSPullToLoadMoreView *pullToLoadMoreView;

@property (nonatomic, copy) GTIOMasonGridPullToLoadMoreDidStartLoading pullToLoadMoreHandler;
@property (nonatomic, copy) GTIOMasonGridPullToRefreshDidStartLoading pullToRefreshHandler;

- (void)setPosts:(NSArray *)posts postsType:(GTIOPostType)postsType;
- (void)addPost:(GTIOPost *)post postType:(GTIOPostType)postType;
- (void)cancelAllItemDownloads;

- (void)attachPullToRefreshAndPullToLoadMore;
- (void)attachPullToRefresh;
- (void)attachPullToLoadMore;

@end
