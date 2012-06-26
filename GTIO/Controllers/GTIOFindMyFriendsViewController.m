//
//  GTIOFindMyFriendsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFindMyFriendsViewController.h"
#import "GTIOFindMyFriendsTableHeaderView.h"
#import "GTIOFindMyFriendsTableViewCell.h"
#import "GTIOUser.h"

@interface GTIOFindMyFriendsViewController ()

@property (nonatomic, strong) UITableView *friendsTableView;
@property (nonatomic, strong) GTIOFindMyFriendsTableHeaderView *friendsTableHeaderView;

@end

@implementation GTIOFindMyFriendsViewController

@synthesize friendsTableView = _friendsTableView, friendsTableHeaderView = _friendsTableHeaderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"find my friends" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    
    self.friendsTableHeaderView = [[GTIOFindMyFriendsTableHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 116 }];
    NSArray *suggestedFriends = [NSArray arrayWithObjects:[GTIOUser currentUser], [GTIOUser currentUser], [GTIOUser currentUser], [GTIOUser currentUser], nil];
    [self.friendsTableHeaderView setSuggestedFriends:suggestedFriends];
    [self.friendsTableHeaderView setNumberOfFriendsFollowing:42];
    
    self.friendsTableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } style:UITableViewStylePlain];
    self.friendsTableView.tableHeaderView = self.friendsTableHeaderView;
    self.friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.friendsTableView.backgroundColor = [UIColor clearColor];
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
    [self.view addSubview:self.friendsTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.friendsTableHeaderView = nil;
    self.friendsTableView = nil;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    
    GTIOFindMyFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[GTIOFindMyFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell setUser:[GTIOUser currentUser]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
