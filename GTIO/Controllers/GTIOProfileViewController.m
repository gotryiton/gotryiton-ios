//
//  GTIOProfileViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProfileViewController.h"
#import "GTIONavigationNotificationTitleView.h"
#import "GTIOProfileHeaderView.h"
#import "GTIOUserProfile.h"
#import "GTIOSegmentedControl.h"
#import "GTIOProgressHUD.h"
#import "GTIOFollowRequestAcceptBar.h"
#import "GTIOPostMasonryView.h"
#import "GTIODualViewSegmentedControlView.h"

@interface GTIOProfileViewController ()

@property (nonatomic, strong) GTIOButton *followButton;
@property (nonatomic, strong) GTIOButton *followingButton;
@property (nonatomic, strong) GTIOButton *requestedButton;
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
    
    GTIOButton *backButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:backButton];
    
    self.followButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeFollowButtonForNavBar];
    self.followingButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeFollowingButtonForNavBar];
    self.requestedButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeRequestedButtonForNavBar];
    
    self.profileHeaderView = [[GTIOProfileHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 0 }];
    [self.profileHeaderView setDelegate:self];
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
    self.profileHeaderView = nil;
    self.postsHeartsWithSegmentedControlView = nil;
}

- (void)refreshUserProfile
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GTIOUser currentUser] loadUserProfileWithUserID:self.userID completionHandler:^(NSArray *loadedObjects, NSError *error) {
        [self screenEnabled:YES];
        if (!error) {
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOUserProfile class]]) {
                    self.userProfile = (GTIOUserProfile *)object;
                    __block typeof(self) blockSelf = self;
                    [self.profileHeaderView setUserProfile:self.userProfile completionHandler:^(id sender) {
                        [blockSelf.postsHeartsWithSegmentedControlView setPosts:blockSelf.userProfile.postsList.posts GTIOPostType:GTIOPostTypeNone user:blockSelf.userProfile.user];
                        [blockSelf.postsHeartsWithSegmentedControlView setPosts:blockSelf.userProfile.heartsList.posts GTIOPostType:GTIOPostTypeHeart user:blockSelf.userProfile.user];
                        [blockSelf adjustVerticalLayout];
                    }];
                    [self refreshFollowButton];
                    [GTIOProgressHUD hideHUDForView:self.view animated:YES];
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
        GTIOButton *followButton = nil;
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
    [self refreshUserProfile];
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
