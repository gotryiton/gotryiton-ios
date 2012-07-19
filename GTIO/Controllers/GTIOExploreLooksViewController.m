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

#import "GTIOFeedViewController.h"
#import "GTIONotificationsViewController.h"

static CGFloat const kGTIOMasonGridPadding = 2.0f;
static CGFloat const kGTIOEmptyStateTopPadding = 178.0f;

@interface GTIOExploreLooksViewController () <SSPullToRefreshViewDelegate, SSPullToLoadMoreViewDelegate>

@property (nonatomic, strong) GTIOLooksSegmentedControlView *segmentedControlView;

@property (nonatomic, strong) NSMutableArray *tabs;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) GTIOPagination *pagination;

@property (nonatomic, strong) GTIOMasonGridView *masonGridView;

@property (nonatomic, strong) UIImageView *emptyImageView;

@end

@implementation GTIOExploreLooksViewController

@synthesize segmentedControlView = _segmentedControlView;
@synthesize tabs = _tabs, posts = _posts, pagination = _pagination;
@synthesize resourcePath = _resourcePath;
@synthesize masonGridView = _masonGridView;
@synthesize emptyImageView = _emptyImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tabs = [NSMutableArray array];
        _posts = [NSMutableArray array];
        
        _resourcePath = @"/posts/explore";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block typeof(self) blockSelf = self;
    GTIONavigationNotificationTitleView *navTitleView = [[GTIONavigationNotificationTitleView alloc] initWithTapHandler:^(void) {
        GTIONotificationsViewController *notificationsViewController = [[GTIONotificationsViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:notificationsViewController];
        [blockSelf presentModalViewController:navigationController animated:YES];
    }];
    [self useTitleView:navTitleView];
    
    // Segmented Control
    self.segmentedControlView = [[GTIOLooksSegmentedControlView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, 50 } }];
    [self.segmentedControlView setSegmentedControlValueChangedHandler:^(GTIOTab *tab) {
        [blockSelf loadDataWithResourcePath:tab.endpoint];
    }];
    [self.view addSubview:self.segmentedControlView];
    
    // Mason Grid
    self.masonGridView = [[GTIOMasonGridView alloc] initWithFrame:(CGRect){ { 0, self.segmentedControlView.frame.size.height }, { self.view.frame.size.width, self.view.frame.size.height - self.segmentedControlView.frame.size.height - self.navigationController.navigationBar.frame.size.height } }];
    [self.masonGridView setPadding:kGTIOMasonGridPadding];
    [self.masonGridView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.masonGridView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.masonGridView setGridItemTapHandler:^(GTIOMasonGridItem *gridItem) {
#warning USE ROUTE HERE
//        GTIOFeedViewController *feedViewController = [[GTIOFeedViewController alloc] initWithPost:gridItem.post];
//        [self.navigationController pushViewController:feedViewController animated:YES];
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
    [self.view addSubview:self.masonGridView];
    
    // Accent line
    UIImageView *topAccentLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line.png"]];
    [topAccentLine setFrame:(CGRect){ { self.masonGridView.frame.size.width - kGTIOAccentLinePixelsFromRightSizeOfScreen, self.masonGridView.frame.origin.y }, { topAccentLine.image.size.width, self.masonGridView.frame.size.height } }];
    [self.view addSubview:topAccentLine];
    
    [self.view bringSubviewToFront:self.masonGridView];
    
    [self loadTabs];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.segmentedControlView = nil;
    self.masonGridView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
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
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.masonGridView.pullToRefreshView finishLoading];
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"Failed to load /posts/explore. error: %@", [error localizedDescription]);
        };
    }];
}

- (void)loadData
{
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

            [self.masonGridView setPosts:self.posts postsType:GTIOPostTypeNone];
            [self checkForEmptyState];
            [self.masonGridView.pullToRefreshView finishLoading];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.masonGridView.pullToRefreshView finishLoading];
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
            [self.masonGridView setPosts:self.posts postsType:GTIOPostTypeNone];
            [self checkForEmptyState];
            [self.masonGridView.pullToRefreshView finishLoading];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.masonGridView.pullToRefreshView finishLoading];
            NSLog(@"Failed to load %@. error: %@", self.resourcePath, [error localizedDescription]);
        };
    }];
}

- (void)loadPagination
{
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
                    [self.masonGridView addPost:post postType:GTIOPostTypeNone];
                    [self.posts addObject:post];
                }
            }];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.masonGridView.pullToLoadMoreView finishLoading];
            NSLog(@"Failed to load pagination %@. error: %@", loader.resourcePath, [error localizedDescription]);
        };
    }];
}

#pragma mark - Empty State

- (void)checkForEmptyState
{
    if ([self.posts count] == 0) {
        if (!self.emptyImageView) {
            self.emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty.png"]];
            [self.emptyImageView setFrame:(CGRect){ { (self.view.frame.size.width - self.emptyImageView.image.size.width) / 2, kGTIOEmptyStateTopPadding }, self.emptyImageView.image.size }];
        }
        [self.view addSubview:self.emptyImageView];
    } else {
        [self.emptyImageView removeFromSuperview];
    }
}

@end
