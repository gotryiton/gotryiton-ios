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

@interface GTIOFriendsViewController : GTIOViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, GTIOFriendsTableHeaderViewDelegate, GTIOFindMyFriendsTableViewCellDelegate>

- (id)initWithGTIOFriendsTableHeaderViewType:(GTIOFriendsTableHeaderViewType)tableHeaderViewType;

@end
