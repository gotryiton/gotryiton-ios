//
//  GTIOProfileViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProfileViewController.h"
#import "GTIONavigationNotificationTitleView.h"
#import "GTIOUserProfile.h"
#import "GTIOSegmentedControl.h"
#import "GTIOProgressHUD.h"
#import "GTIOFollowRequestAcceptBar.h"
#import "GTIOPostMasonryView.h"
#import "GTIODualViewSegmentedControlView.h"
#import "GTIOPagination.h"
#import "GTIOHeart.h"
#import "GTIOFullScreenImageViewer.h"
#import "GTIORouter.h"

@interface GTIOProfileViewController ()

@property (nonatomic, strong) GTIOUIButton *followButton;
@property (nonatomic, strong) GTIOUIButton *followingButton;
@property (nonatomic, strong) GTIOUIButton *requestedButton;
@property (nonatomic, strong) GTIOProfileHeaderView *profileHeaderView;
@property (nonatomic, strong) GTIOUserProfile *userProfile;
@property (nonatomic, strong) GTIODualViewSegmentedControlView *postsHeartsWithSegmentedControlView;
@property (nonatomic, strong) GTIOFullScreenImageViewer *fullScreenImageViewer;
@property (nonatomic, strong) NSString *heartsResourcePath;
@property (nonatomic, strong) NSString *postsResourcePath;

@end

