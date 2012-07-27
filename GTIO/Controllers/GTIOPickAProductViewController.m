//
//  GTIOPickAProductViewController.m
//  GTIO
//
//  Created by Scott Penrose on 7/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPickAProductViewController.h"

#import "GTIOUserProfile.h"
#import "GTIOUser.h"

#import "GTIOProgressHUD.h"
#import "GTIODualViewSegmentedControlView.h"

#import "GTIORouter.h"

@interface GTIOPickAProductViewController ()

@property (nonatomic, strong) GTIODualViewSegmentedControlView *segmentedControl;

@property (nonatomic, strong) NSMutableArray *heartedProducts;
@property (nonatomic, strong) NSMutableArray *popularProducts;

@property (nonatomic, strong) GTIOPagination *heartedProductsPagination;
@property (nonatomic, strong) GTIOPagination *popularProductsPagination;

@end

@implementation GTIOPickAProductViewController

@synthesize segmentedControl = _segmentedControl;
@synthesize heartedProducts = _heartedProducts, popularProducts = _popularProducts;
@synthesize heartedProductsPagination = _heartedProductsPagination, popularProductsPagination = _popularProductsPagination;
@synthesize startingProductType = _startingProductType;
@synthesize didSelectProductHandler = _didSelectProductHandler;

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
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"pick a product" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissModalViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    
    self.segmentedControl = [[GTIODualViewSegmentedControlView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } leftControlTitle:kGTIOMyHeartsTitle leftControlPostsType:GTIOPostTypeHeartedProducts rightControlTitle:@"products" rightControlPostsType:GTIOPostTypeNone];
    [self.view addSubview:self.segmentedControl];
    
    self.heartedProducts = [NSMutableArray array];
    self.popularProducts = [NSMutableArray array];
    
    __block typeof(self) blockSelf = self;
    
    // My Hearted Products Handlers
    [self.segmentedControl.leftPostsView.masonGridView setPullToRefreshHandler:^(GTIOMasonGridView *masonGridView, SSPullToRefreshView *pullToRefreshView, BOOL showProgressHUD) {
        [blockSelf loadHeartedProductsWithProgressHUD:showProgressHUD];
    }];
    [self.segmentedControl.leftPostsView.masonGridView setPullToLoadMoreHandler:^(GTIOMasonGridView *masonGridView, SSPullToLoadMoreView *pullToLoadMoreView) {
        [blockSelf loadHeartedProductsPagination];
    }];
    [self.segmentedControl.leftPostsView.masonGridView setGridItemTapHandler:^(GTIOMasonGridItem *masonGridItem) {
        if (self.didSelectProductHandler) {
            self.didSelectProductHandler(masonGridItem.object);
        }
    }];
    
    // Popular Products Handlers
    [self.segmentedControl.rightPostsView.masonGridView setPullToRefreshHandler:^(GTIOMasonGridView *masonGridView, SSPullToRefreshView *pullToRefreshView, BOOL showProgressHUD) {
        [blockSelf loadPopularProductsWithProgressHUD:showProgressHUD];
    }];
    [self.segmentedControl.rightPostsView.masonGridView setPullToLoadMoreHandler:^(GTIOMasonGridView *masonGridView, SSPullToLoadMoreView *pullToLoadMoreView) {
        [blockSelf loadPopularProductsPagination];
    }];
    [self.segmentedControl.rightPostsView.masonGridView setGridItemTapHandler:^(GTIOMasonGridItem *masonGridItem) {
        if (self.didSelectProductHandler) {
            self.didSelectProductHandler(masonGridItem.object);
        }
    }];
    
    // Initial load
    [self.segmentedControl.rightPostsView setHidden:YES];
    [self.segmentedControl.leftPostsView setHidden:YES];
    GTIOPostMasonryView *startingMasonryView = nil;
    switch (self.startingProductType) {
        case GTIOProductTypePopular:
            startingMasonryView = self.segmentedControl.rightPostsView;
            [self.segmentedControl.dualViewSegmentedControl setSelectedSegmentIndex:1];
            break;
        case GTIOProductTypeHearted:
        default:
            startingMasonryView = self.segmentedControl.leftPostsView;
            [self.segmentedControl.dualViewSegmentedControl setSelectedSegmentIndex:0];
            break;
    }
    
    [startingMasonryView setHidden:NO]; // This will start a item load
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.segmentedControl = nil;
    self.heartedProducts = nil;
    self.popularProducts = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Hearted Posts

