//
//  GTIOFindMyFriendsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFriendsViewController.h"
#import "GTIOUser.h"
#import "GTIOPagination.h"
#import "GTIOFriendsNoSearchResultsView.h"
#import "GTIOProgressHUD.h"
#import "GTIOSuggestedFriendsIcon.h"
#import "GTIOProfileViewController.h"
#import "GTIOSearchEntireCommunityView.h"
#import "GTIORouter.h"

#import "GTIOFriendsManagementScreen.h"
#import "GTIOFollowingScreen.h"
#import "GTIOFollowersScreen.h"
#import "GTIOFindMyFriendsScreen.h"

static CGFloat const kGTIOScrollInsetPadding = 8.0f;

@interface GTIOFriendsViewController () <SSPullToLoadMoreViewDelegate>

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
@property (nonatomic, strong) GTIOUIButton *findFriendsButton;

@property (nonatomic, strong) GTIOPagination *pagination;
@property (nonatomic, strong) SSPullToLoadMoreView *pullToLoadMoreView;

@end

@implementation GTIOFriendsViewController

- (id)initWithGTIOFriendsTableHeaderViewType:(GTIOFriendsTableHeaderViewType)tableHeaderViewType
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _tableHeaderViewType = tableHeaderViewType;
        _suggestedFriends = [NSMutableArray array];
        _buttons = [NSMutableArray array];
        _searchResults = [NSMutableArray array];
        _friends = [NSMutableArray array];
        
        self.hidesBottomBarWhenPushed = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [self paginateUsersForTable];
    }];
    if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeSuggested) {
        [self setRightNavigationButton:self.reloadButton];
    }
    self.findFriendsButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeFindFriends tapHandler:^(id sender) {
        GTIOFriendsViewController *viewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFindFriends];
        [viewController setUserID:[GTIOUser currentUser].userID];
        [self pushViewController:viewController];
    }];
    if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFollowing || self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFollowers) {
        [self setRightNavigationButton:self.findFriendsButton];
    }
    
    CGFloat friendsTableHeaderViewHeight = [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType];
    self.friendsTableHeaderView = [[GTIOFriendsTableHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, friendsTableHeaderViewHeight } type:self.tableHeaderViewType];
    [self.friendsTableHeaderView setDelegate:self];
    [self.friendsTableHeaderView setSearchBarDelegate:self];
    
    self.friendsTableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } style:UITableViewStylePlain];
    [self.friendsTableView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height - kGTIOScrollInsetPadding, 0 }];
    self.friendsTableView.tableHeaderView = self.friendsTableHeaderView;
    self.friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.friendsTableView.backgroundColor = [UIColor clearColor];
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
    UIImageView *tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-shadow.png"]];
    [tableFooterView setFrame:(CGRect){ 0, 0, self.friendsTableView.bounds.size.width, 5 }];
    self.friendsTableView.tableFooterView = tableFooterView;
    self.friendsTableView.tableFooterView.hidden = YES;
    if (self.tableHeaderViewType != GTIOFriendsTableHeaderViewTypeFindFriends) {
        self.friendsTableView.tableFooterView.hidden = NO;
    }
    [self.view addSubview:self.friendsTableView];
    
    self.noSearchResultsView = [[GTIOFriendsNoSearchResultsView alloc] initWithFrame:CGRectZero];
    [self.noSearchResultsView setDelegate:self];
    
    self.searchCommunityView = [[GTIOSearchEntireCommunityView alloc] initWithFrame:CGRectZero];
    [self.searchCommunityView setDelegate:self];
    
    if (self.tableHeaderViewType != GTIOFriendsTableHeaderViewTypeSuggested && self.tableHeaderViewType != GTIOFriendsTableHeaderViewTypeFindFriends) {
        [self attachPullToLoadMore];
    }

    [self.view sendSubviewToBack:self.friendsTableView];

    if (self.tableHeaderViewType != GTIOFriendsTableHeaderViewTypeFindFriends) {
        [self loadUsersForTable];    
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.pullToLoadMoreView removeObservers];
    self.pullToLoadMoreView = nil;
    self.friendsTableHeaderView = nil;
    self.friendsTableView = nil;
    self.noSearchResultsView = nil;
    self.searchCommunityView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.searchResults.count == 0) {
        // clear any previous searches
        self.searchBar.text = @"";
        self.searchResults = [NSMutableArray array];
        self.searching = NO;
        [self.noSearchResultsView removeFromSuperview];
        [self.searchCommunityView removeFromSuperview];
        
        if (self.tableHeaderViewType == GTIOFriendsTableHeaderViewTypeFindFriends) {
            [self displaySearchCommunityView];
        }
        [self resetTableViewFrame];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}

