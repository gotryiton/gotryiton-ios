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

@interface GTIOFeedViewController () <UITableViewDataSource, UITableViewDelegate, GTIOFeedHeaderViewDelegate, GTIOFeedCellDelegate, SSPullToRefreshViewDelegate, SSPullToLoadMoreViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GTIOFeedNavigationBarView *navBarView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) GTIOPagination *pagination;

@property (nonatomic, strong) GTIOPostUpload *postUpload;
@property (nonatomic, strong) GTIOPostUploadView *uploadView;

@property (nonatomic, assign) CGFloat addNavToHeaderOffsetXOrigin;
@property (nonatomic, assign) CGFloat removeNavToHeaderOffsetXOrigin;

@property (nonatomic, strong) NSMutableSet *offScreenHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *onScreenHeaderViews;

@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) SSPullToLoadMoreView *pullToLoadMoreView;

@property (nonatomic, copy) NSString *postID;
@property (nonatomic, copy) NSString *postsResourcePath;

@property (nonatomic, strong) GTIOPost *post;

@property (nonatomic, strong) UIImageView *emptyView;
@property (nonatomic, strong) UITapGestureRecognizer *emptyViewTapGestureRecognizer;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openURL:) name:kGTIOPostFeedOpenLinkNotification object:nil];
        
        [[GTIOPostManager sharedManager] addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:NULL];
        [[GTIOPostManager sharedManager] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (id)initWithPostID:(NSString *)postID
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _postID = postID;
    }
    return self;
}

- (id)initWithPost:(GTIOPost *)post
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _post = post;
        
        [_posts addObject:_post];
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
    
    self.navBarView = [[GTIOFeedNavigationBarView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, 44 } }];
    
    __block typeof(self) blockSelf = self;
    
    if (self.post || [self.postID length] > 0) {
        // Single post
        self.navBarView.backButton.tapHandler = ^(id sender) {
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        [self.navBarView.backButton setHidden:NO];
        [self.navBarView.friendsButton setHidden:YES];
    } else {
        // Normal Feed
        [self.navBarView.friendsButton setTapHandler:^(id sender) {
            GTIOFriendsViewController *friendsViewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFriends];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
            [blockSelf presentModalViewController:navController animated:YES];
        }];
    }
    self.navBarView.titleView.tapHandler = ^(void) {
        GTIONotificationsViewController *notificationsViewController = [[GTIONotificationsViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:notificationsViewController];
        [blockSelf presentModalViewController:navigationController animated:YES];
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
    
    [self.pullToRefreshView startLoading];
    
    [self.tableView bringSubviewToFront:self.navBarView];
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES dimScreen:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.navBarView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self showStatusBarBackgroundWithoutNavigationBar];
    [self.tableView bringSubviewToFront:self.navBarView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Load Data

- (void)loadFeed
{
    [self.emptyView removeGestureRecognizer:self.emptyViewTapGestureRecognizer]; // So you can't tap it multiple times

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.postsResourcePath usingBlock:^(RKObjectLoader *loader) {
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

#pragma mark - SSPullToRefreshDelegate Methods

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    if (self.post) {
        // Inited w/ post. No need to hit endpoint
        [self.tableView reloadData];
        [self.pullToRefreshView finishLoading];
    } else {
        if (self.postID) {
            self.postsResourcePath = [NSString stringWithFormat:@"/post/%@", self.postID];
        } else {
            self.postsResourcePath = @"/posts/feed";
        }
        [self loadFeed];
    }
}

#pragma mark - SSPullToRefreshDelegate Methods

- (void)pullToLoadMoreViewDidStartLoading:(SSPullToLoadMoreView *)view
{
    [self loadPagination];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GTIOFeedCell cellHeightWithPost:[self.posts objectAtIndex:indexPath.section]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    if (self.postUpload && section == 0) {
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
    } else if (scrollViewTopPoint.y > 0 && self.tableView.tableHeaderView != self.navBarView) {
        [self.tableView setTableHeaderView:self.navBarView];
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
        case GTIOPostStateCancelled:
            [self removeUploadView];
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
        [self.posts insertObject:self.postUpload atIndex:0];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView setContentOffset:CGPointZero];
        
        // Go to feed tab
        NSDictionary *userInfo = @{ kGTIOChangeSelectedTabToUserInfo : @(GTIOTabBarTabFeed) };
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOChangeSelectedTabNotification object:nil userInfo:userInfo];
    }
}

- (void)removeUploadView
{
    if (self.postUpload) {
        self.postUpload = nil;
        [self.posts removeObjectAtIndex:0];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        GTIOPost *newPost = [GTIOPostManager sharedManager].post;
        if (newPost) {
            [self.posts insertObject:newPost atIndex:0];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            // Fixes the pull to refresh going over the nav bar
            double delayInSeconds = 0.01;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.view bringSubviewToFront:self.navBarView];
            });
        }
    }
}

-(void) postHeaderViewTapWithUserId:(NSString *)userID
{
    GTIOProfileViewController *viewController = [[GTIOProfileViewController alloc] initWithNibName:nil bundle:nil];
    [viewController setUserID:userID];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - GTIOFeedCellDelegate

- (void)buttonTap:(GTIOButton *)button
{
    if (button.action.endpoint) {
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

@end
