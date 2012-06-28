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
#import "GTIOProfileViewController.h"
#import "GTIOSearchEntireCommunityView.h"

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
@property (nonatomic, strong) GTIOSearchEntireCommunityView *searchCommunityView;

@property (nonatomic, assign) GTIOFriendsTableHeaderViewType tableHeaderViewType;

@property (nonatomic, copy) NSString *subTitleText;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) GTIOUIButton *reloadButton;

@end

@implementation GTIOFriendsViewController

@synthesize friendsTableView = _friendsTableView, friendsTableHeaderView = _friendsTableHeaderView, friends = _friends, searching = _searching, searchResults = _searchResults, currentSearchQuery = _currentSearchQuery, noSearchResultsView = _noSearchResultsView, tableHeaderViewType = _tableHeaderViewType, buttons = _buttons, suggestedFriends = _suggestedFriends, subTitleText = _subTitleText, userID = _userID, searchCommunityView = _searchCommunityView, searchBar = _searchBar, reloadButton = _reloadButton;

- (id)initWithGTIOFriendsTableHeaderViewType:(GTIOFriendsTableHeaderViewType)tableHeaderViewType
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _tableHeaderViewType = tableHeaderViewType;
        _suggestedFriends = [NSMutableArray array];
        _buttons = [NSMutableArray array];
        _searchResults = [NSMutableArray array];
        _friends = [NSMutableArray array];
        
        self.hidesBottomBarWhenPushed = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{    
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
    self.reloadButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeReload tapHandler:^(id sender) {
        [self loadUsersForTable];
    }];
    if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeSuggested) {
        [self setRightNavigationButton:self.reloadButton];
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
    self.searchCommunityView = [[GTIOSearchEntireCommunityView alloc] initWithFrame:CGRectZero];
    
    [self.view sendSubviewToBack:self.friendsTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.friendsTableHeaderView = nil;
    self.friendsTableView = nil;
    self.noSearchResultsView = nil;
    self.searchCommunityView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.tableHeaderViewType != GTIOFriendsTableHeaderViewTypeFindFriends) {
        [self loadUsersForTable];
    } else {
        [self displaySearchCommunityView];
    }
    [self resetTableViewFrame];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}

