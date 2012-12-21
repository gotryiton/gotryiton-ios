//
//  GTIOConnectViewController.h
//  GTIO
//
//  Created by Simon Holroyd on 11/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"
#import "SSPullToRefreshView.h"
#import "SSPullToLoadMoreView.h"
#import "GTIOConnectTableViewCell.h"

@interface GTIOConnectViewController : GTIOViewController <UITableViewDelegate, UITableViewDataSource, GTIOConnectTableViewCellDelegate, SSPullToLoadMoreViewDelegate, SSPullToRefreshViewDelegate>

@end
