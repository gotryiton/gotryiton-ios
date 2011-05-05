//
//  GTIOLauncherViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOLauncherViewController.h"
#import "TWTAlertViewDelegate.h"

@implementation GTIOLauncherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStateChangedNotification:) name:kGTIOUserDidLoginNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStateChangedNotification:) name:kGTIOUserDidLogoutNotificationName object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)updateUserLabel {
    _usernameLabel.text = [GTIOUser currentUser].username;
}

- (void)updateToolbar {
    [self updateUserLabel];
    _loginLogoutButton.title = [GTIOUser currentUser].isLoggedIn ? @"Logout" : @"Login";
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateToolbar];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Actions

- (IBAction)myStylistsButtonWasPressed {}
- (IBAction)featuredButtonWasPressed {}

- (IBAction)myLooksButtonWasPressed {
    NSString* looksURL = [NSString stringWithFormat:@"gtio://user_looks/%@", [GTIOUser currentUser].UID];
    TTOpenURL(looksURL);
}

- (IBAction)uploadButtonWasPressed {
    TTOpenURL(@"gtio://getAnOpinion");
}

- (IBAction)todosButtonWasPressed {}
- (IBAction)browseButtonWasPressed {}
- (IBAction)myReviewsButtonWasPressed {
    NSString* reviewsURL = [NSString stringWithFormat:@"gtio://user_reviews/%@", [GTIOUser currentUser].UID];
    TTOpenURL(reviewsURL);
}
- (IBAction)notificationButtonWasPressed {}
- (IBAction)profileViewWasTouched {}

- (IBAction)logoutButtonWasPressed {
    if ([[GTIOUser currentUser] isLoggedIn]) {
        TWTAlertViewDelegate* delegate = [[TWTAlertViewDelegate new] autorelease];
        [delegate setTarget:[GTIOUser currentUser] selector:@selector(logout) object:nil forButtonIndex:1];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure?" delegate:delegate cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
        [alert release];
    } else {
        TTOpenURL(@"gtio://login");
    }
}

#pragma mark - Notifications

- (void)userStateChangedNotification:(NSNotification*)note {
    [self updateToolbar];
}

@end