#pragma mark - GTIOFriendsTableHeaderViewDelegate / GTIOMeTableHeaderViewDelegate methods

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar = searchBar;
}

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
        if (self.currentSearchQuery.length > 0 && self.tableHeaderViewType != GTIOFriendsTableHeaderViewTypeFindFriends) {
            [self displayNoResultsView];
        } else {
            if (self.friends.count == 0 && self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFindFriends) {
                [self displaySearchCommunityView];
            } else {
                [self displayNoResultsView];
            }
        }
    } else {
        [self.noSearchResultsView removeFromSuperview];
        [self.searchCommunityView removeFromSuperview];
        if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFindFriends && self.friends.count == 0) {
            [self displaySearchCommunityView];
        }
    }
    
    [self.friendsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self resetTableViewFrame];
    
    if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFindFriends && self.currentSearchQuery.length > 0) {
        NSString *resourcePath = [NSString stringWithFormat:@"/users/search-community/%@", [self.currentSearchQuery URLEscaped]];
        
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.noSearchResultsView removeFromSuperview];
        [self.searchCommunityView removeFromSuperview];
        
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                self.friends = [NSMutableArray array];
                self.searchResults = [NSMutableArray array];
                for (id object in loadedObjects) {
                    if ([object isMemberOfClass:[GTIOUser class]]) {
                        [self.friends addObject:object];
                        [self.searchResults addObject:object];
                    }
                }
                if (self.friends.count == 0) {
                    [self displayNoResultsView];
                }
                [self.friendsTableView reloadData];
            };
            loader.onDidFailWithError = ^(NSError *error) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"%@", [error localizedDescription]);
            };
        }];
    }
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GTIOProfileViewController *profileViewController = [[GTIOProfileViewController alloc] initWithNibName:nil bundle:nil];
    GTIOUser *userForRow;
    if (self.searching) {
        userForRow = (GTIOUser *)[self.searchResults objectAtIndex:indexPath.row];
    } else {
        userForRow = (GTIOUser *)[self.friends objectAtIndex:indexPath.row];
    }
    [profileViewController setUserID:userForRow.userID];
    
    [self.navigationController pushViewController:profileViewController animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([[self.noSearchResultsView superview] isEqual:self.friendsTableView]) {
        return [self.noSearchResultsView height];
    }
    if ([[self.searchCommunityView superview] isEqual:self.friendsTableView]) {
        return [self.searchCommunityView height];
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Keyboard Notification methods

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self.friendsTableView setFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 215 }];
    [self.friendsTableView reloadData];
    if (self.searching && self.searchResults.count > 0) {
        [self.friendsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else if (self.friends.count > 0 && !self.searching) {
        [self.friendsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else {
        [self.friendsTableView scrollRectToVisible: CGRectOffset(self.friendsTableHeaderView.searchBoxView.frame, 0.0, 15.0) animated:YES];
    }
}

#pragma mark - GTIOFindMyFriendsTableViewCellDelegate method

- (void)updateDataSourceWithUser:(GTIOUser *)user atIndexPath:(NSIndexPath *)indexPath
{
    if (self.searching) {
        [self.searchResults removeObjectAtIndex:indexPath.row];
        [self.searchResults insertObject:user atIndex:indexPath.row];
    } else {
        [self.friends removeObjectAtIndex:indexPath.row];
        [self.friends insertObject:user atIndex:indexPath.row];
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
        case GTIOFriendsTableHeaderViewTypeFollowers:
            resourcePath = [NSString stringWithFormat:@"/user/%@/followers", (self.userID.length > 0) ? self.userID : [GTIOUser currentUser].userID];
            break;
        case GTIOFriendsTableHeaderViewTypeFollowing:
            resourcePath = [NSString stringWithFormat:@"/user/%@/following", (self.userID.length > 0) ? self.userID : [GTIOUser currentUser].userID];
            break;
        case GTIOFriendsTableHeaderViewTypeSuggested:
            resourcePath = @"/user/suggested-friends";
            break;
        default:
            resourcePath = @"/users/friends";
            break;
    }

    self.searchResults = [NSMutableArray array];
    self.subTitleText = @"";
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.reloadButton) {
        self.reloadButton.userInteractionEnabled = NO;
    }
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadResponse = ^(RKResponse *response) {
            NSDictionary *parsedBody = [[response bodyAsString] objectFromJSONString];
            if ([parsedBody valueForKeyPath:@"ui.search_box.text"]) {
                self.subTitleText = [[[parsedBody objectForKey:@"ui"] objectForKey:@"search_box"] objectForKey:@"text"];
            } else if ([parsedBody valueForKeyPath:@"ui.subtitle"]) {
                self.subTitleText = [[parsedBody objectForKey:@"ui"] objectForKey:@"subtitle"];
            }
            [self updateFollowingText];
        };
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            if (self.reloadButton) {
                self.reloadButton.userInteractionEnabled = YES;
            }
            
            // wipe out old data
            self.friends = [NSMutableArray array];
            self.suggestedFriends = [NSMutableArray array];
            self.buttons = [NSMutableArray array];
            
            // load new data
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOUser class]]) {
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
            
            // refresh screen with new data
            [self.friendsTableHeaderView setSuggestedFriends:self.suggestedFriends];
            [self.friendsTableView reloadData];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            if (self.reloadButton) {
                self.reloadButton.userInteractionEnabled = YES;
            }
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (void)updateFollowingText
{
    [self.friendsTableHeaderView setSubTitleText:self.subTitleText];
}

- (void)displaySearchCommunityView
{
    [self.searchCommunityView removeFromSuperview];
    [self.searchCommunityView setFrame:(CGRect){ 0, [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType], self.friendsTableView.bounds.size.width, self.friendsTableView.contentSize.height - [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType] }];
    [self.friendsTableView addSubview:self.searchCommunityView];
}

- (void)displayNoResultsView
{
    [self.noSearchResultsView removeFromSuperview];
    [self.noSearchResultsView setFrame:(CGRect){ 0, [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType], self.friendsTableView.bounds.size.width, self.friendsTableView.contentSize.height - [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType] }];
    [self.noSearchResultsView setFailedQuery:self.currentSearchQuery];
    [self.friendsTableView addSubview:self.noSearchResultsView];
}

- (void)resetTableViewFrame
{
    [self.friendsTableView setFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end