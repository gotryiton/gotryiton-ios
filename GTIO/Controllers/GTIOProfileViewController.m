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

@interface GTIOProfileViewController ()

@property (nonatomic, strong) GTIOButton *followButton;
@property (nonatomic, strong) GTIOButton *followingButton;
@property (nonatomic, strong) GTIOButton *requestedButton;
@property (nonatomic, strong) GTIOProfileHeaderView *profileHeaderView;
@property (nonatomic, strong) GTIOUserProfile *userProfile;
@property (nonatomic, strong) GTIOSegmentedControl *postsHeartsSegmentedControl;
@property (nonatomic, strong) GTIOPostMasonryView *postsView;
@property (nonatomic, strong) GTIOPostMasonryView *heartsView;

@end

@implementation GTIOProfileViewController

@synthesize followButton = _followButton, followingButton = _followingButton, requestedButton = _requestedButton, profileHeaderView = _profileHeaderView, userID = _userID, userProfile = _userProfile, postsHeartsSegmentedControl = _postsHeartsSegmentedControl, postsView = _postsView, heartsView = _heartsView;

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
    
    NSArray *segmentedControlItems = [NSArray arrayWithObjects:@"posts", @"hearts", nil];
    self.postsHeartsSegmentedControl = [[GTIOSegmentedControl alloc] initWithItems:segmentedControlItems];
    [self.postsHeartsSegmentedControl setFrame:CGRectZero];
    [self.postsHeartsSegmentedControl setSelectedSegmentIndex:0];
    [self.postsHeartsSegmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.postsHeartsSegmentedControl];
    
    self.postsView = [[GTIOPostMasonryView alloc] initWithGTIOPostType:GTIOPostTypeNone];
    [self.view addSubview:self.postsView];
    self.heartsView = [[GTIOPostMasonryView alloc] initWithGTIOPostType:GTIOPostTypeHeart];
    self.heartsView.hidden = YES;
    [self.view addSubview:self.heartsView];
    
    [self.view sendSubviewToBack:self.postsView];
    [self.view sendSubviewToBack:self.heartsView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.followButton = nil;
    self.followingButton = nil;
    self.profileHeaderView = nil;
    self.postsHeartsSegmentedControl = nil;
    self.postsView = nil;
    self.heartsView = nil;
}

- (void)segmentedControlChanged:(id)sender
{
    GTIOSegmentedControl *segmentedControl = (GTIOSegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.heartsView.hidden = YES;
        self.postsView.hidden = NO;
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        self.heartsView.hidden = NO;
        self.postsView.hidden = YES;
    }
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
                        [blockSelf.postsView setPosts:blockSelf.userProfile.postsList.posts user:blockSelf.userProfile.user];
                        [blockSelf.heartsView setPosts:blockSelf.userProfile.heartsList.posts user:blockSelf.userProfile.user];
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
            [[GTIOUser currentUser] hitEndpoint:self.userProfile.user.button.action.endpoint completionHandler:^(NSArray *loadedObjects, NSError *error) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                if (!error) {
                    for (id object in loadedObjects) {
                        if ([object isMemberOfClass:[GTIOUser class]]) {
                            blockSelf.userProfile.user = (GTIOUser *)object;
                            [blockSelf refreshFollowButton];
                            [blockSelf refreshUserProfile];
                        }
                    }
                } else {
                    NSLog(@"%@", [error localizedDescription]);
                }
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
    [self.postsHeartsSegmentedControl setFrame:(CGRect){ 0, self.profileHeaderView.frame.origin.y + self.profileHeaderView.bounds.size.height, self.view.bounds.size.width, 30 }];
    [self.postsView setFrame:(CGRect){ 0, self.postsHeartsSegmentedControl.frame.origin.y + self.postsHeartsSegmentedControl.bounds.size.height - 4, self.view.bounds.size.width, self.view.bounds.size.height - self.postsHeartsSegmentedControl.frame.origin.y - self.postsHeartsSegmentedControl.bounds.size.height + 3 }];
    [self.heartsView setFrame:(CGRect){ 0, self.postsHeartsSegmentedControl.frame.origin.y + self.postsHeartsSegmentedControl.bounds.size.height - 4, self.view.bounds.size.width, self.view.bounds.size.height - self.postsHeartsSegmentedControl.frame.origin.y - self.postsHeartsSegmentedControl.bounds.size.height + 3 }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
