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

- (void)refreshUserProfile
{
    GTIOUIButton *button = [self activeFollowButton];
    button.enabled = NO;
    
    __block typeof(self) blockSelf = self;
    [[GTIOUser currentUser] refreshUserProfileWithUserID:self.userID completionHandler:^(NSArray *loadedObjects, NSError *error) {
        // [blockSelf screenEnabled:YES];
        if (!error) {
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOUserProfile class]]) {
                    self.userProfile = (GTIOUserProfile *)object;
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

- (GTIOUIButton *)setActiveFollowButtonForState:(NSUInteger)state
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
    return [self setActiveFollowButtonForState:[self.userProfile.user.button.state intValue]];
}

- (void)refreshFollowButton
{
    if (self.userProfile.user.button) {

        GTIOUIButton *followButton = [self activeFollowButton];

        __block typeof(self) blockSelf = self;
        [followButton setTapHandler:^(id sender) {
            // [blockSelf screenEnabled:NO];
            
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
