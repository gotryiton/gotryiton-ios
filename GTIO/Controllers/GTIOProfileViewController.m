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

@interface GTIOProfileViewController ()

@property (nonatomic, strong) GTIOProfileHeaderView *profileHeaderView;
@property (nonatomic, strong) GTIOUserProfile *userProfile;

@end

@implementation GTIOProfileViewController

@synthesize profileHeaderView = _profileHeaderView, userID = _userID, userProfile = _userProfile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        _profileHeaderView = [[GTIOProfileHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 100 }];
        [self.view addSubview:_profileHeaderView];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.profileHeaderView = nil;
}

- (void)setUserID:(NSString *)userID
{
    _userID = userID;
    [[GTIOUser currentUser] loadUserProfileWithUserID:self.userID completionHandler:^(NSArray *loadedObjects, NSError *error) {
        NSLog(@"%@", loadedObjects);
        for (id object in loadedObjects) {
            if ([object isMemberOfClass:[GTIOUserProfile class]]) {
                self.userProfile = (GTIOUserProfile *)object;
                [self.profileHeaderView setUserProfile:self.userProfile];
            }
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
