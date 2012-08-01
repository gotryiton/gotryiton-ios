//
//  GTIOWhoHeartedThisViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"
#import "GTIOFindMyFriendsTableViewCell.h"
#import "SSPullToLoadMoreView.h"
#import "GTIOPullToLoadMoreContentView.h"

typedef enum GTIOWhoHeartedThisViewControllerType {
    GTIOWhoHeartedThisViewControllerTypeProduct = 0,
    GTIOWhoHeartedThisViewControllerTypePost
} GTIOWhoHeartedThisViewControllerType;

@interface GTIOWhoHeartedThisViewController : GTIOViewController <UITableViewDelegate, UITableViewDataSource, GTIOFindMyFriendsTableViewCellDelegate, SSPullToLoadMoreViewDelegate>

@property (nonatomic, strong) NSNumber *itemID;

- (id)initWithGTIOWhoHeartedThisViewControllerType:(GTIOWhoHeartedThisViewControllerType)controllerType;

@end
