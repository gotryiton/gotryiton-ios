//
//  GTIOFeedViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/15/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFeedViewController.h"

#import <RestKit/RestKit.h>
#import "SSPullToRefresh.h"

#import "GTIOPostManager.h"
#import "GTIORouter.h"
#import "GTIOAppDelegate.h"

#import "GTIOPagination.h"
#import "GTIOPostUpload.h"

#import "GTIOPostHeaderView.h"
#import "GTIOPostUploadView.h"
#import "GTIOFeedCell.h"
#import "GTIONavigationNotificationTitleView.h"
#import "GTIOFeedNavigationBarView.h"
#import "GTIOFriendsViewController.h"
#import "GTIOProfileViewController.h"
#import "GTIORetryHUD.h"

#import "GTIOPullToRefreshContentView.h"

#import "GTIOReviewsViewController.h"
#import "GTIONotificationsViewController.h"

#import "GTIOShopThisLookViewController.h"
#import "GTIOShoppingListViewController.h"
#import "GTIOProductNativeListViewController.h"

#import "SSPullToLoadMoreView.h"
#import "GTIOPullToLoadMoreContentView.h"

#import "GTIOTweetComposer.h"

static NSString * const kGTIOKVOSuffix = @"ValueChanged";

static NSString * const kGTIONoTwitterMessage = @"You're not set up to Tweet yet! Find the Twitter option in your iPhone's Settings to get started!";
static NSString * const kGTIOAlertForDeletingPost = @"do you want to delete this post permanently?";
static NSString * const kGTIOAlertTitleForDeletingPost = @"wait!";

@interface GTIOFeedViewController () <UITableViewDataSource, UITableViewDelegate, GTIOFeedHeaderViewDelegate, GTIOFeedCellDelegate, SSPullToRefreshViewDelegate, SSPullToLoadMoreViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GTIOFeedNavigationBarView *navBarView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) GTIOPagination *pagination;
@property (nonatomic, strong) GTIOButton *deleteButton;

@property (nonatomic, strong) GTIOPostUpload *postUpload;
@property (nonatomic, strong) GTIOPostUploadView *uploadView;

@property (nonatomic, assign) CGFloat addNavToHeaderOffsetXOrigin;
@property (nonatomic, assign) CGFloat removeNavToHeaderOffsetXOrigin;

@property (nonatomic, strong) NSMutableSet *offScreenHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *onScreenHeaderViews;

@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) SSPullToLoadMoreView *pullToLoadMoreView;

@property (nonatomic, strong) UIImageView *emptyView;
@property (nonatomic, strong) UITapGestureRecognizer *emptyViewTapGestureRecognizer;

@property (nonatomic, strong) GTIONotificationsViewController *notificationsViewController;

@property (nonatomic, assign) BOOL shouldRefreshAfterInactive;

@end

