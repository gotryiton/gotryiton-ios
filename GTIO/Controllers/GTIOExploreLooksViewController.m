//
//  GTIOExploreLooksViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/8/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOExploreLooksViewController.h"

#import <RestKit/RestKit.h>

#import "GTIOPagination.h"
#import "GTIOTab.h"
#import "GTIOPost.h"

#import "GTIOLooksSegmentedControlView.h"
#import "GTIONavigationNotificationTitleView.h"
#import "GTIOMasonGridView.h"
#import "GTIOPostHeaderView.h"

#import "GTIONotificationsViewController.h"
#import "GTIORouter.h"

static CGFloat const kGTIOMasonGridPadding = 2.0f;
static CGFloat const kGTIOEmptyStateTopPadding = 178.0f;

@interface GTIOExploreLooksViewController () <SSPullToRefreshViewDelegate, SSPullToLoadMoreViewDelegate>

@property (nonatomic, strong) GTIOLooksSegmentedControlView *segmentedControlView;

@property (nonatomic, strong) NSMutableArray *tabs;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) GTIOPagination *pagination;

@property (nonatomic, strong) GTIOMasonGridView *masonGridView;

@property (nonatomic, strong) UIImageView *emptyImageView;

@property (nonatomic, strong) GTIONavigationNotificationTitleView *navTitleView;

@property (nonatomic, assign, getter = isInitialLoadingFromExternalLink) BOOL initialLoadingFromExternalLink;

@property (nonatomic, assign) BOOL shouldRefreshAfterInactive;

@property (nonatomic, strong) GTIONotificationsViewController *notificationsViewController;

@end

@implementation GTIOExploreLooksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tabs = [NSMutableArray array];
        _posts = [NSMutableArray array];
        _initialLoadingFromExternalLink = NO;
        
        _resourcePath = @"/posts/explore";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnedFromInactive) name:kGTIOAppReturningFromInactiveStateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOFeedControllerShouldRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOAllControllersShouldRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeResourcePathNotification:) name:kGTIOExploreLooksChangeResourcePathNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterLogout) name:kGTIOAllControllersShouldRefreshAfterLogout object:nil];
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
    
    __block typeof(self) blockSelf = self;
    self.navTitleView = [[GTIONavigationNotificationTitleView alloc] initWithTapHandler:^(void) {
        [blockSelf toggleNotificationView:YES];
    }];
    
    // Segmented Control
    self.segmentedControlView = [[GTIOLooksSegmentedControlView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, 50 } }];
    [self.segmentedControlView setSegmentedControlValueChangedHandler:^(GTIOTab *tab) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
        [blockSelf loadDataWithResourcePath:tab.endpoint];
    }];
    [self.view addSubview:self.segmentedControlView];
    
    // Mason Grid
    self.masonGridView = [[GTIOMasonGridView alloc] initWithFrame:(CGRect){ { 0, self.segmentedControlView.frame.size.height }, { self.view.frame.size.width, self.view.frame.size.height - self.segmentedControlView.frame.size.height - self.navigationController.navigationBar.frame.size.height } }];
    [self.masonGridView setPadding:kGTIOMasonGridPadding];
    [self.masonGridView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.masonGridView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.masonGridView setGridItemTapHandler:^(GTIOMasonGridItem *gridItem) {
        id viewController = [[GTIORouter sharedRouter] viewControllerForURLString:gridItem.object.action.destination];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    [self.masonGridView attachPullToRefreshAndPullToLoadMore];
    [self.masonGridView.pullToRefreshView setExpandedHeight:60.0f];
    [self.masonGridView.pullToLoadMoreView setExpandedHeight:0.0f];
    [self.masonGridView setPullToRefreshHandler:^(GTIOMasonGridView *masonGridView, SSPullToRefreshView *pullToRefreshView, BOOL showProgressHUD) {
        [blockSelf loadData];
    }];
    [self.masonGridView setPullToLoadMoreHandler:^(GTIOMasonGridView *masonGridView, SSPullToLoadMoreView *pullToLoadMoreView) {
        [blockSelf loadPagination];
    }];
    [self.masonGridView setPagniationDelegate:self];
    [self.view addSubview:self.masonGridView];
    
    // Accent line
    UIImageView *topAccentLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line.png"]];
    [topAccentLine setFrame:(CGRect){ { self.masonGridView.frame.size.width - kGTIOAccentLinePixelsFromRightSizeOfScreen, self.masonGridView.frame.origin.y }, { topAccentLine.image.size.width, self.masonGridView.frame.size.height } }];
    [self.view addSubview:topAccentLine];
    
    [self.view bringSubviewToFront:self.masonGridView];
    
    if (!self.isInitialLoadingFromExternalLink) {
        [self loadTabs];
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.segmentedControlView = nil;
    self.masonGridView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self useTitleView:self.navTitleView];
    [self.navTitleView forceUpdateCountLabel];
    [self.navTitleView setUserInteractionEnabled:YES];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

#pragma mark - Refresh After Inactive

- (void)appReturnedFromInactive
{
    self.shouldRefreshAfterInactive = YES;
}

- (void)refreshAfterInactive
{
    if(self.shouldRefreshAfterInactive) {
        self.shouldRefreshAfterInactive = NO;
        [self loadTabsAndData];
        // load all the rest here
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOAllControllersShouldRefresh object:nil];
    }
}

#pragma mark - Refresh after Logout

- (void)refreshAfterLogout
{
    [self loadTabsAndData];
}

#pragma mark - Properties

- (void)setResourcePath:(NSString *)resourcePath
{
    _resourcePath = [resourcePath copy];
    [self loadTabsAndData];
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
}

#pragma mark - RestKit Load Objects

- (void)loadTabs
{
    NSLog(@"Loading tabs with resourcePath: %@", self.resourcePath);
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [self.tabs removeAllObjects];
            
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOTab class]]) {
                    [self.tabs addObject:object];
                }
            }
            
            [self.masonGridView.pullToRefreshView finishLoading];
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.segmentedControlView setTabs:self.tabs];
            [self loadData];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.masonGridView.pullToRefreshView finishLoading];
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];

            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                [self loadTabs];
            }];
            NSLog(@"Failed to load /posts/explore. error: %@", [error localizedDescription]);
        };
    }];
}