@implementation GTIOProfileViewController

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

    __block typeof(self) blockSelf = self;

    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"profile" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        [self.postsHeartsWithSegmentedControlView.leftPostsView.masonGridView cancelAllItemDownloads];
        [self.postsHeartsWithSegmentedControlView.rightPostsView.masonGridView cancelAllItemDownloads];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    
    self.followButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeFollowButtonForNavBar];
    self.followingButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeFollowingButtonForNavBar];
    self.requestedButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeRequestedButtonForNavBar];

    self.profileHeaderView = [[GTIOProfileHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 0 }];
    [self.profileHeaderView setDelegate:self];
    [self.profileHeaderView setAcceptBarDelegate:self];
    [self.profileHeaderView setMeTableHeaderViewDelegate:self];
    [self.profileHeaderView setProfileOpenURLHandler:^(NSURL *URL) {
        id viewController = [[GTIORouter sharedRouter] viewControllerForURL:URL];
        if (viewController) {
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            [[UIApplication sharedApplication] openURL:URL];
        }
    }];
    [self.view addSubview:self.profileHeaderView];
    
    self.postsHeartsWithSegmentedControlView = [[GTIODualViewSegmentedControlView alloc] 
                                                initWithFrame:CGRectZero 
                                                leftControlTitle:@"posts" 
                                                leftControlPostsType:GTIOPostTypeNone 
                                                rightControlTitle:@"hearts" 
                                                rightControlPostsType:GTIOPostTypeHeart];
    [self.view addSubview:self.postsHeartsWithSegmentedControlView];

    [self.postsHeartsWithSegmentedControlView.leftPostsView.masonGridView setGridItemTapHandler:^(GTIOMasonGridItem *gridItem) {
        id viewController = [[GTIORouter sharedRouter] viewControllerForURLString:gridItem.object.action.destination];
        [self.navigationController pushViewController:viewController animated:YES];
    }];

    [self.postsHeartsWithSegmentedControlView.rightPostsView.masonGridView setGridItemTapHandler:^(GTIOMasonGridItem *gridItem) {
        id viewController = [[GTIORouter sharedRouter] viewControllerForURLString:gridItem.object.action.destination];
        [self.navigationController pushViewController:viewController animated:YES];
    }];

    [self.postsHeartsWithSegmentedControlView.leftPostsView.masonGridView.pullToRefreshView setExpandedHeight:60.0f];
    [self.postsHeartsWithSegmentedControlView.rightPostsView.masonGridView.pullToRefreshView setExpandedHeight:60.0f];
    [self.postsHeartsWithSegmentedControlView.leftPostsView.masonGridView.pullToLoadMoreHandler setExpandedHeight:0.0f];
    [self.postsHeartsWithSegmentedControlView.rightPostsView.masonGridView.pullToLoadMoreHandler setExpandedHeight:0.0f];

    [self.postsHeartsWithSegmentedControlView.leftPostsView.masonGridView  setPullToRefreshHandler:^(GTIOMasonGridView *masonGridView, SSPullToRefreshView *pullToRefreshView, BOOL showProgressHUD) {
        [blockSelf loadDataForPostType:GTIOPostTypeNone];
    }];
    [self.postsHeartsWithSegmentedControlView.rightPostsView.masonGridView  setPullToRefreshHandler:^(GTIOMasonGridView *masonGridView, SSPullToRefreshView *pullToRefreshView, BOOL showProgressHUD) {
        [blockSelf loadDataForPostType:GTIOPostTypeHeart];
    }];
    
    [self.postsHeartsWithSegmentedControlView.leftPostsView.masonGridView setPullToLoadMoreHandler:^(GTIOMasonGridView *masonGridView, SSPullToLoadMoreView *pullToLoadMoreView) {
        [blockSelf loadPaginationForPostType:GTIOPostTypeNone];
        
    }];

    [self.postsHeartsWithSegmentedControlView.rightPostsView.masonGridView setPullToLoadMoreHandler:^(GTIOMasonGridView *masonGridView, SSPullToLoadMoreView *pullToLoadMoreView) {
        [blockSelf loadPaginationForPostType:GTIOPostTypeHeart];
    }];

    if (self.userID !=nil && (self.userProfile==nil || self.userProfile.postsList==nil || self.userProfile.heartsList==nil)) {
        [self loadUserProfile];
    } else if (self.userID) {
        __block typeof(self) blockSelf = self;
        [self.profileHeaderView setUserProfile:self.userProfile completionHandler:^(id sender) {
            [blockSelf.postsHeartsWithSegmentedControlView setItems:blockSelf.userProfile.postsList.posts GTIOPostType:GTIOPostTypeNone userProfile:blockSelf.userProfile];
            [blockSelf.postsHeartsWithSegmentedControlView setItems:blockSelf.userProfile.heartsList.hearts GTIOPostType:GTIOPostTypeHeart userProfile:blockSelf.userProfile];
            [blockSelf adjustVerticalLayout];
        }];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.followButton = nil;
    self.followingButton = nil;
    self.requestedButton = nil;
    self.profileHeaderView = nil;
    self.postsHeartsWithSegmentedControlView = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [GTIOProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];   
    
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadUserProfile
{
    GTIOUIButton *button = [self activeFollowButton];
    button.enabled = NO;
    
    __block typeof(self) blockSelf = self;
    [[GTIOUser currentUser] loadUserProfileWithUserID:self.userID completionHandler:^(NSArray *loadedObjects, NSError *error) {
        if (!error) {
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOUserProfile class]]) {
                    self.userProfile = (GTIOUserProfile *)object;
                    [self.profileHeaderView setUserProfile:self.userProfile completionHandler:^(id sender) {
                        [blockSelf.postsHeartsWithSegmentedControlView setItems:blockSelf.userProfile.postsList.posts GTIOPostType:GTIOPostTypeNone userProfile:blockSelf.userProfile];
                        [blockSelf.postsHeartsWithSegmentedControlView setItems:blockSelf.userProfile.heartsList.hearts GTIOPostType:GTIOPostTypeHeart userProfile:blockSelf.userProfile];
                        [blockSelf adjustVerticalLayout];
                    }];
                    [self refreshFollowButton];
                }
            }
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}
- (void)refreshUserProfile
{
    GTIOUIButton *button = [self activeFollowButton];
    button.enabled = NO;
    
    __block typeof(self) blockSelf = self;
    [[GTIOUser currentUser] refreshUserProfileWithUserID:self.userID completionHandler:^(NSArray *loadedObjects, NSError *error) {
        if (!error) {
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOUserProfile class]]) {
                    GTIOUserProfile *newProfile = (GTIOUserProfile *)object;
                    newProfile.postsList = self.userProfile.postsList;
                    newProfile.heartsList = self.userProfile.heartsList;
                    self.userProfile = newProfile;

                    [self.profileHeaderView setUserProfile:self.userProfile completionHandler:^(id sender) {
                        [blockSelf adjustVerticalLayout];
                    }];
                    [self refreshFollowButton];
                
                }
            }
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (GTIOUIButton *)setActiveFollowButtonForState:(GTIOFollowButtonState)state
{
    GTIOUIButton *followButton = nil;

    self.followingButton.hidden = YES;
    [self.followingButton hideSpinner];
    self.followButton.hidden = YES;
    [self.followButton hideSpinner];
    self.requestedButton.hidden = YES;
    [self.requestedButton hideSpinner];

    if (state == GTIOFollowButtonStateFollowing) {
        followButton = self.followingButton;
    } else if (state == GTIOFollowButtonStateFollow) {
        followButton = self.followButton;
    } else if (state == GTIOFollowButtonStateRequested) {
        followButton = self.requestedButton;
    }
    [self setRightNavigationButton:followButton];
    
    followButton.hidden = NO;
    followButton.enabled = YES;

    return followButton;
}

