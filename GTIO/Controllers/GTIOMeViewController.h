//
//  GTIOMeViewController.h
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOViewController.h"
#import "GTIOMeTableViewCell.h"
#import "GTIONotificationViewDisplayProtocol.h"

@protocol GTIOMeTableHeaderViewDelegate <NSObject>

@required
- (void)pushViewController:(UIViewController *)viewController;

@end

@interface GTIOMeViewController : GTIOViewController <UITableViewDelegate, UITableViewDataSource, GTIOMeTableHeaderViewDelegate, GTIOMeTableViewCellToggleDelegate, UIAlertViewDelegate, GTIONotificationViewDisplayProtocol>

@end
