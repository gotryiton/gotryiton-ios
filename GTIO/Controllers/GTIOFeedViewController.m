//
//  GTIOFeedViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/15/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFeedViewController.h"

#import <RestKit/RestKit.h>

#import "GTIORouter.h"

#import "GTIOPost.h"
#import "GTIOPagination.h"

#import "GTIOPostHeaderView.h"
#import "GTIOFeedCell.h"
#import "GTIONavigationNotificationTitleView.h"
#import "GTIOFeedNavigationBarView.h"

@interface GTIOFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GTIOFeedNavigationBarView *navBarView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) GTIOPagination *pagination;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _posts = [NSMutableArray array];
        
        _offScreenHeaderViews = [NSMutableSet set];
        _onScreenHeaderViews = [NSMutableDictionary dictionary];
        
        _addNavToHeaderOffsetXOrigin = -44.0f;
        _removeNavToHeaderOffsetXOrigin = 0.0f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openURL:) name:kGTIOPostFeedOpenLinkNotification object:nil];
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
    
    self.navBarView = [[GTIOFeedNavigationBarView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, 44 } }];
    [self.navBarView.friendsButton setTapHandler:^(id sender) {
        NSLog(@"Friends button tapped");
    }];
    [self.view addSubview:self.navBarView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionHeaderHeight:56.0f];
    [self.tableView setSeparatorStyle:UITableViewCellSelectionStyleNone];
    [self.tableView setScrollIndicatorInsets:(UIEdgeInsets){ self.navBarView.frame.size.height, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.tableView setContentInset:self.tableView.scrollIndicatorInsets];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAllowsSelection:NO];
    [self.view addSubview:self.tableView];
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
    [self loadFeed];
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
            
#warning This is used for testing.
//            // Manually add post
//            GTIOPost *post = [[GTIOPost alloc] init];
//            post.postID = @"123";
//            post.photo = ((GTIOPost *)[self.posts objectAtIndex:4]).photo;
//            post.createdWhen = @"2 weeks";
//            post.stared = NO;
//            post.user = [GTIOUser currentUser];
//            [self.posts addObject:post];
#warning end test
            
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
    [self headerSectionViewsStyling];
}

- (void)headerSectionViewsStyling
{
    CGPoint scrollViewTopPoint = self.tableView.contentOffset;
    
    // Nav Bar
//    NSLog(@"Content offset: %@", NSStringFromCGPoint(scrollViewTopPoint));
    if ((scrollViewTopPoint.y <= self.removeNavToHeaderOffsetXOrigin) && self.tableView.tableHeaderView) {
        [self.tableView setContentInset:(UIEdgeInsets){ self.navBarView.frame.size.height, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
        [self.tableView setTableHeaderView:nil];
        [self.view addSubview:self.navBarView];
        self.addNavToHeaderOffsetXOrigin = -0;
        self.removeNavToHeaderOffsetXOrigin = -44.0;
    } else if (scrollViewTopPoint.y > self.addNavToHeaderOffsetXOrigin && !self.tableView.tableHeaderView) {
        [self.tableView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
        [self.navBarView removeFromSuperview];
        [self.tableView setTableHeaderView:self.navBarView];
        self.addNavToHeaderOffsetXOrigin = -44;
        self.removeNavToHeaderOffsetXOrigin = 0;
    }
    
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

@end