- (GTIOUIButton *)activeFollowButton
{
    if (self.userProfile.user.button!=nil)
        return [self setActiveFollowButtonForState:[self.userProfile.user.button.state intValue]];
    return nil;
}

- (void)refreshFollowButton
{
    if (self.userProfile.user.button) {

        GTIOUIButton *followButton = [self activeFollowButton];

        __block typeof(self) blockSelf = self;
        [followButton setTapHandler:^(id sender) {
           
            GTIOUIButton *button = (GTIOUIButton *) sender;
            button.enabled = NO;
            [button showSpinner];
            [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.userProfile.user.button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
                loader.onDidLoadObjects = ^(NSArray *objects) {
                    
                    [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                    [button hideSpinner];
                    for (id object in objects) {
                        if ([object isMemberOfClass:[GTIOUser class]]) {
                            
                            blockSelf.userProfile.user = (GTIOUser *)object;
                            [blockSelf setActiveFollowButtonForState:[blockSelf.userProfile.user.button.state intValue]];
                            [blockSelf refreshUserProfile];
                        }
                    }
                };
                loader.onDidFailWithError = ^(NSError *error) {
                    [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"%@", [error localizedDescription]);
                };
            }];
        }];
    }
}

- (void)setUserID:(NSString *)userID
{
    _userID = userID;
    _heartsResourcePath = [NSString stringWithFormat:@"/posts/hearted-by-user/%@", _userID];
    _postsResourcePath = [NSString stringWithFormat:@"/posts/by-user/%@", _userID];
    [self loadUserProfile];
}

- (void)screenEnabled:(BOOL)enabled
{
    [self.view setUserInteractionEnabled:enabled];
    [self.navigationController.view setUserInteractionEnabled:enabled];
}

- (void)acceptBarRemoved
{
    [self adjustVerticalLayout];
}

