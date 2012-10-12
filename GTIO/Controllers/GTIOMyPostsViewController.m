//
//  GTIOMyPostsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMyPostsViewController.h"
#import "GTIOProgressHUD.h"
#import <RestKit/RestKit.h>
#import "GTIOUser.h"
#import "GTIOPostMasonryView.h"
#import "GTIOProgressHUD.h"
#import "GTIORouter.h"

static CGFloat const kGTIOEmptyStateTopPadding = 178.0f;

@interface GTIOMyPostsViewController ()

@property (nonatomic, strong) GTIOPostMasonryView *postMasonGrid;
@property (nonatomic, strong) NSMutableArray *posts;

@property (nonatomic, assign) GTIOPostType postsType;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) GTIOPagination *pagination;
@property (nonatomic, copy) NSString *resourcePath;

@property (nonatomic, strong) UIImageView *emptyImageView;

@end

@implementation GTIOMyPostsViewController

@synthesize postMasonGrid = _postMasonGrid, posts = _posts, postsType = _postsType, userID = _userID;

- (id)initWithGTIOPostType:(GTIOPostType)postsType forUserID:(NSString *)userID
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
        _postsType = postsType;
        _userID = (userID.length > 0) ? userID : [GTIOUser currentUser].userID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block typeof(self) blockSelf = self;

    NSString *title;
    if (self.postsType == GTIOPostTypeNone) {
        title = [NSString stringWithFormat:@"%@posts", ([self.userID isEqualToString:[GTIOUser currentUser].userID]) ? @"my " : @""];
    } else if (self.postsType == GTIOPostTypeStar) {
        title = [NSString stringWithFormat:@"%@stars", ([self.userID isEqualToString:[GTIOUser currentUser].userID]) ? @"my " : @""];
    }
    
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:title italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        [self.postMasonGrid.masonGridView cancelAllItemDownloads];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    
    self.postMasonGrid = [[GTIOPostMasonryView alloc] initWithGTIOPostType:self.postsType];
    [self.postMasonGrid setFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height }];

    [self.postMasonGrid.masonGridView setGridItemTapHandler:^(GTIOMasonGridItem *gridItem) {
        id viewController = [[GTIORouter sharedRouter] viewControllerForURLString:gridItem.object.action.destination];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    [self.postMasonGrid.masonGridView attachPullToRefreshAndPullToLoadMore];
    [self.postMasonGrid.masonGridView.pullToRefreshView setExpandedHeight:60.0f];
    [self.postMasonGrid.masonGridView.pullToLoadMoreView setExpandedHeight:0.0f];
    [self.postMasonGrid.masonGridView setPullToRefreshHandler:^(GTIOMasonGridView *masonGridView, SSPullToRefreshView *pullToRefreshView, BOOL showProgressHUD) {
        [blockSelf loadData];
    }];
    [self.postMasonGrid.masonGridView setPullToLoadMoreHandler:^(GTIOMasonGridView *masonGridView, SSPullToLoadMoreView *pullToLoadMoreView) {
        [blockSelf loadPagination];
    }];

    [self.view addSubview:self.postMasonGrid];
    
    self.posts = [NSMutableArray array];
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    _resourcePath = [NSString stringWithFormat:@"posts/by-user/%@", self.userID];
    if (self.postsType == GTIOPostTypeStar) {
        _resourcePath = [NSString stringWithFormat:@"posts/stars-by-user/%@", self.userID];
    }

    [self loadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.postMasonGrid = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
            [self.postMasonGrid setItems:self.posts userProfile:[GTIOUser currentUserProfile]];
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.postMasonGrid.masonGridView.pullToRefreshView finishLoading];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.postMasonGrid.masonGridView.pullToRefreshView finishLoading];
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                [self loadData];
            }];
            NSLog(@"Failed to load %@. error: %@", self.resourcePath, [error localizedDescription]);
        };
    }];
}

- (void)loadPagination
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.pagination.nextPage usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [self.postMasonGrid.masonGridView.pullToLoadMoreView finishLoading];
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
                    [self.postMasonGrid.masonGridView addItem:post postType:GTIOPostTypeNone];
                    [self.posts addObject:post];
                }
            }];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.postMasonGrid.masonGridView.pullToLoadMoreView finishLoading];
            NSLog(@"Failed to load pagination %@. error: %@", loader.resourcePath, [error localizedDescription]);
        };
    }];
}



@end
