//
//  GTIOFindMyFriendsTableViewCell.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOUser.h"

@protocol GTIOFindMyFriendsTableViewCellDelegate <NSObject>

@required
- (void)updateDataSourceUser:(GTIOUser *)user withUser:(GTIOUser *)newUser;

@end

@interface GTIOFindMyFriendsTableViewCell : UITableViewCell

@property (nonatomic, strong) GTIOUser *user;
@property (nonatomic, weak) id<GTIOFindMyFriendsTableViewCellDelegate> delegate;

- (void)setUser:(GTIOUser *)user;

@end