- (void)adjustVerticalLayout
{
    [self.postsHeartsWithSegmentedControlView setFrame:(CGRect){ 0, self.profileHeaderView.frame.origin.y + self.profileHeaderView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.profileHeaderView.bounds.size.height }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)loadDataForPostType:(GTIOPostType)postType
{
    __block typeof(self) blockSelf = self;
    __block GTIOMasonGridView *gridView = (postType==GTIOPostTypeHeart) ? self.postsHeartsWithSegmentedControlView.rightPostsView.masonGridView : self.postsHeartsWithSegmentedControlView.leftPostsView.masonGridView;
    __block GTIOPostList *postsList = self.userProfile.postsList ;
    __block GTIOHeartList *heartsList = self.userProfile.heartsList;

    __block GTIOPagination *pagination = (postType==GTIOPostTypeHeart) ? self.userProfile.heartsList.pagination : self.userProfile.postsList.pagination;
    
    
    NSString *resourcePath = (postType==GTIOPostTypeHeart) ? self.heartsResourcePath : self.postsResourcePath;
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {

            [postsList.posts removeAllObjects];
            pagination = nil;
            
            
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOPost class]]) {
                    [postsList.posts addObject:object];                    
                } else if ([object isKindOfClass:[GTIOHeart class]]) {
                    [heartsList.hearts addObject:object];
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    postsList.pagination = object;
                }
            }
            if (postsList.posts.count>0){
                [blockSelf.postsHeartsWithSegmentedControlView setItems:postsList.posts GTIOPostType:GTIOPostTypeNone userProfile:blockSelf.userProfile];
            }
            if (heartsList.hearts.count>0){
                [blockSelf.postsHeartsWithSegmentedControlView setItems:heartsList.hearts GTIOPostType:GTIOPostTypeHeart userProfile:blockSelf.userProfile];
            }
            
            
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [gridView.pullToRefreshView finishLoading];
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [gridView.pullToRefreshView finishLoading];
            NSLog(@"Failed to load %@. error: %@", resourcePath, [error localizedDescription]);
        };
    }];
}

- (void)loadPaginationForPostType:(GTIOPostType)postType
{

    __block GTIOMasonGridView *gridView = (postType==GTIOPostTypeHeart) ? self.postsHeartsWithSegmentedControlView.rightPostsView.masonGridView : self.postsHeartsWithSegmentedControlView.leftPostsView.masonGridView;
    __block GTIOPostList *postsList = self.userProfile.postsList ;
    __block GTIOHeartList *heartsList = self.userProfile.heartsList;
    __block GTIOPagination *pagination = (postType==GTIOPostTypeHeart) ? self.userProfile.heartsList.pagination : self.userProfile.postsList.pagination;
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:pagination.nextPage usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            
            
            [gridView.pullToLoadMoreView finishLoading];
            [gridView setNeedsLayout];

            pagination = nil;
            
            NSMutableArray *paginationPosts = [NSMutableArray array];
            NSMutableArray *paginationHearts = [NSMutableArray array];
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOPost class]]) {
                    [paginationPosts addObject:object];
                } else if ([object isKindOfClass:[GTIOHeart class]]) {
                    [paginationHearts addObject:object];                    
                } else if ([object isKindOfClass:[GTIOPagination class]]) {
                    postsList.pagination = object;
                }
            }
            

            // Only add posts that are not already on mason grid
            [paginationPosts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GTIOPost *post = obj;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID == %@", post.postID];
                NSArray *foundExistingPosts = [postsList.posts filteredArrayUsingPredicate:predicate];
                
                if ([foundExistingPosts count] == 0) {
                    [gridView addItem:post postType:postType];
                    [postsList.posts addObject:post];
                }
            }];
            // Only add hearts that are not already on mason grid
            [paginationHearts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GTIOHeart *heart = obj;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"heartID == %i", heart.heartID];
                NSArray *foundExistingHearts = [heartsList.hearts filteredArrayUsingPredicate:predicate];
                
                if ([foundExistingHearts count] == 0) {
                    [gridView addItem:heart postType:postType];
                    [heartsList.hearts addObject:heart];
                }
            }];
        };
        loader.onDidFailWithError = ^(NSError *error) {
           [gridView.pullToLoadMoreView finishLoading];
            NSLog(@"Failed to load pagination %@. error: %@", loader.resourcePath, [error localizedDescription]);
        };
    }];
}



- (void)bannerTapWithUrl:(NSString *)url
{
    UIViewController *viewController = [[GTIORouter sharedRouter] viewControllerForURLString:url];
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([GTIORouter sharedRouter].fullScreenImageURL) {
        self.fullScreenImageViewer = [[GTIOFullScreenImageViewer alloc] initWithPhotoURL:[GTIORouter sharedRouter].fullScreenImageURL];
        [self.fullScreenImageViewer show];
    }
}

@end
