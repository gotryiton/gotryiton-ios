//
//  GTIOProfileCreatedAddStylistsViewController.m
//  GTIO
//
//  Created by Duncan Lewis on 11/10/11.
//  Copyright (c) 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOProfileCreatedAddStylistsViewController.h"

@implementation GTIOProfileCreatedAddStylistsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    UIImageView* bgImage = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(modalBackgroundImage)] autorelease];
	bgImage.frame = CGRectOffset(TTScreenBounds(), 0, -20 - 44);
	[self.view insertSubview:bgImage atIndex:0];
    TT_RELEASE_SAFELY(bgImage);
    
    // user header view
    
    UIImageView* userHeaderBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outfit-navbar.png"]];
    [userHeaderBackground setFrame:CGRectMake(0, 0, 320, 44)];
    
    TTImageView* profileThumbnailView = [[TTImageView alloc] initWithFrame:CGRectMake(5, 5, 34, 34)];
    profileThumbnailView.defaultImage = [UIImage imageNamed:@"empty-profile-pic.png"];
    profileThumbnailView.urlPath = [GTIOUser currentUser].profileIconURL;
    
    UILabel* userNameLabel = [[UILabel alloc] init];
    userNameLabel.frame = CGRectZero;
    userNameLabel.text = [[GTIOUser currentUser].username uppercaseString];
    userNameLabel.font = kGTIOFetteFontOfSize(22);
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.backgroundColor = [UIColor clearColor];
    [userNameLabel sizeToFit];
    userNameLabel.frame = CGRectOffset(userNameLabel.bounds, 45, 6);
    
    UILabel* userLocationLabel = [[UILabel alloc] init];
    userLocationLabel.frame = CGRectZero;
    userLocationLabel.text = [GTIOUser currentUser].location;
    userLocationLabel.font = [UIFont systemFontOfSize:13];
    userLocationLabel.textColor = RGBCOLOR(156,156,156);
    [userLocationLabel sizeToFit];
    userLocationLabel.frame = CGRectMake(45, 25, 200, userLocationLabel.bounds.size.height);
    userLocationLabel.backgroundColor = [UIColor clearColor];
    
    [userHeaderBackground addSubview:profileThumbnailView];
    [userHeaderBackground addSubview:userNameLabel];
    [userHeaderBackground addSubview:userLocationLabel];
    [self.view addSubview:userHeaderBackground];
    
    TT_RELEASE_SAFELY(userNameLabel);
    TT_RELEASE_SAFELY(userLocationLabel);
    TT_RELEASE_SAFELY(userHeaderBackground);
    
    //
    
    UIImageView* congratsBanner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-created-congratulations.png"]];
    [congratsBanner setFrame:CGRectOffset(self.view.frame, 16, 44)];
    [congratsBanner setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:congratsBanner];
    TT_RELEASE_SAFELY(congratsBanner);
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
