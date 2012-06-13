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
@property (nonatomic, strong) GTIOButton *followButton;

@property (nonatomic, strong) NSArray *usersToFollow;
@property (nonatomic, assign) int usersToFollowSelected;

@end

@implementation GTIOQuickAddViewController

@synthesize accountCreatedView = _accountCreatedView, usersToFollow = _usersToFollow, tableView = _tableView, usersToFollowSelected = _usersToFollowSelected, followButton = _followButton, followButtonBackground = _followButtonBackground, skipThisStepContainer = _skipThisStepContainer, skipThisStepLabel = _skipThisStepLabel, skipThisStepUnderline = _skipThisStepUnderline, skipThisStepInvisiButton = _skipThisStepInvisiButton;

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
    [self.accountCreatedView setDelegate:self];
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 52 } style:UITableViewStyleGrouped];
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
    [self.view addSubview:self.followButtonBackground];
    
    self.followButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeFollowButton];
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
    [self.skipThisStepLabel setTextColor:[UIColor gtio_lightGrayTextColor]];
    [self.skipThisStepLabel setTextAlignment:UITextAlignmentCenter];
    self.skipThisStepUnderline = [[UIView alloc] initWithFrame:(CGRect){ 133.0, self.skipThisStepLabel.bounds.size.height - 3, 70.0, 0.5 }];
    [self.skipThisStepUnderline setAlpha:0.60];
    [self.skipThisStepUnderline setBackgroundColor:[UIColor gtio_lightGrayTextColor]];
    [self.skipThisStepLabel addSubview:self.skipThisStepUnderline];
    self.skipThisStepInvisiButton = [[UIButton alloc] initWithFrame:(CGRect){ 133.0, 0, 70.0, self.skipThisStepLabel.bounds.size.height }];
    [self.skipThisStepInvisiButton addTarget:self action:@selector(skipThisStep) forControlEvents:UIControlEventTouchUpInside];
    [self.skipThisStepLabel setUserInteractionEnabled:YES];
    [self.skipThisStepLabel addSubview:self.skipThisStepInvisiButton];
    [self.skipThisStepContainer addSubview:self.skipThisStepLabel];
    self.tableView.tableFooterView = self.skipThisStepContainer;
    
    [[GTIOUser currentUser] loadQuickAddUsersWithCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
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

#pragma mark - Custom Delegate Methods

- (void)pushEditProfileViewController
{
    GTIOEditProfileViewController *editProfileViewController = [[GTIOEditProfileViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:editProfileViewController animated:YES];
}

- (void)checkboxStateChanged:(GTIOButton *)checkbox
{
    (checkbox.selected) ? self.usersToFollowSelected++ : self.usersToFollowSelected--;
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
            [((GTIOAppDelegate *)[UIApplication sharedApplication].delegate) addTabBarToWindow];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:@"There was an error while communicating with the server. Please try again later." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)skipThisStep
{
    // Go to 9.1
    NSLog(@"skipping...");
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
