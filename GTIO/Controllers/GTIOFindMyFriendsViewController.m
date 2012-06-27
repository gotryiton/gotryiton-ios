//
//  GTIOFindMyFriendsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFindMyFriendsViewController.h"
#import "GTIOFriendsTableHeaderView.h"
#import "GTIOFindMyFriendsTableViewCell.h"
#import "GTIOUser.h"
#import "GTIOFriendsNoSearchResultsView.h"

@interface GTIOFindMyFriendsViewController ()

@property (nonatomic, strong) UITableView *friendsTableView;
@property (nonatomic, strong) GTIOFriendsTableHeaderView *friendsTableHeaderView;

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, copy) NSString *currentSearchQuery;
@property (nonatomic, strong) GTIOFriendsNoSearchResultsView *noSearchResultsView;

@end

@implementation GTIOFindMyFriendsViewController

@synthesize friendsTableView = _friendsTableView, friendsTableHeaderView = _friendsTableHeaderView, friends = _friends, searching = _searching, searchResults = _searchResults, currentSearchQuery = _currentSearchQuery, noSearchResultsView = _noSearchResultsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    /**** TEST CODE ****/
    GTIOUser *testUser1 = [[GTIOUser alloc] init];
    testUser1.name = @"Anna Marie";
    testUser1.icon = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/en/thumb/7/7b/Rogue_Vol_3.jpg/250px-Rogue_Vol_3.jpg"];
    
    GTIOUser *testUser2 = [[GTIOUser alloc] init];
    testUser2.name = @"Peter Parker";
    testUser2.icon = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/en/5/52/Spider-Man.jpg"];
    
    GTIOUser *testUser3 = [[GTIOUser alloc] init];
    testUser3.name = @"Bruce Banner";
    testUser3.icon = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/en/thumb/3/3e/Incredible-hulk-20060221015639117.jpg/250px-Incredible-hulk-20060221015639117.jpg"];
    
    GTIOUser *testUser4 = [[GTIOUser alloc] init];
    testUser4.name = @"Clark Kent";
    testUser4.icon = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/en/thumb/7/72/Superman.jpg/250px-Superman.jpg"];
    
    GTIOUser *testUser5 = [[GTIOUser alloc] init];
    testUser5.name = @"Bruce Wayne";
    testUser5.icon = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/en/thumb/a/a7/Batman_Lee.png/250px-Batman_Lee.png"];
    
    NSArray *superHeroes = [NSArray arrayWithObjects:testUser1, testUser2, testUser3, testUser4, testUser5, nil];
    /**** END TEST CODE ****/
    
    [super viewDidLoad];
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"find my friends" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    
    CGFloat friendsTableHeaderViewHeight = [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFindMyFriends];
    self.friendsTableHeaderView = [[GTIOFriendsTableHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, friendsTableHeaderViewHeight } type:GTIOFriendsTableHeaderViewTypeFindMyFriends];
    [self.friendsTableHeaderView setSuggestedFriends:superHeroes];
    [self.friendsTableHeaderView setNumberOfFriendsFollowing:superHeroes.count];
    [self.friendsTableHeaderView setSearchBarDelegate:self];
    
    self.friendsTableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } style:UITableViewStylePlain];
    self.friendsTableView.tableHeaderView = self.friendsTableHeaderView;
    self.friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.friendsTableView.backgroundColor = [UIColor clearColor];
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
    [self.view addSubview:self.friendsTableView];
    
    self.friends = superHeroes;
    
    self.noSearchResultsView = [[GTIOFriendsNoSearchResultsView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.friendsTableHeaderView = nil;
    self.friendsTableView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text
{
    self.currentSearchQuery = text;
    self.searchResults = [NSMutableArray array];
    
    if (text.length == 0) {
        self.searching = NO;
    } else {
        self.searching = YES;
        
        for (GTIOUser *user in self.friends) {
            NSRange nameRange = [user.name rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound) {
                [self.searchResults addObject:user];
            }
        }
    }
    if (self.searchResults.count == 0 && self.searching) {
        [self.noSearchResultsView setFrame:(CGRect){ 0, 116, self.friendsTableView.bounds.size.width, self.friendsTableView.bounds.size.height - 116 }];
        [self.noSearchResultsView setFailedQuery:self.currentSearchQuery];
        [self.friendsTableView addSubview:self.noSearchResultsView];
    } else {
        [self.noSearchResultsView removeFromSuperview];
    }
    [self.friendsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.friendsTableView setFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height }];
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
    
    GTIOUser *userForRow;
    if (self.searching) {
        userForRow = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        userForRow = [self.friends objectAtIndex:indexPath.row];
    }
    [cell setUser:userForRow];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searching) {
        return self.searchResults.count;
    }
    return self.friends.count;
}

#pragma mark - Keyboard Notification methods

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self.friendsTableView setFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 215 }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