@implementation GTIOFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _posts = [NSMutableArray array];
        
        _offScreenHeaderViews = [NSMutableSet set];
        _onScreenHeaderViews = [NSMutableDictionary dictionary];
        
        _addNavToHeaderOffsetXOrigin = -44.0f;
        _removeNavToHeaderOffsetXOrigin = -0.0f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnedFromInactive) name:kGTIOAppReturningFromInactiveStateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOFeedControllerShouldRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOAllControllersShouldRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterLogout) name:kGTIOAllControllersShouldRefreshAfterLogout object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[GTIOPostManager sharedManager] removeObserver:self forKeyPath:@"progress"];
    [[GTIOPostManager sharedManager] removeObserver:self forKeyPath:@"state"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBarView = [[GTIOFeedNavigationBarView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, 44 } }];
    
    __block typeof(self) blockSelf = self;
    
    [self.navBarView.friendsButton setTapHandler:^(id sender) {
        GTIOFriendsViewController *friendsViewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFriends];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
        [blockSelf presentModalViewController:navController animated:YES];
    }];

    self.navBarView.titleView.tapHandler = ^(void) {
        [blockSelf toggleNotificationView:YES];
    };
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionHeaderHeight:56.0f];
    [self.tableView setSeparatorStyle:UITableViewCellSelectionStyleNone];
    [self.tableView setScrollIndicatorInsets:(UIEdgeInsets){ self.navBarView.frame.size.height, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.tableView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAllowsSelection:NO];
    [self.tableView setTableHeaderView:self.navBarView];
    [self.view addSubview:self.tableView];
    
    [[GTIOPostManager sharedManager] addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:NULL];
    [[GTIOPostManager sharedManager] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.emptyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty-bg-overlay.png"]];
    [self.emptyView setFrame:(CGRect){ { 0, self.navigationController.navigationBar.frame.size.height }, self.emptyView.image.size }];
    [self.emptyView setUserInteractionEnabled:YES];
    self.emptyViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadFeed)];
    [self.emptyView addGestureRecognizer:self.emptyViewTapGestureRecognizer];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    [self.pullToRefreshView setExpandedHeight:60.0f];
    GTIOPullToRefreshContentView *pullToRefreshContentView = [[GTIOPullToRefreshContentView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.bounds.size.width, 0 } }];
    [pullToRefreshContentView setScrollInsets:self.tableView.scrollIndicatorInsets];
    self.pullToRefreshView.contentView = pullToRefreshContentView;

    self.uploadView = [[GTIOPostUploadView alloc] initWithFrame:(CGRect){ CGPointZero, { self.tableView.bounds.size.width, self.tableView.sectionHeaderHeight } }];
    
    self.pullToLoadMoreView = [[SSPullToLoadMoreView alloc] initWithScrollView:self.tableView delegate:self];
    [self.pullToLoadMoreView setExpandedHeight:0.0f];
    self.pullToLoadMoreView.contentView = [[GTIOPullToLoadMoreContentView alloc] initWithFrame:(CGRect){ CGPointZero, { self.tableView.frame.size.width, 0.0f } }];
    
    [self.tableView bringSubviewToFront:self.navBarView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[GTIOPostManager sharedManager] removeObserver:self forKeyPath:@"progress"];
    [[GTIOPostManager sharedManager] removeObserver:self forKeyPath:@"state"];
    self.notificationsViewController = nil;
    self.navBarView = nil;
    self.emptyView = nil;
    self.uploadView = nil;
    [self.pullToRefreshView removeObservers];
    self.pullToRefreshView = nil;
    [self.pullToLoadMoreView removeObservers];
    self.pullToLoadMoreView = nil;
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self showStatusBarBackgroundWithoutNavigationBar];
    [self.tableView bringSubviewToFront:self.navBarView];
    [self.navBarView.titleView forceUpdateCountLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openURL:) name:kGTIOPostFeedOpenLinkNotification object:nil];
    
    if ([self.posts count] == 0) {
        [self.pullToRefreshView startLoading];
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES dimScreen:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fix for the tab bar going opaque when you go to a view that hides it and back to a view that has the tab bar
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOTabBarViewsResize object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self closeNotificationView:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGTIOPostFeedOpenLinkNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Refresh After Inactive

- (void)appReturnedFromInactive
{
    self.shouldRefreshAfterInactive = YES;
}

- (void)refreshAfterInactive
{
    if(self.shouldRefreshAfterInactive) {
        self.shouldRefreshAfterInactive = NO;
        [self loadFeed];
        // load all the rest here
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOAllControllersShouldRefresh object:nil];
    }
}

#pragma mark - Refresh after Logout

- (void)refreshAfterLogout
{
    [self loadFeed];
}

#pragma mark - Load Data

- (void)loadFeed
{
    [self.emptyView removeGestureRecognizer:self.emptyViewTapGestureRecognizer]; // So you can't tap it multiple times

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/posts/feed" usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [self.posts removeAllObjects];
            
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOPost class]]) {
                    GTIOPost *post = (GTIOPost *)object;
                    post.reviewsButtonTapHandler = ^(id sender) {
                        UIViewController *reviewsViewController;
                        for (id object in post.buttons) {
                            if ([object isMemberOfClass:[GTIOButton class]]) {
                                GTIOButton *button = (GTIOButton *)object;
                                if ([button.name isEqualToString:kGTIOPostSideReviewsButton]) {
                                    reviewsViewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.action.destination];
                                }
                            }
                        }
                        [self.navigationController pushViewController:reviewsViewController animated:YES];
                    };
                    if ([post.products count]>0){
                        post.shopTheLookButtonTapHandler = ^(id sender) {
                            UIViewController *viewController = [[GTIOShopThisLookViewController alloc] initWithPostID:post.postID];
                            [self.navigationController pushViewController:viewController animated:YES];
                        };
                    }
                    [self.posts addObject:object];
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    self.pagination = object;
                }
            }
            
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
            [self headerSectionViewsStyling];
            [self.pullToRefreshView finishLoading];
            
            [self checkAndDisplayEmptyState];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.pullToRefreshView finishLoading];
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                [self loadFeed];
            }];
        };
    }];
}

