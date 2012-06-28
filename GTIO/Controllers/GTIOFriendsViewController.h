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

@interface GTIOFriendsViewController : GTIOViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, GTIOFriendsTableHeaderViewDelegate, GTIOFindMyFriendsTableViewCellDelegate, GTIOMeTableHeaderViewDelegate>

@property (nonatomic, copy) NSString *userID;

- (id)initWithGTIOFriendsTableHeaderViewType:(GTIOFriendsTableHeaderViewType)tableHeaderViewType;

@end
