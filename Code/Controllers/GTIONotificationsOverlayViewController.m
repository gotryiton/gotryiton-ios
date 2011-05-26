//
//  GTIONotificationsOverlayViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIONotificationsOverlayViewController.h"
#import "GTIOUser.h"
#import "GTIONotification.h"

@interface GTIOWelcomeDataSource : TTListDataSource
@end

@implementation GTIOWelcomeDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTTableTextItem* object = (TTTableTextItem*)[self tableView:tableView objectForRowAtIndexPath:indexPath];
    GTIONotification* note = object.userInfo;
    [[GTIOUser currentUser] markNotificationAsSeen:note];
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end

@implementation GTIONotificationsOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(0,0,0,0.5);
    int height = 75; //200
    self.tableView.frame = CGRectMake(0,self.view.bounds.size.height - height, 320, height);
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        [UIView beginAnimations:nil context:nil];
        self.view.frame = CGRectOffset(self.view.frame, 0, 480);
        [UIView commitAnimations];
        [self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.6];
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
        item.userInfo = notification;
        if (![[GTIOUser currentUser] hasSeenNotification:notification]) {
            item.text = [NSString stringWithFormat:@"*%@*", notification.text];
        }
        [items addObject:item];
    }
    self.dataSource = [GTIOWelcomeDataSource dataSourceWithItems:items];
    
}

@end