- (void)loadPagination
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.pagination.nextPage usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [self.pullToLoadMoreView finishLoading];
            self.pagination = nil;
            
            NSMutableArray *paginationPosts = [NSMutableArray array];
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOPost class]]) {
                    [paginationPosts addObject:object];
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    self.pagination = object;
                }
            }
            
            // Only add posts that are not already on mason grid
            NSMutableArray *newPostsIndexPaths = [NSMutableArray array];
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            [paginationPosts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GTIOPost *post = obj;
                
                post.reviewsButtonTapHandler = ^(id sender) {
                    UIViewController *reviewsViewController;
                    for (id object in post.buttons) {
                        if ([object isMemberOfClass:[GTIOButton class]]) {
                            GTIOButton *button = (GTIOButton *)object;
                            if ([button.name isEqualToString:kGTIOPostSideReviewsButton]) {
                                reviewsViewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.action.destination];
                            }
                        }
                    }
                    [self.navigationController pushViewController:reviewsViewController animated:YES];
                };
                
                if (post.products.count>0){
                    post.shopTheLookButtonTapHandler = ^(id sender) {
                        UIViewController *viewController = [[GTIOShopThisLookViewController alloc] initWithPostID:post.postID];
                        [self.navigationController pushViewController:viewController animated:YES];
                    };
                }

                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID == %@", post.postID];
                NSArray *foundExistingPosts = [self.posts filteredArrayUsingPredicate:predicate];
                if ([foundExistingPosts count] == 0) {
                    [self.posts addObject:post];
                    [newPostsIndexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:[self.posts count] - 1]];
                    [indexSet addIndex:[self.posts count] - 1];
                }
            }];
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.pullToLoadMoreView finishLoading];
            NSLog(@"Failed to load pagination %@. error: %@", loader.resourcePath, [error localizedDescription]);
        };
    }];
}

#pragma mark - Empty

- (void)checkAndDisplayEmptyState
{
    if ([self.posts count] > 0) {
        [self.emptyView removeFromSuperview];
    } else {
        [self.view addSubview:self.emptyView];
        [self.emptyView addGestureRecognizer:self.emptyViewTapGestureRecognizer];
    }
}

#pragma mark - GTIONotificationViewDisplayProtocol methods

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
        [self.notificationsViewController willMoveToParentViewController:self];
        [self addChildViewController:self.notificationsViewController];
        [self.notificationsViewController.view setAlpha:0.0];
        [self.notificationsViewController.view setFrame:(CGRect){ { 0, self.navBarView.frame.size.height }, self.notificationsViewController.view.frame.size} ];
        [self.tableView scrollRectToVisible:(CGRect){0,0,1,1} animated:YES];
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

#pragma mark - SSPullToRefreshDelegate Methods

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self loadFeed];
}

#pragma mark - SSPullToRefreshDelegate Methods

- (void)pullToLoadMoreViewDidStartLoading:(SSPullToLoadMoreView *)view
{
    [self loadPagination];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [GTIOFeedCell cellHeightWithPost:[self.posts objectAtIndex:indexPath.section]];
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    if (self.postUpload && section == 0) {
        self.uploadView.frame = self.uploadView.bounds; // Reset to (0,0) in case you were scrolled down.
        self.uploadView.alpha = 1;
        NSLog(@"UploadView: %@", self.uploadView);
        return self.uploadView;
    }
    
    GTIOPostHeaderView *headerView = [self.offScreenHeaderViews anyObject];

    if (!headerView) {
        headerView = [[GTIOPostHeaderView alloc] initWithFrame:(CGRect){ 0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight }];
    } else {
        [self.offScreenHeaderViews removeObject:headerView];
    }
    headerView.delegate = self;
    
    [headerView setPost:[self.posts objectAtIndex:section]];
    [self.onScreenHeaderViews setValue:headerView forKey:[NSString stringWithFormat:@"%i", section]];
    
    return headerView;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[GTIOFeedCell class]]) {
        GTIOPost *post = [self.posts objectAtIndex:indexPath.section];
        ((GTIOFeedCell *)cell).post = post;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.postUpload && section == 0) {
        return 0;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PostCellIdentifier";
    
    GTIOFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[GTIOFeedCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        cell.frameView.delegate = self;
    }
    
    return cell;
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self headerViewDequeueing];
    [self navBarStyling];
    [self headerSectionViewsStyling];
}