- (void)loadHeartedProductsWithProgressHUD:(BOOL)showProgressHUD
{
    if (showProgressHUD) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/products/post-options/hearted" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.segmentedControl.leftPostsView.masonGridView.pullToRefreshView finishLoading];
            
            [self.heartedProducts removeAllObjects];
            
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOProduct class]]) {
                    [self.heartedProducts addObject:object];
                } else if ([object isMemberOfClass:[GTIOPagination class]]) {
                    self.heartedProductsPagination = object;
                }
            }
            [self.segmentedControl setItems:self.heartedProducts GTIOPostType:GTIOPostTypeHeartedProducts userProfile:[GTIOUser currentUserProfile]];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.segmentedControl.leftPostsView.masonGridView.pullToRefreshView finishLoading];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (void)loadHeartedProductsPagination
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.heartedProductsPagination.nextPage usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [self.segmentedControl.leftPostsView.masonGridView.pullToLoadMoreView finishLoading];
            self.heartedProductsPagination = nil;
            
            NSMutableArray *paginationHeartedProducts = [NSMutableArray array];
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOProduct class]]) {
                    [paginationHeartedProducts addObject:object];
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    self.heartedProductsPagination = object;
                }
            }
            
            // Only add posts that are not already on mason grid
            [paginationHeartedProducts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GTIOProduct *product = obj;
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productID == %@", product.productID];
                NSArray *foundExistingProducts = [self.heartedProducts filteredArrayUsingPredicate:predicate];
                if ([foundExistingProducts count] == 0) {
                    [self.segmentedControl.rightPostsView.masonGridView addItem:product postType:GTIOPostTypeNone];
                    [self.heartedProducts addObject:product];
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

- (void)loadPopularProductsWithProgressHUD:(BOOL)showProgressHUD
{
    if (showProgressHUD) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/products/post-options/popular" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.segmentedControl.rightPostsView.masonGridView.pullToRefreshView finishLoading];
            
            [self.popularProducts removeAllObjects];
            
            for (id object in objects) {
                if ([object isMemberOfClass:[GTIOProduct class]]) {
                    [self.popularProducts addObject:object];
                } else if ([object isMemberOfClass:[GTIOPagination class]]) {
                    self.popularProductsPagination = object;
                }
            }
            [self.segmentedControl setItems:self.popularProducts GTIOPostType:GTIOPostTypeNone userProfile:[GTIOUser currentUserProfile]];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.segmentedControl.rightPostsView.masonGridView.pullToRefreshView finishLoading];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (void)loadPopularProductsPagination
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.heartedProductsPagination.nextPage usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [self.segmentedControl.rightPostsView.masonGridView.pullToLoadMoreView finishLoading];
            self.heartedProductsPagination = nil;
            
            NSMutableArray *paginationHeartedProducts = [NSMutableArray array];
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOProduct class]]) {
                    [paginationHeartedProducts addObject:object];
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    self.heartedProductsPagination = object;
                }
            }
            
            // Only add posts that are not already on mason grid
            [paginationHeartedProducts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GTIOProduct *product = obj;
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productID == %@", product.productID];
                NSArray *foundExistingProducts = [self.popularProducts filteredArrayUsingPredicate:predicate];
                if ([foundExistingProducts count] == 0) {
                    [self.segmentedControl.rightPostsView.masonGridView addItem:product postType:GTIOPostTypeNone];
                    [self.popularProducts addObject:product];
                }
            }];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.segmentedControl.rightPostsView.masonGridView.pullToLoadMoreView finishLoading];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}


@end
