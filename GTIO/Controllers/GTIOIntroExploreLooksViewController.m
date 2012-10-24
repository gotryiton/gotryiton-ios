//
//  GTIOIntroExploreLooksViewController.m
//  GTIO
//
//  Created by Simon Holroyd on 10/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOIntroExploreLooksViewController.h"

#import <RestKit/RestKit.h>

#import "GTIOPagination.h"
#import "GTIOTab.h"
#import "GTIOPost.h"
#import "GTIOTrack.h"
#import "GTIOConfig.h"
#import "GTIOConfigManager.h"
#import "SDImageCache.h"
#import "GTIOUIButton.h"

#import "GTIOLooksSegmentedControlView.h"
#import "GTIONavigationNotificationTitleView.h"
#import "GTIOMasonGridView.h"
#import "GTIOPostHeaderView.h"

#import "GTIONotificationsViewController.h"
#import "GTIORouter.h"
#import "GTIOFullScreenImageViewer.h"
#import "GTIOSignInViewController.h"

#import "GTIOFailedSignInViewController.h"
#import "GTIOAlmostDoneViewController.h"
#import "GTIOReturningUsersViewController.h"
#import "GTIOQuickAddViewController.h"
#import "GTIOSinglePostViewController.h"

static CGFloat const kGTIOMasonGridPadding = 2.0f;
static CGFloat const kGTIOEmptyStateTopPadding = 178.0f;
static NSString * const kGTIOSignUpButtonSlidUp = @"slide_up";
static NSString * const kGTIOPostInteractionTypePostKey = @"post";
static NSString * const kGTIOPostInteractionTypeZoomKey = @"zoom";
static NSString * const kGTIOPostInteractionTypeNoneKey = @"none";

@interface GTIOIntroExploreLooksViewController () <SSPullToRefreshViewDelegate, SSPullToLoadMoreViewDelegate>

@property (nonatomic, strong) NSMutableArray *tabs;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) GTIOPagination *pagination;

@property (nonatomic, strong) GTIOMasonGridView *masonGridView;

@property (nonatomic, strong) UIImageView *emptyImageView;

@property (nonatomic, strong) GTIONavigationNotificationTitleView *navTitleView;

@property (nonatomic, assign, getter = isInitialLoadingFromExternalLink) BOOL initialLoadingFromExternalLink;

@property (nonatomic, strong) GTIONotificationsViewController *notificationsViewController;
@property (nonatomic, strong) GTIOFullScreenImageViewer *fullScreenImageViewer;
@property (nonatomic, strong) GTIOUIButton *signInButton;
@property (nonatomic, strong) GTIOUIButton *signUpButton;
@property (nonatomic, strong) GTIOUIButton *introOverlay;

@end

@implementation GTIOIntroExploreLooksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tabs = [NSMutableArray array];
        _posts = [NSMutableArray array];
        _initialLoadingFromExternalLink = NO;
        
        _resourcePath = @"/posts/intro-screen";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideIntroOverlay) name:kGTIOHideExploreLooksIntroOverlay object:nil];
        
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

    GTIOConfig *config = [[GTIOConfigManager sharedManager] config];

    // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"login-nav.png"] forBarMetrics:UIBarMetricsDefault];
    // if ([self.navigationController.navigationBar respondsToSelector:@selector(setShadowImage:)]) {
    //     self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    // }

    self.navTitleView = [[GTIONavigationNotificationTitleView alloc] initWithTapHandler:nil];
    [self useTitleView:self.navTitleView];


    // Mason Grid
    self.masonGridView = [[GTIOMasonGridView alloc] initWithFrame:(CGRect){ { 0, 0 }, { self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height } }];
    [self.masonGridView setPadding:kGTIOMasonGridPadding];
    [self.masonGridView setGridItemTapHandler:^(GTIOMasonGridItem *gridItem) {
        if ([config.exploreLooksIntro.postInteractionType isEqualToString:kGTIOPostInteractionTypePostKey]){
            id viewController = [[GTIORouter sharedRouter] viewControllerForURLString:gridItem.object.action.destination];
            [self.navigationController pushViewController:viewController animated:YES];
        } else if ([config.exploreLooksIntro.postInteractionType isEqualToString:kGTIOPostInteractionTypeZoomKey]){
            [blockSelf showFullScreenImage:gridItem.object.photo.mainImageURL];
        } else {
            [blockSelf displaySignInViewController];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOHideExploreLooksIntroOverlay object:nil];
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

    self.signInButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeSignInNav];
    [self.signInButton setFrame:(CGRect){ { (self.view.frame.size.width - self.signInButton.frame.size.width) / 2, 10 }, self.signInButton.frame.size }];
    [self.signInButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [self.signInButton setTapHandler:^(id sender) {
        [blockSelf displaySignInViewController];
    }];
    [self setRightNavigationButton:self.signInButton];

    
    if (config.exploreLooksIntro.signUpButtonImageURL){
        self.signUpButton = [GTIOUIButton  buttonWithGTIOType:GTIOButtonTypeCustom tapHandler:^(id sender) {
            [blockSelf displaySignInViewController];
        }];
        [self.signUpButton setHidden:YES];
        [self.signUpButton setAlpha:0.0];
        [[SDWebImageManager sharedManager] downloadWithURL:config.exploreLooksIntro.signUpButtonImageURL delegate:self options:0 success:^(UIImage *image, BOOL cached) {
            
            [blockSelf.signUpButton setImage:image forState:UIControlStateNormal];
            [blockSelf.signUpButton setImage:image forState:UIControlStateHighlighted];
            
            if ([config.exploreLooksIntro.signUpButtonType isEqualToString:kGTIOSignUpButtonSlidUp]){
                [blockSelf.signUpButton setFrame:(CGRect){{blockSelf.view.frame.size.width - image.size.width/2, blockSelf.view.frame.size.height}, {image.size.width/2, image.size.height/2 }}];
                [blockSelf.signUpButton setAlpha:1.0];
                [blockSelf.signUpButton setHidden:NO];
                [UIView animateWithDuration:0.45
                    delay:0.0
                    options: UIViewAnimationCurveEaseOut
                    animations:^{
                        [blockSelf.signUpButton setFrame:(CGRect){{blockSelf.view.frame.size.width - image.size.width/2, blockSelf.view.frame.size.height - image.size.height/2}, {image.size.width/2, image.size.height/2 }}];
                    }
                    completion:nil];
            } else {
                [blockSelf.signUpButton setFrame:(CGRect){{blockSelf.view.frame.size.width - image.size.width/2, blockSelf.view.frame.size.height - image.size.height/2}, {image.size.width/2, image.size.height/2 }}];
                [blockSelf.signUpButton setAlpha:0.0];
                [blockSelf.signUpButton setHidden:NO];
                [UIView animateWithDuration:0.25
                     animations:^{
                         [blockSelf.signUpButton setAlpha:1.0];
                     }
                     completion:nil];    

            }

            [blockSelf.masonGridView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, image.size.height/2, 0 }];
            [blockSelf.masonGridView setContentInset:(UIEdgeInsets){ 0, 0, image.size.height/2, 0 }];            
            [blockSelf.masonGridView.pullToLoadMoreView setDefaultContentInset:(UIEdgeInsets){ 0, 0, image.size.height/2, 0 }];
        } failure:nil];
        [self.view addSubview:self.signUpButton];
    }
    
    if (config.exploreLooksIntro.introOverlayImageURL){
        self.introOverlay = [GTIOUIButton  buttonWithGTIOType:GTIOButtonTypeCustom tapHandler:^(id sender) {
            [blockSelf hideIntroOverlay];
        }];
        [self.introOverlay setHidden:YES];
        [self.introOverlay setAlpha:0.0];
        [[SDWebImageManager sharedManager] downloadWithURL:config.exploreLooksIntro.introOverlayImageURL delegate:self options:0 success:^(UIImage *image, BOOL cached) {
            [blockSelf.introOverlay setImage:image forState:UIControlStateNormal];
            [blockSelf.introOverlay setImage:image forState:UIControlStateHighlighted];
            [blockSelf.introOverlay setFrame:(CGRect){{blockSelf.view.frame.size.width/2 - image.size.width/4, blockSelf.view.frame.size.height/2 - image.size.height/4 - blockSelf.navTitleView.frame.size.height}, {image.size.width/2, image.size.height/2 } }];
            [blockSelf.introOverlay setHidden:NO];
            [blockSelf fadeInIntroOverlay];
            
        } failure:nil];
        [self.view addSubview:self.introOverlay];
    }

    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // self.segmentedControlView = nil;
    self.masonGridView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];    
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollToTop
{
    [self.masonGridView scrollRectToVisible:(CGRect){0,0,1,1} animated:YES];
}

#pragma mark - GTIONotificationViewDisplayProtocol methods


- (void)displaySignInViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOHideExploreLooksIntroOverlay object:nil];

    GTIOSignInViewController *signInViewController = [[GTIOSignInViewController alloc] initWithNibName:nil bundle:nil];
    // signInViewController.showNavBar = YES;
    signInViewController.showCloseButton = YES;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signInViewController];

    [self presentModalViewController:navigationController animated:YES];
    // [self.navigationController pushViewController:signInViewController animated:YES];
}


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
        [GTIOTrack postTrackWithID:kGTIONotificationViewTrackingId handler:nil];
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

- (void)showFullScreenImage:(NSURL *)url
{    
    self.fullScreenImageViewer = [[GTIOFullScreenImageViewer alloc] initWithPhotoURL:url];
    [self.fullScreenImageViewer show];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOHideExploreLooksIntroOverlay object:nil];
}

- (void)fadeInIntroOverlay
{    
    if (self.introOverlay && !self.introOverlay.hidden && self.posts.count>0){
        NSLog(@"fading in intro overlay");
        [UIView animateWithDuration:0.25
        delay:0.5
        options: UIViewAnimationCurveEaseOut
        animations:^{
            [self.introOverlay setAlpha:1.0];
        }
        completion:nil];
    } else {
        NSLog(@"NOT FADING in intro overlay");
    }
}
- (void)hideIntroOverlay
{    
    if (self.introOverlay){
        [UIView animateWithDuration:0.25
         animations:^{
             [self.introOverlay setAlpha:0.0];
         }
         completion:^(BOOL finished) {
            [self.introOverlay removeFromSuperview];
         }];
    }
}


#pragma mark - RestKit Load Objects

- (void)loadData
{
    NSLog(@"Loading data with resourcePath: %@", self.resourcePath);
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
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self fadeInIntroOverlay];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [self.masonGridView.pullToRefreshView finishLoading];
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:nil];
            NSLog(@"Failed to load %@. error: %@", self.resourcePath, [error localizedDescription]);
        };
    }];
}

- (void)loadDataWithResourcePath:(NSString *)resourcePath
{
    _resourcePath = [resourcePath copy];
    [self loadData];
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
            [self.emptyImageView setFrame:(CGRect){ { (self.view.frame.size.width - self.emptyImageView.image.size.width) / 2, (self.view.frame.size.height - self.emptyImageView.image.size.height ) / 2 }, self.emptyImageView.image.size }];
        }
        [self.view addSubview:self.emptyImageView];
    } else {
        [self.emptyImageView removeFromSuperview];
    }
}


@end
