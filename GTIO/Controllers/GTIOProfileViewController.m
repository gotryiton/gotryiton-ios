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

@interface GTIOProfileViewController ()

@property (nonatomic, strong) GTIOButton *followButton;
@property (nonatomic, strong) GTIOButton *followingButton;
@property (nonatomic, strong) GTIOButton *requestedButton;
@property (nonatomic, strong) GTIOProfileHeaderView *profileHeaderView;
@property (nonatomic, strong) GTIOUserProfile *userProfile;
@property (nonatomic, strong) GTIOSegmentedControl *postsHeartsSegmentedControl;

@end

@implementation GTIOProfileViewController

@synthesize followButton = _followButton, followingButton = _followingButton, requestedButton = _requestedButton, profileHeaderView = _profileHeaderView, userID = _userID, userProfile = _userProfile, postsHeartsSegmentedControl = _postsHeartsSegmentedControl;

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
    [self.view addSubview:self.profileHeaderView];
    
    NSArray *segmentedControlItems = [NSArray arrayWithObjects:@"posts", @"hearts", nil];
    self.postsHeartsSegmentedControl = [[GTIOSegmentedControl alloc] initWithItems:segmentedControlItems];
    [self.postsHeartsSegmentedControl setFrame:CGRectZero];
    [self.postsHeartsSegmentedControl setSelectedSegmentIndex:0];
    [self.postsHeartsSegmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.postsHeartsSegmentedControl];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.followButton = nil;
    self.followingButton = nil;
    self.profileHeaderView = nil;
    self.postsHeartsSegmentedControl = nil;
}

- (void)setUserID:(NSString *)userID
{
    _userID = userID;
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GTIOUser currentUser] loadUserProfileWithUserID:@"0596D58" completionHandler:^(NSArray *loadedObjects, NSError *error) {
        for (id object in loadedObjects) {
            if ([object isMemberOfClass:[GTIOUserProfile class]]) {
                self.userProfile = (GTIOUserProfile *)object;
                [self.profileHeaderView setUserProfile:self.userProfile completionHandler:^(id sender) {
                    [self.postsHeartsSegmentedControl setFrame:(CGRect){ 0, self.profileHeaderView.frame.origin.y + self.profileHeaderView.bounds.size.height, self.view.bounds.size.width, 30 }];
                }];
                [self refreshFollowButton];
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            }
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
        
        [followButton setTapHandler:^(id sender) {
            [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
            [[GTIOUser currentUser] hitEndpoint:self.userProfile.user.button.action.endpoint completionHandler:^(NSArray *loadedObjects, NSError *error) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                if (!error) {
                    for (id object in loadedObjects) {
                        if ([object isMemberOfClass:[GTIOUser class]]) {
                            self.userProfile.user = (GTIOUser *)object;
                            [self refreshFollowButton];
                        }
                    }
                } else {
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }];
    }
}

- (void)segmentedControlChanged:(id)sender
{
    GTIOSegmentedControl *segmentedControl = (GTIOSegmentedControl *)sender;
    NSLog(@"changed to index: %i", segmentedControl.selectedSegmentIndex);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
