//
//  GTIONotificationsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIONotificationsViewController.h"
#import "GTIONotificationManager.h"
#import "GTIONotificationsTableViewCell.h"
#import "GTIOProgressHUD.h"

#import "GTIORouter.h"
#import "GTIOUIImage.h"

@interface GTIONotificationsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *notifications;

@end

@implementation GTIONotificationsViewController

@synthesize tableView = _tableView, notifications = _notifications;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _notifications = [NSMutableArray array];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:(CGRect){ { 0, 0 }, { self.parentViewController.view.bounds.size.width, self.parentViewController.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height } }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[GTIOUIImage imageNamed:@"container.png"]];
    [backgroundView setFrame:(CGRect){ { self.view.frame.size.width/2 - backgroundView.image.size.width/2, 0 }, backgroundView.image.size }];
    [self.view addSubview:backgroundView];
    
    self.tableView = [[UITableView alloc] initWithFrame:UIEdgeInsetsInsetRect(backgroundView.frame, UIEdgeInsetsMake(13, 9, 11, 9)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-shadow.png"]];
    [tableFooterView setFrame:(CGRect){ 0, 0, self.tableView.bounds.size.width, 5 }];
    self.tableView.tableFooterView = tableFooterView;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, -self.tableView.tableFooterView.frame.size.height - 1, 0)];
    [self.tableView.layer setCornerRadius:3.0];
    [self.view addSubview:self.tableView];
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GTIONotificationManager sharedManager] refreshNotificationsWithCompletionHandler:^(NSArray *loadedNotifications, NSError *error) {
        if (!error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            self.notifications = loadedNotifications;
            for (GTIONotification *notification in self.notifications){
                notification.viewed = [NSNumber numberWithBool:YES];
            }
            [[GTIONotificationManager sharedManager] broadcastNotificationCount];
            [self.tableView reloadData];
        } else {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
            // TODO: Handler Error
        }
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;

    [[GTIONotificationManager sharedManager] broadcastNotificationCount];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIONotification *notificationForIndexPath = [self.notifications objectAtIndex:indexPath.row];
    return [GTIONotificationsTableViewCell heightWithNotification:notificationForIndexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GTIONotificationsTableViewCell *notificationCellForIndexPath = (GTIONotificationsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    GTIONotification *notificationForIndexPath = [self.notifications objectAtIndex:indexPath.row];
    notificationForIndexPath.tapped = [NSNumber numberWithBool:YES];
    notificationCellForIndexPath.notification = notificationForIndexPath;
    
    [[GTIONotificationManager sharedManager] save];
    
    UIViewController *viewController = [[GTIORouter sharedRouter] viewControllerForURLString:notificationForIndexPath.action];
    if(viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    
    GTIONotificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[GTIONotificationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIONotification *notificationForCell = [self.notifications objectAtIndex:indexPath.row];
    GTIONotificationsTableViewCell *notificationCell = (GTIONotificationsTableViewCell *)cell;
    
    [notificationCell setNotification:notificationForCell];    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notifications.count;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