- (void)navBarStyling
{
    CGPoint scrollViewTopPoint = self.tableView.contentOffset;

    if (scrollViewTopPoint.y < 0 && self.tableView.tableHeaderView == self.navBarView) {
        [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:self.tableView.tableHeaderView.bounds]];
        [self.view addSubview:self.navBarView];
        [self.tableView bringSubviewToFront:self.navBarView];
    } else if (scrollViewTopPoint.y > 0 && self.tableView.tableHeaderView != self.navBarView) {
        [self.tableView setTableHeaderView:self.navBarView];
        [self.tableView bringSubviewToFront:self.navBarView];
    }
}

- (void)headerSectionViewsStyling
{
    CGPoint scrollViewTopPoint = self.tableView.contentOffset;
    
    // Section Header
    scrollViewTopPoint.y += self.tableView.sectionHeaderHeight; // Offset by first header
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:scrollViewTopPoint];
    if (indexPath) {
        GTIOPostHeaderView *currentHeaderView = [self.onScreenHeaderViews objectForKey:[NSString stringWithFormat:@"%i", indexPath.section]];
        
        CGRect rectForView = [self.tableView rectForHeaderInSection:indexPath.section];
        NSArray *onScreenViewKeys = [self.onScreenHeaderViews allKeys];
        [onScreenViewKeys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
            GTIOPostHeaderView *headerView = [self.onScreenHeaderViews objectForKey:key];
            if (headerView == currentHeaderView &&
                rectForView.origin.y + self.tableView.sectionHeaderHeight < scrollViewTopPoint.y) {
                
                [headerView setShowingShadow:YES];
                [headerView setClearBackground:NO];
            } else if (headerView == currentHeaderView) {
                [headerView setShowingShadow:NO];
                [headerView setClearBackground:YES];
            } else {
                [headerView setShowingShadow:NO];
                
                // Don't show clear background for cells above current cell
                if (rectForView.origin.y + self.tableView.sectionHeaderHeight > scrollViewTopPoint.y) {
                    [headerView setClearBackground:NO];
                } else {
                    [headerView setClearBackground:YES];
                }
            }
        }];
    }
}

#pragma mark - Header View Dequeue

- (void)headerViewDequeueing
{
    NSArray *visibleCells = [self.tableView visibleCells];
    NSMutableArray *visibleCellSections = [NSMutableArray array];
    
    [visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger section = [self.tableView indexPathForCell:obj].section;
        [visibleCellSections addObject:[NSString stringWithFormat:@"%i", section]];
    }];
    
    // Add padding cells to visible
    if ([visibleCellSections count] > 0) {
        NSInteger firstSection = [[visibleCellSections objectAtIndex:0] intValue];
        NSInteger lastSection = [[visibleCellSections objectAtIndex:[visibleCellSections count] - 1] intValue];
        
        if (firstSection > 0) {
            [visibleCellSections addObject:[NSString stringWithFormat:@"%i", --firstSection]];
        }
        
        if (lastSection < [self.posts count] - 1) {
            [visibleCellSections addObject:[NSString stringWithFormat:@"%i", ++lastSection]];
        }
    }
    
    NSArray *onScreenSectionKeys = [self.onScreenHeaderViews allKeys];
    [onScreenSectionKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![visibleCellSections containsObject:obj]) {
            // Cell not on screen
            GTIOPostHeaderView *postHeaderView = [self.onScreenHeaderViews objectForKey:obj];
            [postHeaderView prepareForReuse];
            
            [self.onScreenHeaderViews removeObjectForKey:obj];
            [self.offScreenHeaderViews addObject:postHeaderView];
        }
    }];
}

#pragma mark - NSNotifications

- (void)openURL:(NSNotification *)notification
{
    NSURL *URL = [[notification userInfo] objectForKey:kGTIOURL];
    if (URL) {
        id viewController = [[GTIORouter sharedRouter] viewControllerForURL:URL];
        if (viewController) {
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@%@:", keyPath, kGTIOKVOSuffix]);
    if ([self respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:change];
        #pragma clang diagnostic pop
    }   
}

- (void)progressValueChanged:(NSDictionary *)change
{
    CGFloat progress = [[change objectForKey:@"new"] floatValue];
    [self.uploadView setProgress:progress];
    NSLog(@"upload view: %@", self.uploadView);
}

- (void)stateValueChanged:(NSDictionary *)change
{
    GTIOPostState postState = [[change objectForKey:@"new"] integerValue];
    
    [self.uploadView setState:postState];
    
    switch (postState) {
        case GTIOPostStateUploadingImage:
            [self addUploadView];
            break;
        case GTIOPostStateUploadingImageComplete:
            break;
        case GTIOPostStateSavingPost:
            break;
        case GTIOPostStateComplete:
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self removeUploadView];
            });
            break;
        }
        case GTIOPostStateError:
            break;
        case GTIOPostStateCancelledImageUpload:
            [self removeUploadView];
            break;
        case GTIOPostStateCancelledPost:
            [self removeUploadView];
            [self.pullToRefreshView startLoading];
            break;
        default:
            break;
    }
}

