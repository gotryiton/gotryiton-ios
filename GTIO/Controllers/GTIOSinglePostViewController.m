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
@property (nonatomic, strong) GTIOPagination *pagination;

@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@property (nonatomic, copy) NSString *postID;
@property (nonatomic, strong) GTIOPost *post;
@property (nonatomic, copy) NSString *postsResourcePath;

@property (nonatomic, assign, getter = isInitialLoad) BOOL initialLoad;

@end

@implementation GTIOSinglePostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _initialLoad = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openURL:) name:kGTIOPostFeedOpenLinkNotification object:nil];
    }
    return self;
}

- (id)initWithPostID:(NSString *)postID
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _postID = postID;
        _postsResourcePath = [NSString stringWithFormat:@"/post/%@", self.postID];
    }
    return self;
}

- (id)initWithPost:(GTIOPost *)post
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _post = post;
        _postsResourcePath = [NSString stringWithFormat:@"/post/%@", self.postID];
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
    
    GTIONavigationNotificationTitleView *navTitleView = [[GTIONavigationNotificationTitleView alloc] initWithTapHandler:^(void) {
        GTIONotificationsViewController *notificationsViewController = [[GTIONotificationsViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:notificationsViewController];
        [blockSelf presentModalViewController:navigationController animated:YES];
    }];
    [self useTitleView:navTitleView];

     GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];

    // Single post
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height } } style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionHeaderHeight:56.0f];
    [self.tableView setSeparatorStyle:UITableViewCellSelectionStyleNone];
    [self.tableView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.tableView setContentInset:(UIEdgeInsets){ 0, 0, 0, 0 }];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAllowsSelection:NO];
    [self.view addSubview:self.tableView];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    [self.pullToRefreshView setExpandedHeight:60.0f];
    GTIOPullToRefreshContentView *pullToRefreshContentView = [[GTIOPullToRefreshContentView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.bounds.size.width, 0 } }];
    [pullToRefreshContentView setScrollInsets:self.tableView.scrollIndicatorInsets];
    self.pullToRefreshView.contentView = pullToRefreshContentView;

    [self.pullToRefreshView startLoading];

    [self.tableView bringSubviewToFront:self.navBarView];
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES dimScreen:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.navBarView = nil;
    self.tableView = nil;
    self.pullToRefreshView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Properties

- (void)setPost:(GTIOPost *)post
{
    _post = post;
    self.postID = _post.postID;
}

#pragma mark - Load Data

- (void)loadFeed
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.postsResourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.onDidLoadObjects = ^(NSArray *objects) {
            self.post = nil;
            
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOPost class]] && !self.post) {
                    self.post = (GTIOPost *)object;
                    self.post.reviewsButtonTapHandler = ^(id sender) {
                        UIViewController *reviewsViewController;
                        for (id object in self.post.buttons) {
                            if ([object isMemberOfClass:[GTIOButton class]]) {
                                GTIOButton *button = (GTIOButton *)object;
                                if ([button.name isEqualToString:kGTIOPostSideReviewsButton]) {
                                    reviewsViewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.action.destination];
                                }
                            }
                        }
                        [self.navigationController pushViewController:reviewsViewController animated:YES];
                    };
                    
                    GTIOPostHeaderView *headerView = [[GTIOPostHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.tableView.bounds.size.width, self.tableView.sectionHeaderHeight }];
                    [headerView setDelegate:self];
                    [headerView setPost:self.post];
                    [self.tableView setTableHeaderView:headerView];
                    
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
            [GTIOErrorController handleError:error showRetryInView:self.view retryHandler:^(GTIORetryHUD *retryHUD) {
                [self loadFeed];
            }];
        };
    }];
}


#pragma mark - SSPullToRefreshDelegate Methods

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    if (self.post && self.isInitialLoad) {
        // Inited w/ post. No need to hit endpoint
        [self.tableView reloadData];
        [self.pullToRefreshView finishLoading];
        self.initialLoad = NO;
    } else if (self.postID) {
        self.postsResourcePath = [NSString stringWithFormat:@"/post/%@", self.postID];
        self.initialLoad = NO;
        [self loadFeed];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GTIOFeedCell cellHeightWithPost:self.post] + kGTIOPostCellHeightPadding;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[GTIOFeedCell class]]) {
        ((GTIOFeedCell *)cell).post = self.post;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.post) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.post) {
        return 1;
    }
    return 0;
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

-(void) postHeaderViewTapWithUserId:(NSString *)userID
{
    GTIOProfileViewController *viewController = [[GTIOProfileViewController alloc] initWithNibName:nil bundle:nil];
    [viewController setUserID:userID];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
