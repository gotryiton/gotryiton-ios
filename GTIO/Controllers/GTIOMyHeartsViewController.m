//
//  GTIOMyHeartsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/5/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMyHeartsViewController.h"
#import "GTIOProgressHUD.h"
#import "GTIODualViewSegmentedControlView.h"
#import "GTIOUserProfile.h"

@interface GTIOMyHeartsViewController ()

@property (nonatomic, strong) GTIODualViewSegmentedControlView *segmentedControl;

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *products;

@property (nonatomic, strong) GTIOPagination *heartedPostsPagination;
@property (nonatomic, strong) GTIOPagination *heartedProductsPagination;

@end

@implementation GTIOMyHeartsViewController

@synthesize segmentedControl = _segmentedControl, posts = _posts, products = _products;
@synthesize heartedPostsPagination = _heartedPostsPagination, heartedProductsPagination = _heartedProductsPagination;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"my      \u2019s" italic:YES];
    UIImageView *heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.icon.heart.png"]];
    [heart setFrame:(CGRect){ 23, 11, heart.image.size }];
    [navTitleView addSubview:heart];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    
    self.segmentedControl = [[GTIODualViewSegmentedControlView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } leftControlTitle:@"posts" leftControlPostsType:GTIOPostTypeHeart rightControlTitle:@"products" rightControlPostsType:GTIOPostTypeHeartedProducts];
    [self.view addSubview:self.segmentedControl];
    
    self.posts = [NSMutableArray array];
    self.products = [NSMutableArray array];
    
    __block GTIOMyHeartsViewController *blockSelf = self;
    [self.segmentedControl.leftPostsView.masonGridView setPullToRefreshHandler:^(GTIOMasonGridView *masonGridView, SSPullToRefreshView *pullToRefreshView) {
        [blockSelf loadHeartedPostsWithProgressHUD:NO];
    }];
    [self.segmentedControl.leftPostsView.masonGridView setPullToLoadMoreView:^(GTIOMasonGridView *masonGridView, SSPullToRefreshView *pullToLoadMoreView) {
        [blockSelf loadHeartedPostsPagination];
    }];
//    [self.segmentedControl.rightPostsView.masonGridView setPullToRefreshHandler:^(GTIOMasonGridView *masonGridView, SSPullToRefreshView *pullToRefreshView) {
//        [blockSelf loadHeartedPostsWithProgressHUD:NO];
//    }];
//    [self.segmentedControl.rightPostsView.masonGridView setPullToLoadMoreView:^(GTIOMasonGridView *masonGridView, SSPullToLoadMoreView *pullToLoadMoreView) {
//        [blockSelf loadHeartedPostsPagination];
//    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.segmentedControl = nil;
    self.posts = nil;
    self.products = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Hearted Posts

- (void)loadHeartedPostsWithProgressHUD:(BOOL)showProgressHUD
{
    if (showProgressHUD) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/posts/hearted-by-user/%@", [GTIOUser currentUser].userID] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            NSLog(@"Response: %@", [loader.response bodyAsString]);
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOPost class]]) {
                    [self.posts addObject:object];
                } else if ([object isMemberOfClass:[GTIOPagination class]]) {
                    self.heartedPostsPagination = object;
                }
            }
            [self.segmentedControl setPosts:self.posts GTIOPostType:GTIOPostTypeHeart userProfile:[GTIOUser currentUserProfile]];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (void)loadHeartedPostsPagination
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.heartedPostsPagination.nextPage usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [self.segmentedControl.leftPostsView.masonGridView.pullToLoadMoreView finishLoading];
            self.heartedPostsPagination = nil;
            
            NSMutableArray *paginationHeartedPosts = [NSMutableArray array];
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOPost class]]) {
                    [paginationHeartedPosts addObject:object];
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    self.heartedPostsPagination = object;
                }
            }
            
            // Only add posts that are not already on mason grid
            [paginationHeartedPosts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GTIOPost *post = obj;
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID == %@", post.postID];
                NSArray *foundExistingPosts = [self.posts filteredArrayUsingPredicate:predicate];
                if ([foundExistingPosts count] == 0) {
                    [self.segmentedControl.leftPostsView.masonGridView addPost:post postType:GTIOPostTypeNone];
                    [self.posts addObject:post];
                }
            }];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.segmentedControl.leftPostsView.masonGridView.pullToLoadMoreView finishLoading];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

#pragma mark - Hearted Products

- (void)loadHeartedProductsWithProgressHUD:(BOOL)showProgressHUD
{
    if (showProgressHUD) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/products/hearted-by-user/%@", [GTIOUser currentUser].userID] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            NSLog(@"Response: %@", [loader.response bodyAsString]);
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOPost class]]) {
                    [self.posts addObject:object];
                }
            }
            [self.segmentedControl setPosts:self.products GTIOPostType:GTIOPostTypeHeartedProducts userProfile:[GTIOUser currentUserProfile]];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (void)loadHeartedProductsPagination
{
    NSLog(@"test");
}

@end
