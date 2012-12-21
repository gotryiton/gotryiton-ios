//
//  GTIOConnectTableViewCell.h
//  GTIO
//
//  Created by Simon Holroyd on 11/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOUser.h"


@protocol GTIOConnectTableViewCellDelegate <NSObject>

@required
- (void)updateDataSourceUser:(GTIOUser *)user withUser:(GTIOUser *)newUser;
- (void)buttonTapped:(GTIOButton *)button;

@end

@interface GTIOConnectTableViewCell : UITableViewCell

@property (nonatomic, strong) GTIOUser *user;
@property (nonatomic, weak) id<GTIOConnectTableViewCellDelegate> delegate;

- (void)setUser:(GTIOUser *)user;


@end
