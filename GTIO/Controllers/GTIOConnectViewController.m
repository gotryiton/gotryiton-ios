//
//  GTIOConnectViewController.m
//  GTIO
//
//  Created by Simon Holroyd on 11/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOConnectViewController.h"
#import "GTIOConnectTableViewCell.h"
#import "GTIONavigationNotificationTitleView.h"
#import "GTIOPullToLoadMoreContentView.h"
#import "GTIOPullToRefreshContentView.h"
#import "GTIONotificationsViewController.h"
#import "GTIOTrack.h"
#import "GTIOUser.h"
#import "GTIORouter.h"
#import "GTIOPagination.h"

static CGFloat const kGTIOScrollInsetPadding = 8.0f;
static CGFloat const kGTIOScrollInsetTopPadding = 14.0f;
static CGFloat const kGTIOScrollInsetBottomPadding = 0.0f;
static CGFloat const kGTIOTableHeaderViewVisibleHeight = 16.0f;

@interface GTIOConnectViewController ()


@property (nonatomic, strong) GTIONotificationsViewController *notificationsViewController;
@property (nonatomic, strong) UITableView *friendsTableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) NSMutableArray *suggestedFriends;

@property (nonatomic, strong) GTIOPagination *pagination;

@property (nonatomic, strong) SSPullToLoadMoreView *pullToLoadMoreView;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@end

@implementation GTIOConnectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.hidesBottomBarWhenPushed = NO;

        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnedFromInactive) name:kGTIOAppReturningFromInactiveStateNotification object:nil];
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOStyleControllerShouldRefresh object:nil];
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOAllControllersShouldRefresh object:nil];
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCollectionIDNotification:) name:kGTIOStylesChangeCollectionIDNotification object:nil];
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterLogout) name:kGTIOAllControllersShouldRefreshAfterLogout object:nil];
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToTop) name:kGTIOStyleControllerShouldScrollToTopNotification object:nil];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    GTIONavigationNotificationTitleView *navTitleView = [[GTIONavigationNotificationTitleView alloc] initWithTapHandler:^(void) {
        [self toggleNotificationView:YES];
    }];
    [self useTitleView:navTitleView];
    
    self.tableHeaderView = [[UIView alloc] initWithFrame:(CGRect){0, 0, self.view.frame.size.width, kGTIOTableHeaderViewVisibleHeight}];
    UIImageView *headerBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ptr-alt-bg.png"]];
    [headerBackground setFrame:(CGRect){ 0, kGTIOTableHeaderViewVisibleHeight - headerBackground.bounds.size.height, self.view.frame.size.width, headerBackground.bounds.size.height }];
    [self.tableHeaderView addSubview:headerBackground];

    self.friendsTableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } style:UITableViewStylePlain];
    [self.friendsTableView setContentInset:(UIEdgeInsets){0, 0, self.tabBarController.tabBar.bounds.size.height - kGTIOScrollInsetPadding - kGTIOScrollInsetBottomPadding, 0 }];
    
        
    self.friendsTableView.tableHeaderView = self.tableHeaderView;
    self.friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.friendsTableView.backgroundColor = [UIColor clearColor];
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;

    
    [self.view addSubview:self.friendsTableView];

    [self attachPullToLoadMore];

    [self loadUsersForTable];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    
    [self.pullToLoadMoreView removeObservers];
    [self.pullToRefreshView removeObservers];

    self.friendsTableView = nil;
    self.pullToLoadMoreView = nil;
    self.pullToRefreshView = nil;

}




- (void)loadUsersForTable
{
    NSString *resourcePath = @"/users/connect-tab";
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.pullToRefreshView finishLoading];
            // wipe out old data
            self.suggestedFriends = [NSMutableArray array];
            
            // load new data
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOUser class]]) {
                    [self.suggestedFriends addObject:object];
                }
                if ([object isMemberOfClass:[GTIOPagination class]]) {
                    self.pagination = (GTIOPagination *)object;
                }
            }
            
            // refresh screen with new data
            [self.friendsTableView reloadData];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.pullToRefreshView finishLoading];
            
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                [self loadUsersForTable];
            }];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (void)paginateUsersForTable
{
    if (self.pagination.nextPage) {
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.pagination.nextPage usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                
                [self.pullToLoadMoreView finishLoading];
                
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                
                for (id object in loadedObjects) {
                    if ([object isMemberOfClass:[GTIOUser class]]) {
                        [self.suggestedFriends addObject:object];
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

            };
        }];
    } else {
        [self.pullToLoadMoreView finishLoading];
    }
}

