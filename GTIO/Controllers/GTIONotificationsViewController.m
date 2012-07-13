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
#import "DTCoreText.h"
#import "GTIORouter.h"

static CGFloat const kGTIONotificationTableCellTextWidth = 273.0;
static CGFloat const kGTIONotificationTableCellTopBottomPadding = 16.0;
static CGFloat const kGTIONotificationTableCellTextBottomPaddingOffset = 6.0;

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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    self.tableView = nil;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIONotification *notificationForIndexPath = [self.notifications objectAtIndex:indexPath.row];
    
    [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
    DTAttributedTextView *textAttributedTextView = [[DTAttributedTextView alloc] initWithFrame:(CGRect){ CGPointZero, { kGTIONotificationTableCellTextWidth, 0 } }];
    textAttributedTextView.contentView.edgeInsets = (UIEdgeInsets) { -4, 0, 0, 0 };
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NotificationTableCellText" ofType:@"css"];  
    NSData *cssData = [NSData dataWithContentsOfFile:filePath];
    NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
    DTCSSStylesheet *stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
    
    NSDictionary *descriptionAttributedTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithFloat:0.8], DTDefaultLineHeightMultiplier,
                                                      stylesheet, DTDefaultStyleSheet,
                                                      nil];
    
    NSData *data = [notificationForIndexPath.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:descriptionAttributedTextOptions documentAttributes:NULL];
    textAttributedTextView.attributedString = string;
    
    CGSize textSize = [textAttributedTextView.contentView sizeThatFits:(CGSize){ kGTIONotificationTableCellTextWidth, CGFLOAT_MAX }];
    
    return textSize.height + kGTIONotificationTableCellTopBottomPadding * 2 - kGTIONotificationTableCellTextBottomPaddingOffset;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GTIONotificationsTableViewCell *notificationCellForIndexPath = (GTIONotificationsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    GTIONotification *notificationForIndexPath = [self.notifications objectAtIndex:indexPath.row];
    notificationForIndexPath.viewed = [NSNumber numberWithBool:YES];
    notificationCellForIndexPath.notification = notificationForIndexPath;
    
    UIViewController *viewController = [[GTIORouter sharedRouter] viewControllerForURLString:notificationForIndexPath.action];
    [self.navigationController pushViewController:viewController animated:YES];
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