- (void)attachPullToLoadMore
{
    // Pull to load more
    self.pullToLoadMoreView = [[SSPullToLoadMoreView alloc] initWithScrollView:self.friendsTableView delegate:self];
    self.pullToLoadMoreView.contentView = [[GTIOPullToLoadMoreContentView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, 0.0f } }];
    self.pullToLoadMoreView.userInteractionEnabled = NO;
    [self.pullToLoadMoreView setExpandedHeight:0.0f];
}

#pragma mark - SSPullToLoadMoreDelegate Methods

- (void)pullToLoadMoreViewDidStartLoading:(SSPullToLoadMoreView *)view
{
    [self paginateUsersForTable];
}

#pragma mark - GTIOFriendsTableHeaderViewDelegate / GTIOMeTableHeaderViewDelegate / GTIOFriendsSearchEmptyStateViewDelegate methods

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)reloadTableData
{
    [self.friendsTableView reloadData];
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
        } else {
            self.friendsTableView.tableFooterView.hidden = NO;
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
                } else {
                    self.friendsTableView.tableFooterView.hidden = NO;
                }
                [self.friendsTableView reloadData];
            };
            loader.onDidFailWithError = ^(NSError *error) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                    [self searchBarSearchButtonClicked:searchBar];
                }];
                NSLog(@"%@", [error localizedDescription]);
            };
        }];
    }
}

#pragma mark - GTIOFindMyFriendsTableViewCellDelegate Methods

- (void)updateDataSourceUser:(GTIOUser *)user withUser:(GTIOUser *)newUser
{
    NSUInteger indexForUser;
    if (self.searching) {
        indexForUser = [self.searchResults indexOfObject:user];
        [self.searchResults replaceObjectAtIndex:indexForUser withObject:newUser];

    } else {
        indexForUser = [self.friends indexOfObject:user];
        [self.friends replaceObjectAtIndex:indexForUser withObject:newUser];

    }
    NSArray *indexes = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:indexForUser inSection:0], nil];
    [self.friendsTableView reloadRowsAtIndexPaths:indexes withRowAnimation:NO];
}


- (NSUInteger)indexOfUserID:(NSString *)userID
{
    return [self.friends indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
       GTIOUser *user = (GTIOUser*)obj;
       return ([user.userID isEqualToString:userID]);
    }];
}