- (void)attachPullToLoadMore
{
    // Pull to load more
    self.pullToLoadMoreView = [[SSPullToLoadMoreView alloc] initWithScrollView:self.friendsTableView delegate:self];
    self.pullToLoadMoreView.contentView = [[GTIOPullToLoadMoreContentView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, 0.0f } }];
    self.pullToLoadMoreView.userInteractionEnabled = NO;
    [self.pullToLoadMoreView setExpandedHeight:0.0f];


    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.friendsTableView delegate:self];
    [self.pullToRefreshView setExpandedHeight:60.0f];
    GTIOPullToRefreshContentView *pullToRefreshContentView = [[GTIOPullToRefreshContentView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.bounds.size.width, 0 } }];
    [pullToRefreshContentView setScrollInsets:self.friendsTableView.scrollIndicatorInsets];
    [pullToRefreshContentView.background setHidden:YES];
    self.pullToRefreshView.contentView = pullToRefreshContentView;

}

- (NSUInteger)indexOfUserID:(NSString *)userID
{
    return [self.suggestedFriends indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
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

                    [blockSelf updateDataSourceUser:[self.suggestedFriends objectAtIndex:[blockSelf indexOfUserID:newUser.userID]] withUser:newUser];
                }
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}


#pragma mark - GTIOConnectTableViewCellDelegate Methods

- (void)updateDataSourceUser:(GTIOUser *)user withUser:(GTIOUser *)newUser
{
    NSUInteger indexForUser = [self.suggestedFriends indexOfObject:user];
    GTIOUser *oldUser = [self.suggestedFriends objectAtIndex:indexForUser];
    newUser.recentPostThumbnails = oldUser.recentPostThumbnails;
    [self.suggestedFriends replaceObjectAtIndex:indexForUser withObject:newUser];

    NSArray *indexes = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:indexForUser inSection:0], nil];
    [self.friendsTableView reloadRowsAtIndexPaths:indexes withRowAnimation:NO];
}




#pragma mark - SSPullToLoadMoreDelegate Methods

- (void)pullToLoadMoreViewDidStartLoading:(SSPullToLoadMoreView *)view
{
    [self paginateUsersForTable];
}


#pragma mark - SSPullToRefreshDelegate Methods

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{  
    [self loadUsersForTable];
}


#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GTIOUser *userForRow = (GTIOUser *)[self.suggestedFriends objectAtIndex:indexPath.row];
    
    UIViewController *profileViewController = [[GTIORouter sharedRouter] viewControllerForURLString:userForRow.action.destination];
    [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    
    GTIOConnectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[GTIOConnectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIOUser *userForRow = [self.suggestedFriends objectAtIndex:indexPath.row];
    
    GTIOConnectTableViewCell *customCell = (GTIOConnectTableViewCell *)cell;
    customCell.user = userForRow;
    customCell.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suggestedFriends.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - GTIONotificationViewDisplayProtocol

- (void)toggleNotificationView:(BOOL)animated
{
    if(self.notificationsViewController == nil) {
        self.notificationsViewController = [[GTIONotificationsViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    // if a child, remove it
    if([self.childViewControllers containsObject:self.notificationsViewController]) {
        [self closeNotificationView:YES];
    } else {
        [self openNotificationView:YES];
    }
}

- (void)closeNotificationView:(BOOL)animated
{
    if(self.notificationsViewController.parentViewController) {
        [self.notificationsViewController willMoveToParentViewController:nil];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.notificationsViewController.view setAlpha:0.0];
                         }
                         completion:^(BOOL finished) {
                             [self.notificationsViewController.view removeFromSuperview];
                             [self.notificationsViewController removeFromParentViewController];
                             [self.notificationsViewController didMoveToParentViewController:nil];
                         }];
    }
}

- (void)openNotificationView:(BOOL)animated
{
    if(self.notificationsViewController.parentViewController == nil) {
        [GTIOTrack postTrackWithID:kGTIONotificationViewTrackingId handler:nil];
        [self.notificationsViewController willMoveToParentViewController:self];
        [self addChildViewController:self.notificationsViewController];
        [self.notificationsViewController.view setAlpha:0.0];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.view addSubview:self.notificationsViewController.view];
                             [self.notificationsViewController.view setAlpha:1.0];
                         }
                         completion:^(BOOL finished) {
                             [self.notificationsViewController didMoveToParentViewController:self];
                         }];
    }
}


@end
