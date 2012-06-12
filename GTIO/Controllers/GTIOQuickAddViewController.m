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

@interface GTIOQuickAddViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GTIOAccountCreatedView *accountCreatedView;
@property (nonatomic, strong) NSArray *usersToFollow;
@property (nonatomic, assign) int usersToFollowSelected;
@property (nonatomic, strong) GTIOButton *followButton;

@end

@implementation GTIOQuickAddViewController

@synthesize accountCreatedView = _accountCreatedView, usersToFollow = _usersToFollow, tableView = _tableView, usersToFollowSelected = _usersToFollowSelected, followButton = _followButton;

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
    [self.view addSubview:[[GTIOBackgroundView alloc] init]];
    
    [[GTIOUser currentUser] loadQuickAddUsersWithCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
        if (!error) {
            self.usersToFollow = loadedObjects;
            self.usersToFollowSelected = [self.usersToFollow count];
            // all users selected by default
            for (GTIOUser *user in self.usersToFollow) {
                user.selected = YES;
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.accountCreatedView = [[GTIOAccountCreatedView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width - 10, 200 }];
    [self.accountCreatedView setDelegate:self];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor gtio_groupedTableBorderColor]];
    self.tableView.tableHeaderView = self.accountCreatedView;
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.view addSubview:self.tableView];
    
    UIImage *followButtonBackgroundImage = [UIImage imageNamed:@"post-button-bg.png"];
    UIImageView *followButtonBackground = [[UIImageView alloc] initWithFrame:(CGRect){ 0, self.view.bounds.size.height - followButtonBackgroundImage.size.height, followButtonBackgroundImage.size }];
    [followButtonBackground setImage:followButtonBackgroundImage];
    [followButtonBackground setUserInteractionEnabled:YES];
    [self.view addSubview:followButtonBackground];
    
    self.followButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeFollowButton];
    if (self.usersToFollowSelected > 0) {
        [self.followButton setTitle:[NSString stringWithFormat:@"follow %i %@", self.usersToFollowSelected, (self.usersToFollowSelected == 1) ? @"person" : @"people"] forState:UIControlStateNormal];
    } else {
        [self.followButton setEnabled:NO];
    }
    [self.followButton setFrame:(CGRect){ 8, 13, self.followButton.bounds.size }];
    [followButtonBackground addSubview:self.followButton];
    
    UIView *skipThisStepContainer = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, self.tableView.bounds.size.width, 85 }];
    UILabel *skipThisStep = [[UILabel alloc] initWithFrame:(CGRect){ 0, 3, self.tableView.bounds.size.width, 15 }];
    [skipThisStep setBackgroundColor:[UIColor clearColor]];
    [skipThisStep setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [skipThisStep setText:@"or, skip this step"];
    [skipThisStep setTextColor:[UIColor gtio_lightGrayTextColor]];
    [skipThisStep setTextAlignment:UITextAlignmentCenter];
    UIView *underline = [[UIView alloc] initWithFrame:(CGRect){ 133.0, skipThisStep.bounds.size.height - 3, 70.0, 0.5 }];
    [underline setAlpha:0.60];
    [underline setBackgroundColor:[UIColor gtio_lightGrayTextColor]];
    [skipThisStep addSubview:underline];
    UIButton *skipThisStepInvisiButton = [[UIButton alloc] initWithFrame:(CGRect){ 133.0, 0, 70.0, skipThisStep.bounds.size.height }];
    [skipThisStepInvisiButton addTarget:self action:@selector(skipThisStep) forControlEvents:UIControlEventTouchUpInside];
    [skipThisStep setUserInteractionEnabled:YES];
    [skipThisStep addSubview:skipThisStepInvisiButton];
    [skipThisStepContainer addSubview:skipThisStep];
    self.tableView.tableFooterView = skipThisStepContainer;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
    self.accountCreatedView = nil;
    self.usersToFollow = nil;
    self.followButton = nil;
}

- (void)pushEditProfileViewController
{
    GTIOEditProfileViewController *editProfileViewController = [[GTIOEditProfileViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:editProfileViewController animated:YES];
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

- (void)checkboxStateChanged:(GTIOButton *)checkbox
{
    (checkbox.selected) ? self.usersToFollowSelected++ : self.usersToFollowSelected--;
    if (self.usersToFollowSelected > 0) {
        [self.followButton setEnabled:YES];
        [self.followButton setTitle:[NSString stringWithFormat:@"follow %i %@", self.usersToFollowSelected, (self.usersToFollowSelected == 1) ? @"person" : @"people"] forState:UIControlStateNormal];
    } else {
        [self.followButton setEnabled:NO];
    }
}

- (void)skipThisStep
{
    NSLog(@"skipping...");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