#pragma mark - Upload View Helpers

- (void)addUploadView
{
    [self.emptyView removeFromSuperview];
    
    if (!self.postUpload) {
        self.postUpload = [[GTIOPostUpload alloc] init];
        [self.tableView setContentOffset:CGPointZero];
        [self.posts insertObject:self.postUpload atIndex:0];
        [self.tableView reloadData];
        // seems like this tableview insertion is causing the ghost cell above the upload cell. Not sure why. 
//        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Go to feed tab
        NSDictionary *userInfo = @{ kGTIOChangeSelectedTabToUserInfo : @(GTIOTabBarTabFeed) };
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOChangeSelectedTabNotification object:nil userInfo:userInfo];
    }
}

- (void)removeUploadView
{
    if (self.postUpload) {
        self.postUpload = nil;
        [self.tableView beginUpdates];
        [self.posts removeObjectAtIndex:0];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        GTIOPost *newPost = [GTIOPostManager sharedManager].post;
        if (newPost) {
            newPost.reviewsButtonTapHandler = ^(id sender) {
                UIViewController *reviewsViewController;
                for (id object in newPost.buttons) {
                    if ([object isMemberOfClass:[GTIOButton class]]) {
                        GTIOButton *button = (GTIOButton *)object;
                        if ([button.name isEqualToString:kGTIOPostSideReviewsButton]) {
                            reviewsViewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.action.destination];
                        }
                    }
                }
                [self.navigationController pushViewController:reviewsViewController animated:YES];
            };

            if (newPost.products.count>0){
                newPost.shopTheLookButtonTapHandler = ^(id sender) {
                    UIViewController *viewController = [[GTIOShopThisLookViewController alloc] initWithPostID:newPost.postID];
                    [self.navigationController pushViewController:viewController animated:YES];
                };
            }
            [self.posts insertObject:newPost atIndex:0];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [self.tableView endUpdates];
        
        // Fixes the pull to refresh going over the nav bar
        double delayInSeconds = 0.36; // This waits till animation is finished then brings nav bar to front
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tableView bringSubviewToFront:self.navBarView];
        });
    }
}

-(void)postHeaderViewTapWithUserId:(NSString *)userID
{
    GTIOProfileViewController *viewController = [[GTIOProfileViewController alloc] initWithNibName:nil bundle:nil];
    [viewController setUserID:userID];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - GTIOFeedCellDelegate

- (void)buttonTap:(GTIOButton *)button
{
    if ([button.buttonType isEqualToString:@"delete"]){
        self.deleteButton = button;
        [[[UIAlertView alloc] initWithTitle:kGTIOAlertTitleForDeletingPost message:kGTIOAlertForDeletingPost delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    } else if (button.action.endpoint) {
        [self endpointRequestForButton:button];
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIODismissEllipsisPopOverViewNotification object:nil];
    } else if (button.action.destination) {
        UIViewController *viewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.action.destination];
        [self.navigationController pushViewController:viewController animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIODismissEllipsisPopOverViewNotification object:nil];
        
    } else if (button.action.twitterText) {
        if ([TWTweetComposeViewController canSendTweet]) {
            GTIOTweetComposer *tweetComposer = [[GTIOTweetComposer alloc] initWithText:button.action.twitterText URL:button.action.twitterURL completionHandler:^(TWTweetComposeViewControllerResult result) {
                    [self dismissModalViewControllerAnimated:YES];

                    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIODismissEllipsisPopOverViewNotification object:nil];
            }];

            [self presentViewController:tweetComposer animated:YES completion:nil];
        } else {
            [[[UIAlertView alloc] initWithTitle:nil message:kGTIONoTwitterMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

            [[NSNotificationCenter defaultCenter] postNotificationName:kGTIODismissEllipsisPopOverViewNotification object:nil];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:kGTIOAlertForDeletingPost]){
        if (buttonIndex == 0){
            [self endpointRequestForButton:self.deleteButton ];
            self.deleteButton = nil;
        }
    }
}

- (void)endpointRequestForButton:(GTIOButton *)button {

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects  = ^(NSArray *loadedObjects) {
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOAlert class]]) {
                   [GTIOErrorController handleAlert:(GTIOAlert *)object showRetryInView:self.view retryHandler:nil];
                }
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:nil];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

@end
