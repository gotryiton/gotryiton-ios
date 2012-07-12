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

static CGFloat const kGTIONotificationTableCellTextWidth = 273.0;
static CGFloat const kGTIONotificationTableCellTopBottomPadding = 16.0;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"notifications" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *closeButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeCloseButtonForNavBar tapHandler:^(id sender) {
        [self dismissModalViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = closeButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GTIONotificationManager sharedManager] refreshNotificationsWithCompletionHandler:^(NSArray *loadedNotifications, NSError *error) {
        if (!error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            self.notifications = loadedNotifications;
            [self.tableView reloadData];
        } else {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIONotification *notificationForIndexPath = [self.notifications objectAtIndex:indexPath.row];
    CGSize notificationTextSize = [notificationForIndexPath.text sizeWithFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:16.0] constrainedToSize:(CGSize){ kGTIONotificationTableCellTextWidth, 1000 } lineBreakMode:UILineBreakModeWordWrap];
    return notificationTextSize.height + kGTIONotificationTableCellTopBottomPadding * 2;
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
