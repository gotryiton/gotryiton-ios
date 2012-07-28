//
//  GTIOSinglePostViewController.m
//  GTIO
//
//  Created by Simon Holroyd on 7/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOSinglePostViewController.h"

#import <RestKit/RestKit.h>
#import "SSPullToRefresh.h"

#import "GTIOPostManager.h"
#import "GTIORouter.h"

#import "GTIOPagination.h"
#import "GTIOPostUpload.h"

#import "GTIOPostHeaderView.h"
#import "GTIOPostUploadView.h"
#import "GTIOFeedCell.h"
#import "GTIONavigationNotificationTitleView.h"
#import "GTIOFeedNavigationBarView.h"
#import "GTIOFriendsViewController.h"
#import "GTIOProfileViewController.h"

#import "GTIOPullToRefreshContentView.h"

#import "GTIOReviewsViewController.h"
#import "GTIONotificationsViewController.h"

#import "GTIOShopThisLookViewController.h"
#import "GTIOShoppingListViewController.h"
#import "GTIOProductNativeListViewController.h"

#import "SSPullToLoadMoreView.h"
#import "GTIOPullToLoadMoreContentView.h"

static NSString * const kGTIOKVOSuffix = @"ValueChanged";
static float const kGTIOPostCellHeightPadding = 55.0f;


@interface GTIOSinglePostViewController () <UITableViewDataSource, UITableViewDelegate, GTIOFeedHeaderViewDelegate, SSPullToRefreshViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GTIOFeedNavigationBarView *navTitleView;
@property (nonatomic, strong) GTIOFeedNavigationBarView *navBarView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) GTIOPagination *pagination;


@property (nonatomic, assign) CGFloat addNavToHeaderOffsetXOrigin;
@property (nonatomic, assign) CGFloat removeNavToHeaderOffsetXOrigin;

@property (nonatomic, strong) NSMutableSet *offScreenHeaderViews;
@property (nonatomic, strong) NSMutableDictionary *onScreenHeaderViews;

@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@property (nonatomic, copy) NSString *postID;
@property (nonatomic, copy) NSString *postsResourcePath;

@property (nonatomic, strong) GTIOPost *post;



@end

@implementation GTIOSinglePostViewController

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

    }
    return self;
}

- (id)initWithPostID:(NSString *)postID
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        NSLog(@"SINGLE POST initWithPostID");
        _postID = postID;
        _postsResourcePath = [NSString stringWithFormat:@"/post/%@", self.postID];
    }
    return self;
}

- (id)initWithPost:(GTIOPost *)post
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        NSLog(@"SINGLE POST initWithPost");
        _post = post;
        _postsResourcePath = [NSString stringWithFormat:@"/post/%@", self.postID];
        [_posts addObject:_post];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView 
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    __block typeof(self) blockSelf = self;
    
    NSLog(@"SINGLE POST viewDidLoad");
    
    GTIONavigationNotificationTitleView *navTitleView = [[GTIONavigationNotificationTitleView alloc] initWithTapHandler:^(void) {
        GTIONotificationsViewController *notificationsViewController = [[GTIONotificationsViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:notificationsViewController];
        [blockSelf presentModalViewController:navigationController animated:YES];
    }];
    [self useTitleView:navTitleView];
    self.navTitleView.backButton.tapHandler = ^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    };
    
     GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];


    


    
    // Single post
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionHeaderHeight:56.0f];
    [self.tableView setSeparatorStyle:UITableViewCellSelectionStyleNone];
    [self.tableView setScrollIndicatorInsets:(UIEdgeInsets){ self.navBarView.frame.size.height, self.navTitleView.frame.size.height, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.tableView setContentInset:(UIEdgeInsets){ 0, self.navTitleView.frame.size.height, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAllowsSelection:NO];
    // [self.tableView setTableHeaderView:self.navBarView];
    [self.view addSubview:self.tableView];
    
   
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    [self.pullToRefreshView setExpandedHeight:60.0f];
    GTIOPullToRefreshContentView *pullToRefreshContentView = [[GTIOPullToRefreshContentView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.bounds.size.width, 0 } }];
    [pullToRefreshContentView setScrollInsets:self.tableView.scrollIndicatorInsets];
    self.pullToRefreshView.contentView = pullToRefreshContentView;

    [self.pullToRefreshView startLoading];

    [self.tableView bringSubviewToFront:self.navBarView];
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES dimScreen:NO];
    
    NSLog(@"pullrefresh: %@", NSStringFromCGRect(self.pullToRefreshView.frame));
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.navBarView = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showStatusBarBackgroundWithoutNavigationBar];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Load Data

- (void)loadFeed
{
    NSLog(@"SINGLE POST loadFeed");
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
            [self.pullToRefreshView finishLoading];
            [self.tableView reloadData];

        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.pullToRefreshView finishLoading];
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"Error: %@", [error localizedDescription]);
            
            // TODO: Display error state
        };
    }];
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


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GTIOFeedCell cellHeightWithPost:[self.posts objectAtIndex:indexPath.section]] + kGTIOPostCellHeightPadding;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{

    
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
        // [self.view addSubview:self.navBarView];
    } else if (scrollViewTopPoint.y > 0 && self.tableView.tableHeaderView != self.navBarView) {
        // [self.tableView setTableHeaderView:self.navBarView];
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



@end
