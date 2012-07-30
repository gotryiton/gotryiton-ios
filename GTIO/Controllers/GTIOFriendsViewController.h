//
//  GTIOFriendsViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"
#import "GTIOFriendsTableHeaderView.h"
#import "GTIOFindMyFriendsTableViewCell.h"
#import "GTIOMeTableHeaderView.h"
#import "GTIOFriendsSearchEmptyStateViewDelegate.h"
#import "SSPullToLoadMoreView.h"
#import "GTIOPullToLoadMoreContentView.h"

@interface GTIOFriendsViewController : GTIOViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, GTIOFriendsTableHeaderViewDelegate, GTIOFindMyFriendsTableViewCellDelegate, GTIOMeTableHeaderViewDelegate, GTIOFriendsSearchEmptyStateViewDelegate, SSPullToLoadMoreViewDelegate>

@property (nonatomic, copy) NSString *userID;

- (id)initWithGTIOFriendsTableHeaderViewType:(GTIOFriendsTableHeaderViewType)tableHeaderViewType;

@end
