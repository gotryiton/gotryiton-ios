//
//  GTIOFeedViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/15/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFeedViewController.h"

#import <RestKit/RestKit.h>

#import "GTIOPostManager.h"
#import "GTIORouter.h"

#import "GTIOPost.h"
#import "GTIOPagination.h"
#import "GTIOPostUpload.h"

#import "GTIOPostHeaderView.h"
#import "GTIOPostUploadView.h"
#import "GTIOFeedCell.h"
#import "GTIONavigationNotificationTitleView.h"
#import "GTIOFeedNavigationBarView.h"
#import "GTIOFriendsViewController.h"

static NSString * const kGTIOKVOSuffix = @"ValueChanged";

@interface GTIOFeedViewController () <UITableViewDataSource, UITableViewDelegate>

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

@end

@implementation GTIOFeedViewController

@synthesize tableView = _tableView, navBarView = _navBarView;
@synthesize addNavToHeaderOffsetXOrigin = _addNavToHeaderOffsetXOrigin, removeNavToHeaderOffsetXOrigin = _removeNavToHeaderOffsetXOrigin;
@synthesize posts = _posts, pagination = _pagination;
@synthesize offScreenHeaderViews = _offScreenHeaderViews, onScreenHeaderViews = _onScreenHeaderViews;
@synthesize uploadView = _uploadView, postUpload = _postUpload;

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    
    UIImageView *statusBarBackgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ { 0, -20 }, { self.view.frame.size.width, 20 } }];
    [statusBarBackgroundImageView setImage:[UIImage imageNamed:@"status-bar-bg.png"]];
    [self.view addSubview:statusBarBackgroundImageView];
    
    self.navBarView = [[GTIOFeedNavigationBarView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, 44 } }];
    __block typeof(self) blockSelf = self;
    [self.navBarView.friendsButton setTapHandler:^(id sender) {
        GTIOFriendsViewController *friendsViewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFriends];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
        [blockSelf presentModalViewController:navController animated:YES];
    }];
    
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

    self.uploadView = [[GTIOPostUploadView alloc] initWithFrame:(CGRect){ CGPointZero, { self.tableView.bounds.size.width, self.tableView.sectionHeaderHeight } }];
    
    [self loadFeed];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Load Data

- (void)loadFeed
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/posts/feed" usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.onDidLoadObjects = ^(NSArray *objects) {            
            [self.posts removeAllObjects];
            
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOPost class]])
                {
                    [self.posts addObject:object];
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    self.pagination = object;
                }
            }
            
            [self.tableView reloadData];
            [self headerSectionViewsStyling];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        };
    }];
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
    } else if (scrollViewTopPoint.y >= 0 && self.tableView.tableHeaderView != self.navBarView) {
        [self.tableView setTableHeaderView:self.navBarView];
    }
}

- (void)headerSectionViewsStyling
{
    CGPoint scrollViewTopPoint = self.tableView.contentOffset;
    
    // Section Header
    scrollViewTopPoint.y += self.tableView.sectionHeaderHeight; // Offset by first header
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:scrollViewTopPoint];
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
    if (!self.postUpload) {
        self.postUpload = [[GTIOPostUpload alloc] init];
        [self.posts insertObject:self.postUpload atIndex:0];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        }
    }
}

@end
