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

#import "GTIORouter.h"

@interface GTIOProfileViewController ()

@property (nonatomic, strong) GTIOUIButton *followButton;
@property (nonatomic, strong) GTIOUIButton *followingButton;
@property (nonatomic, strong) GTIOUIButton *requestedButton;
@property (nonatomic, strong) GTIOProfileHeaderView *profileHeaderView;
@property (nonatomic, strong) GTIOUserProfile *userProfile;
@property (nonatomic, strong) GTIODualViewSegmentedControlView *postsHeartsWithSegmentedControlView;

@end

@implementation GTIOProfileViewController

@synthesize followButton = _followButton, followingButton = _followingButton, requestedButton = _requestedButton, profileHeaderView = _profileHeaderView, userID = _userID, userProfile = _userProfile, postsHeartsWithSegmentedControlView = _postsHeartsWithSegmentedControlView;

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

- (void)refreshUserProfileRefreshPostsOnly:(BOOL)refreshPostsOnly
{
    if (!refreshPostsOnly) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self screenEnabled:NO];
    __block typeof(self) blockSelf = self;
    [[GTIOUser currentUser] loadUserProfileWithUserID:self.userID completionHandler:^(NSArray *loadedObjects, NSError *error) {
        [self screenEnabled:YES];
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOUserProfile class]]) {
                    self.userProfile = (GTIOUserProfile *)object;
                    
                    if (!refreshPostsOnly) {
                        [self.profileHeaderView setUserProfile:self.userProfile completionHandler:^(id sender) {
                            [blockSelf.postsHeartsWithSegmentedControlView setItems:blockSelf.userProfile.postsList.posts GTIOPostType:GTIOPostTypeNone userProfile:blockSelf.userProfile];
                            [blockSelf.postsHeartsWithSegmentedControlView setItems:blockSelf.userProfile.heartsList.posts GTIOPostType:GTIOPostTypeHeart userProfile:blockSelf.userProfile];
                            [blockSelf adjustVerticalLayout];
                        }];
                        [self refreshFollowButton];
                    } else {
                        [self.postsHeartsWithSegmentedControlView setItems:self.userProfile.postsList.posts GTIOPostType:GTIOPostTypeNone userProfile:self.userProfile];
                        [self.postsHeartsWithSegmentedControlView setItems:self.userProfile.heartsList.posts GTIOPostType:GTIOPostTypeHeart userProfile:self.userProfile];
                    }
                }
            }
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void)refreshFollowButton
{
    if (self.userProfile.user.button) {
        GTIOUIButton *followButton = nil;
        if ([self.userProfile.user.button.name isEqualToString:kGTIOUserInfoButtonNameFollow]) {
            if ([self.userProfile.user.button.state intValue] == GTIOFollowButtonStateFollowing) {
                followButton = self.followingButton;
            } else if ([self.userProfile.user.button.state intValue] == GTIOFollowButtonStateFollow) {
                followButton = self.followButton;
            } else if ([self.userProfile.user.button.state intValue] == GTIOFollowButtonStateRequested) {
                followButton = self.requestedButton;
            }
            [self setRightNavigationButton:followButton];
        }

        __block typeof(self) blockSelf = self;
        [followButton setTapHandler:^(id sender) {
            [blockSelf screenEnabled:NO];
            [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.userProfile.user.button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
                loader.onDidLoadObjects = ^(NSArray *objects) {
                    [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                    for (id object in objects) {
                        if ([object isMemberOfClass:[GTIOUser class]]) {
                            blockSelf.userProfile.user = (GTIOUser *)object;
                            [blockSelf refreshFollowButton];
                            [blockSelf refreshUserProfileRefreshPostsOnly:NO];
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
    [self refreshUserProfileRefreshPostsOnly:NO];
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

@end