- (void)loadData
{
    NSLog(@"Loading tabs with resourcePath: %@", self.resourcePath);
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [self.posts removeAllObjects];
            self.pagination = nil;
            
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOPost class]]) {
                    [self.posts addObject:object];
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    self.pagination = object;
                }
            }

            [GTIOProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.masonGridView setItems:self.posts postsType:GTIOPostTypeNone];
            [self checkForEmptyState];
            [self.masonGridView.pullToRefreshView finishLoading];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.masonGridView.pullToRefreshView finishLoading];
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                [self loadTabs];
            }];
            NSLog(@"Failed to load %@. error: %@", self.resourcePath, [error localizedDescription]);
        };
    }];
}

- (void)loadDataWithResourcePath:(NSString *)resourcePath
{
    _resourcePath = [resourcePath copy];
    [self loadData];
}

- (void)loadTabsAndData
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [self.tabs removeAllObjects];
            [self.posts removeAllObjects];
            self.pagination = nil;
            
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOTab class]]) {
                    [self.tabs addObject:object];
                } else if ([object isKindOfClass:[GTIOPost class]]) {
                    [self.posts addObject:object];
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    self.pagination = object;
                }
            }
            
            [self.segmentedControlView setTabs:self.tabs];
            [self.masonGridView setItems:self.posts postsType:GTIOPostTypeNone];
            [self checkForEmptyState];
            [self.masonGridView.pullToRefreshView finishLoading];
            [self loadData];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.masonGridView.pullToRefreshView finishLoading];
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                [self loadTabs];
            }];
            NSLog(@"Failed to load %@. error: %@", self.resourcePath, [error localizedDescription]);
        };
    }];
}

- (void)loadPagination
{
    self.pagination.loading = YES;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.pagination.nextPage usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [self.masonGridView.pullToLoadMoreView finishLoading];
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
            [paginationPosts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GTIOPost *post = obj;
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID == %@", post.postID];
                NSArray *foundExistingPosts = [self.posts filteredArrayUsingPredicate:predicate];
                if ([foundExistingPosts count] == 0) {
                    [self.masonGridView addItem:post postType:GTIOPostTypeNone];
                    [self.posts addObject:post];
                }
            }];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.masonGridView.pullToLoadMoreView finishLoading];
            self.pagination.loading = NO;
            NSLog(@"Failed to load pagination %@. error: %@", loader.resourcePath, [error localizedDescription]);
        };
    }];
}

#pragma mark - GTIOMasonGridViewPaginationDelegate methods

- (void)masonGridViewShouldPagniate:(GTIOMasonGridView *)masonGridView
{
    if(!self.pagination.loading) {
        [[[self masonGridView] pullToLoadMoreView] startLoading];
        [self loadPagination];
    }
}

#pragma mark - Empty State

- (void)checkForEmptyState
{
    if ([self.posts count] == 0) {
        if (!self.emptyImageView) {
            self.emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty.png"]];
            [self.emptyImageView setFrame:(CGRect){ { (self.view.frame.size.width - self.emptyImageView.image.size.width) / 2, self.segmentedControlView.frame.size.height + (self.view.frame.size.height - self.segmentedControlView.frame.size.height - self.emptyImageView.image.size.height ) / 2 }, self.emptyImageView.image.size }];
        }
        [self.view addSubview:self.emptyImageView];
    } else {
        [self.emptyImageView removeFromSuperview];
    }
}

#pragma mark - Notification

- (void)changeResourcePathNotification:(NSNotification *)notification
{
    NSString *resourcePath = [[notification userInfo] objectForKey:kGTIOResourcePathKey];
    NSLog(@"changeResourcePathNotification with path: %@", resourcePath);
    if ([resourcePath length] > 0) {
        self.initialLoadingFromExternalLink = YES;
        _resourcePath = [resourcePath copy];
        [self loadTabs];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
