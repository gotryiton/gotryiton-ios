//
//  GTIONotificationsOverlayViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/20/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIONotificationsOverlayViewController.h"
#import "GTIOUser.h"
#import "GTIONotification.h"

@implementation GTIONotificationsOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(0,0,0,0.5);
    self.tableView.frame = CGRectMake(0,self.view.bounds.size.height - 200, 320, 200);
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        [self.view removeFromSuperview];
    }
}

- (void)createModel {
    NSArray* notifications = [GTIOUser currentUser].notifications;
    NSLog(@"Notifications: %@", notifications);
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:[notifications count]];
    for (GTIONotification* notification in notifications) {
        // TODO: set state based on if we have seen them before.
        // Notifications have an id. figure out how to track this.
        TTTableTextItem* item = [TTTableTextItem itemWithText:notification.text URL:notification.url];
        [items addObject:item];
    }
    self.dataSource = [TTListDataSource dataSourceWithItems:items];
    
}

@end
