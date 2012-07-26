//
//  GTIOQuickAddViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/8/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOQuickAddViewController.h"
#import "GTIOBackgroundView.h"
#import "GTIOEditProfileViewController.h"
#import "GTIOUser.h"
#import "UIImageView+WebCache.h"
#import "GTIOProgressHUD.h"
#import "GTIOAppDelegate.h"

@interface GTIOQuickAddViewController () <GTIOAccountCreatedDelegate, UITableViewDelegate, UITableViewDataSource, GTIOQuickAddTableCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *followButtonBackground;
@property (nonatomic, strong) UIView *skipThisStepContainer;
@property (nonatomic, strong) UIView *skipThisStepUnderline;
@property (nonatomic, strong) UILabel *skipThisStepLabel;
@property (nonatomic, strong) UIButton *skipThisStepInvisiButton;
@property (nonatomic, strong) GTIOAccountCreatedView *accountCreatedView;
@property (nonatomic, strong) GTIOUIButton *followButton;

@property (nonatomic, strong) NSArray *usersToFollow;
@property (nonatomic, assign) int usersToFollowSelected;

@end

@implementation GTIOQuickAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationController setNavigationBarHidden:YES];
        self.usersToFollowSelected = 0;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:[[GTIOBackgroundView alloc] initWithFrame:(CGRect){ 0, -20, [[UIScreen mainScreen] bounds].size }]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.accountCreatedView = [[GTIOAccountCreatedView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width - 10, 200 }];
    [self.accountCreatedView setHidden:YES];
    [self.accountCreatedView setDelegate:self];
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50 } style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor gtio_groupedTableBorderColor]];
    self.tableView.tableHeaderView = self.accountCreatedView;
    [self.view addSubview:self.tableView];
    
    UIImage *followButtonBackgroundImage = [UIImage imageNamed:@"post-button-bg.png"];
    self.followButtonBackground = [[UIImageView alloc] initWithFrame:(CGRect){ 0, self.view.bounds.size.height - followButtonBackgroundImage.size.height, followButtonBackgroundImage.size }];
    [self.followButtonBackground setImage:followButtonBackgroundImage];
    [self.followButtonBackground setUserInteractionEnabled:YES];
    [self.followButtonBackground setHidden:YES];
    [self.view addSubview:self.followButtonBackground];
    
    self.followButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeFollowButton];
    if (self.usersToFollowSelected > 0) {
        [self.followButton setTitle:[NSString stringWithFormat:@"follow %i %@", self.usersToFollowSelected, (self.usersToFollowSelected == 1) ? @"person" : @"people"] forState:UIControlStateNormal];
    } else {
        [self.followButton setEnabled:NO];
    }
    [self.followButton setFrame:(CGRect){ 8, 13, self.followButton.bounds.size }];
    __block typeof(self) blockSelf = self;
    [self.followButton setTapHandler:^(id sender) {
        [blockSelf followButtonPressed];
    }];
    [self.followButtonBackground addSubview:self.followButton];
    
    self.skipThisStepContainer = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, self.tableView.bounds.size.width, 30 }];
    self.skipThisStepLabel = [[UILabel alloc] initWithFrame:(CGRect){ 0, 3, self.tableView.bounds.size.width, 15 }];
    [self.skipThisStepLabel setBackgroundColor:[UIColor clearColor]];
    [self.skipThisStepLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [self.skipThisStepLabel setText:@"or, skip this step"];
    [self.skipThisStepLabel setTextColor:[UIColor gtio_grayTextColorB3B3B3]];
    [self.skipThisStepLabel setTextAlignment:UITextAlignmentCenter];
    self.skipThisStepUnderline = [[UIView alloc] initWithFrame:(CGRect){ 133.0, self.skipThisStepLabel.bounds.size.height - 3, 70.0, 0.5 }];
    [self.skipThisStepUnderline setAlpha:0.60];
    [self.skipThisStepUnderline setBackgroundColor:[UIColor gtio_grayTextColorB3B3B3]];
    [self.skipThisStepLabel addSubview:self.skipThisStepUnderline];
    self.skipThisStepInvisiButton = [[UIButton alloc] initWithFrame:(CGRect){ 133.0, 0, 70.0, self.skipThisStepLabel.bounds.size.height }];
    [self.skipThisStepInvisiButton addTarget:self action:@selector(skipThisStep) forControlEvents:UIControlEventTouchUpInside];
    [self.skipThisStepLabel setUserInteractionEnabled:YES];
    [self.skipThisStepLabel addSubview:self.skipThisStepInvisiButton];
    [self.skipThisStepContainer addSubview:self.skipThisStepLabel];
    
    MBProgressHUD *progressHUD = [GTIOProgressHUD showHUDAddedTo:self.view animated:YES dimScreen:NO];
    [progressHUD setLabelText:@"creating new account..."];
    [[GTIOUser currentUser] loadQuickAddUsersWithCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            self.usersToFollow = loadedObjects;
            // all users selected by default
            for (GTIOUser *user in self.usersToFollow) {
                user.selected = YES;
                self.usersToFollowSelected++;
            }
            if (self.usersToFollowSelected > 0) {
                [self enableAndLabelFollowButton];
            }
            
            [self.tableView reloadData];
            // Show everything after we have loaded
            [self.accountCreatedView setHidden:NO];
            [self.followButtonBackground setHidden:NO];
            self.tableView.tableFooterView = self.skipThisStepContainer;
        } else {
            // TODO: Handle Error
        }
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
    self.accountCreatedView = nil;
    self.usersToFollow = nil;
    self.followButton = nil;
    self.followButtonBackground = nil;
    self.skipThisStepContainer = nil;
    self.skipThisStepLabel = nil;
    self.skipThisStepInvisiButton = nil;
    self.skipThisStepUnderline = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.accountCreatedView refreshUserData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Custom Delegate Methods

- (void)pushEditProfileViewController
{
    GTIOEditProfileViewController *editProfileViewController = [[GTIOEditProfileViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:editProfileViewController animated:YES];
}

- (void)checkboxStateChanged:(BOOL)checked
{
    (checked) ? self.usersToFollowSelected++ : self.usersToFollowSelected--;
    if (self.usersToFollowSelected > 0) {
        [self enableAndLabelFollowButton];
    } else {
        [self.followButton setEnabled:NO];
    }
}

- (void)enableAndLabelFollowButton
{
    [self.followButton setEnabled:YES];
    [self.followButton setTitle:[NSString stringWithFormat:@"follow %i %@", self.usersToFollowSelected, (self.usersToFollowSelected == 1) ? @"person" : @"people"] forState:UIControlStateNormal];
}

#pragma mark - Button Methods

- (void)followButtonPressed
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *userIDs = [NSMutableArray array];
    for (GTIOUser *user in self.usersToFollow) {
        [userIDs addObject:[NSDictionary dictionaryWithObject:user.userID forKey:@"id"]];
    }
    [[GTIOUser currentUser] followUsers:userIDs fromScreen:@"Quick Add" completionHandler:^(NSArray *loadedObjects, NSError *error) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            [self loadTabBarWithTabSelectedAtIndex:GTIOTabBarTabFeed];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:@"There was an error while communicating with the server. Please try again later." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)skipThisStep
{
    [self loadTabBarWithTabSelectedAtIndex:GTIOTabBarTabLooks];
}

- (void)loadTabBarWithTabSelectedAtIndex:(GTIOTabBarTab)index
{
    [((GTIOAppDelegate *)[UIApplication sharedApplication].delegate) addTabBarToWindow];
    [((GTIOAppDelegate *)[UIApplication sharedApplication].delegate) selectTabAtIndex:index];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIOUser *userForRow = (GTIOUser *)[self.usersToFollow objectAtIndex:(indexPath.section + indexPath.row)];
    userForRow.selected = !userForRow.selected;
    [self checkboxStateChanged:userForRow.selected];
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20.0f;
    }
    return 1.0f;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersToFollow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; 
    
    GTIOQuickAddTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[GTIOQuickAddTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    GTIOUser *userForRow = (GTIOUser *)[self.usersToFollow objectAtIndex:(indexPath.section + indexPath.row)];
    
    [cell setUser:userForRow];
    [cell setDelegate:self];
    
    return cell;
}

@end