- (void)buttonTapped:(GTIOButton*)button;
{
    __block typeof(self) blockSelf = self;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            for (id object in objects) {
                if ([object isMemberOfClass:[GTIOUser class]]) {
                    GTIOUser *newUser = (GTIOUser *)object;

                    [blockSelf updateDataSourceUser:[self.friends objectAtIndex:[blockSelf indexOfUserID:newUser.userID]] withUser:newUser];
                }
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}


#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GTIOUser *userForRow;
    if (self.searching) {
        userForRow = (GTIOUser *)[self.searchResults objectAtIndex:indexPath.row];
    } else {
        userForRow = (GTIOUser *)[self.friends objectAtIndex:indexPath.row];
    }
    UIViewController *profileViewController = [[GTIORouter sharedRouter] viewControllerForURLString:userForRow.action.destination];
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIOUser *userForRow;
    if (self.searching) {
        userForRow = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        userForRow = [self.friends objectAtIndex:indexPath.row];
    }
    GTIOFindMyFriendsTableViewCell *customCell = (GTIOFindMyFriendsTableViewCell *)cell;
    customCell.user = userForRow;
    customCell.delegate = self;
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

- (void)paginateUsersForTable
{
    if (self.pagination.nextPage) {
        if (!self.pullToLoadMoreView){
            [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        self.reloadButton.userInteractionEnabled = NO;
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.pagination.nextPage usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                if (self.pullToLoadMoreView){
                    [self.pullToLoadMoreView finishLoading];
                } else {
                    self.friends = [NSMutableArray array];
                }
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                self.reloadButton.userInteractionEnabled = YES;
                
                for (id object in loadedObjects) {
                    if ([object isMemberOfClass:[GTIOUser class]]) {
                        [self.friends addObject:object];
                    }
                    
                    if ([object isMemberOfClass:[GTIOPagination class]]) {
                        self.pagination = (GTIOPagination *)object;
                    }
                }
                
                [self.friendsTableView reloadData];
            };
            loader.onDidFailWithError = ^(NSError *error) {
                [self.pullToLoadMoreView finishLoading];
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                self.reloadButton.userInteractionEnabled = YES;
            };
        }];
    } else {
        [self.pullToLoadMoreView finishLoading];
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
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            
            // wipe out old data
            self.friends = [NSMutableArray array];
            self.suggestedFriends = [NSMutableArray array];
            self.buttons = [NSMutableArray array];
            
            // load new data
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOFriendsManagementScreen class]]) {
                    GTIOFriendsManagementScreen *friendsManagementScreen = (GTIOFriendsManagementScreen *)object;
                    for (id object in friendsManagementScreen.buttons) {
                        [self.buttons addObject:object];
                        GTIOButton *button = (GTIOButton *)object;
                        if ([button.name isEqualToString:kGTIOSuggestedFriendsButtonName]) {                            
                            for (GTIOSuggestedFriendsIcon *icon in button.icons) {
                                GTIOUser *userWithOnlyAProfilePicture = [[GTIOUser alloc] init];
                                userWithOnlyAProfilePicture.icon = [NSURL URLWithString:icon.iconPath];
                                [self.suggestedFriends addObject:userWithOnlyAProfilePicture];
                            }
                            self.friendsTableHeaderView.suggestedFriendsURL = button.action.destination;
                        }
                        if ([button.name isEqualToString:kGTIOFindFriendsButtonName]) {
                            self.friendsTableHeaderView.findFriendsURL = button.action.destination;
                        }
                        if ([button.name isEqualToString:kGTIOInviteFriendsButtonName]) {
                            self.friendsTableHeaderView.inviteFriendsURL = button.action.destination;
                        }
                    }
                    self.subTitleText = friendsManagementScreen.searchBox.text;
                }
                if ([object isMemberOfClass:[GTIOFindMyFriendsScreen class]]) {
                    GTIOFindMyFriendsScreen *findMyFriendsScreen = (GTIOFindMyFriendsScreen *)object;
                    for (id object in findMyFriendsScreen.buttons) {
                        GTIOButton *button = (GTIOButton *)object;
                        for (GTIOSuggestedFriendsIcon *icon in button.icons) {
                            GTIOUser *userWithOnlyAProfilePicture = [[GTIOUser alloc] init];
                            userWithOnlyAProfilePicture.icon = [NSURL URLWithString:icon.iconPath];
                            [self.suggestedFriends addObject:userWithOnlyAProfilePicture];
                        }
                        if ([button.name isEqualToString:kGTIOFindFriendsButtonName]) {
                            self.friendsTableHeaderView.findFriendsURL = button.action.destination;
                        }
                        if ([button.name isEqualToString:kGTIOSuggestedFriendsButtonName]) {
                            self.friendsTableHeaderView.suggestedFriendsURL = button.action.destination;
                        }
                        if ([button.name isEqualToString:kGTIOInviteFriendsButtonName]) {
                            self.friendsTableHeaderView.inviteFriendsURL = button.action.destination;
                        }
                    }
                    self.subTitleText = findMyFriendsScreen.searchBox.text;
                }
                if ([object isMemberOfClass:[GTIOFollowingScreen class]]) {
                    GTIOFollowingScreen *followingScreen = (GTIOFollowingScreen *)object;
                    self.subTitleText = followingScreen.subtitle;
                }
                if ([object isMemberOfClass:[GTIOFollowersScreen class]]) {
                    GTIOFollowersScreen *followingScreen = (GTIOFollowersScreen *)object;
                    self.subTitleText = followingScreen.subtitle;
                }
                if ([object isMemberOfClass:[GTIOUser class]]) {
                    [self.friends addObject:object];
                }
                if ([object isMemberOfClass:[GTIOPagination class]]) {
                    self.pagination = (GTIOPagination *)object;
                }
            }
            
            // refresh screen with new data
            [self updateFollowingText];
            [self.friendsTableHeaderView setSuggestedFriends:self.suggestedFriends];
            [self.friendsTableView reloadData];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            if (self.reloadButton) {
                self.reloadButton.userInteractionEnabled = YES;
            }
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                [self loadUsersForTable];
            }];
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
    [self.noSearchResultsView removeFromSuperview];
    [self.searchCommunityView removeFromSuperview];
    [self.searchCommunityView setFrame:(CGRect){ 0, [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType], self.friendsTableView.bounds.size.width, self.friendsTableView.frame.size.height - [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType] }];
    [self.friendsTableView addSubview:self.searchCommunityView];
    [self.friendsTableView bringSubviewToFront:self.searchCommunityView];
    self.friendsTableView.tableFooterView.hidden = YES;
}

- (void)displayNoResultsView
{
    [self.noSearchResultsView removeFromSuperview];
    [self.searchCommunityView removeFromSuperview];
    [self.noSearchResultsView setFrame:(CGRect){ 0, [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType], self.friendsTableView.bounds.size.width, self.friendsTableView.frame.size.height - [GTIOFriendsTableHeaderView heightForGTIOFriendsTableHeaderViewType:self.tableHeaderViewType] }];
    [self.friendsTableView addSubview:self.noSearchResultsView];
    [self.friendsTableView bringSubviewToFront:self.noSearchResultsView];
    self.friendsTableView.tableFooterView.hidden = YES;
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