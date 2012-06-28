//
//  GTIOFindMyFriendsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFriendsViewController.h"
#import "GTIOUser.h"
#import "GTIOFriendsNoSearchResultsView.h"
#import "GTIOProgressHUD.h"
#import "GTIOSuggestedFriendsIcon.h"

@interface GTIOFriendsViewController ()

@property (nonatomic, strong) UITableView *friendsTableView;
@property (nonatomic, strong) GTIOFriendsTableHeaderView *friendsTableHeaderView;

@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *suggestedFriends;

@property (nonatomic, assign) BOOL searching;
@property (nonatomic, copy) NSString *currentSearchQuery;
@property (nonatomic, strong) GTIOFriendsNoSearchResultsView *noSearchResultsView;

@property (nonatomic, assign) GTIOFriendsTableHeaderViewType tableHeaderViewType;

@property (nonatomic, assign) int numberOfFriendsFollowing;

@end

@implementation GTIOFriendsViewController

@synthesize friendsTableView = _friendsTableView, friendsTableHeaderView = _friendsTableHeaderView, friends = _friends, searching = _searching, searchResults = _searchResults, currentSearchQuery = _currentSearchQuery, noSearchResultsView = _noSearchResultsView, tableHeaderViewType = _tableHeaderViewType, buttons = _buttons, suggestedFriends = _suggestedFriends, numberOfFriendsFollowing = _numberOfFriendsFollowing;

- (id)initWithGTIOFriendsTableHeaderViewType:(GTIOFriendsTableHeaderViewType)tableHeaderViewType
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _tableHeaderViewType = tableHeaderViewType;
        _suggestedFriends = [NSMutableArray array];
        _buttons = [NSMutableArray array];
        _searchResults = [NSMutableArray array];
        _friends = [NSMutableArray array];
        _numberOfFriendsFollowing = 0;
        
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
    
    NSString *title;
    if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFollowers) {
        title = @"followers";
    } else if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFollowing) {
        title = @"following";
    } else if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFindMyFriends) {
        title = @"find my friends";
    } else if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFriends) {
        title = @"friends";
    } else if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeSuggested) {
        title = @"suggested friends";
    } else if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFindFriends) {
        title = @"find friends";
    }
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:title italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    GTIOUIButton *closeButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeCloseButtonForNavBar tapHandler:^(id sender) {
        [self dismissModalViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFriends) {
        [self setLeftNavigationButton:closeButton];
    }
    
    CGFloat friendsTableHeaderViewHeight = [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType];
    self.friendsTableHeaderView = [[GTIOFriendsTableHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, friendsTableHeaderViewHeight } type:self.tableHeaderViewType];
    [self.friendsTableHeaderView setDelegate:self];
    [self.friendsTableHeaderView setSearchBarDelegate:self];
    
    self.friendsTableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } style:UITableViewStylePlain];
    self.friendsTableView.tableHeaderView = self.friendsTableHeaderView;
    self.friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.friendsTableView.backgroundColor = [UIColor clearColor];
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
    [self.view addSubview:self.friendsTableView];
    
    self.noSearchResultsView = [[GTIOFriendsNoSearchResultsView alloc] initWithFrame:CGRectZero];
    
    [self.view sendSubviewToBack:self.friendsTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.friendsTableHeaderView = nil;
    self.friendsTableView = nil;
    self.noSearchResultsView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadUsersForTable];
}

#pragma mark - GTIOFriendsTableHeaderViewDelegate methods

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
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
        [self.noSearchResultsView setFrame:(CGRect){ 0, [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType], self.friendsTableView.bounds.size.width, self.friendsTableView.bounds.size.height - [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType] }];
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
    
    [cell setDelegate:self];
    [cell setUser:userForRow indexPath:indexPath];
    
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

#pragma mark - GTIOFindMyFriendsTableViewCellDelegate method

- (void)updateDataSourceWithUser:(GTIOUser *)user atIndexPath:(NSIndexPath *)indexPath
{
    if (user.button.state.intValue == GTIOFollowButtonStateFollow) {
        self.numberOfFriendsFollowing--;
    } else if (user.button.state.intValue == GTIOFollowButtonStateFollowing) {
        self.numberOfFriendsFollowing++;
    }
    
    if (self.searching) {
        [self.searchResults removeObjectAtIndex:indexPath.row];
        [self.searchResults insertObject:user atIndex:indexPath.row];
    } else {
        [self.friends removeObjectAtIndex:indexPath.row];
        [self.friends insertObject:user atIndex:indexPath.row];
    }
    
    if (self.tableHeaderViewType != GTIOFriendsTableHeaderViewTypeFollowers) {
        [self updateFollowingText];
    }
}

- (void)loadUsersForTable
{
    NSString *resourcePath;
    switch (self.tableHeaderViewType) {
        case GTIOFriendsTableHeaderViewTypeFindMyFriends:
            resourcePath = @"/users/friends";
            break;
        case GTIOFriendsTableHeaderViewTypeFriends:
            resourcePath = @"/users/friends/manage";
            break;
        default:
            resourcePath = @"/users/friends";
            break;
    }
    
    self.friends = [NSMutableArray array];
    self.buttons = [NSMutableArray array];
    self.suggestedFriends = [NSMutableArray array];
    self.searchResults = [NSMutableArray array];
    self.numberOfFriendsFollowing = 0;
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOUser class]]) {
                    GTIOUser *friend = (GTIOUser *)object;
                    if (friend.button.state.intValue == GTIOFollowButtonStateFollowing) {
                        self.numberOfFriendsFollowing++;
                    }
                    [self.friends addObject:object];
                }
                if ([object isMemberOfClass:[GTIOButton class]]) {
                    [self.buttons addObject:object];
                    GTIOButton *button = (GTIOButton *)object;
                    if ([button.name isEqualToString:kGTIOSuggestedFriendsButtonName]) {
                        for (GTIOSuggestedFriendsIcon *icon in button.icons) {
                            GTIOUser *userWithOnlyAProfilePicture = [[GTIOUser alloc] init];
                            userWithOnlyAProfilePicture.icon = [NSURL URLWithString:icon.iconPath];
                            [self.suggestedFriends addObject:userWithOnlyAProfilePicture];
                        }
                    }
                }
            }
            [self.friendsTableHeaderView setSuggestedFriends:self.suggestedFriends];
            [self updateFollowingText];
            [self.friendsTableView reloadData];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (void)updateFollowingText
{
    if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFollowers) {
        [self.friendsTableHeaderView setNumberOfFollowers:self.friends.count];
    } else {
        [self.friendsTableHeaderView setNumberOfFriendsFollowing:self.numberOfFriendsFollowing];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
