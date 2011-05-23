//
//  GTIOLauncherViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOHomeViewController.h"
#import "TWTAlertViewDelegate.h"
#import "GTIOBarButtonItem.h"
#import "GTIONotificationsOverlayViewController.h"

@implementation GTIOHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStateChangedNotification:) name:kGTIOUserDidLoginNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStateChangedNotification:) name:kGTIOUserDidLogoutNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationsUpdatedNotification:) name:kGTIONotificationsUpdatedNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(todoBadgeUpdated:) name:kGTIOToDoBadgeUpdatedNotificationName object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_notificationsController release];
    [super dealloc];
}

- (void)updateUserLabel {
    _usernameLabel.text = [GTIOUser currentUser].username;
}

- (void)updateToolbar {
    [self updateUserLabel];
    _loginLogoutButton.title = [GTIOUser currentUser].isLoggedIn ? @"Logout" : @"Login";
}

- (void)updateNotificationsButton {
    NSString* title = [NSString stringWithFormat:@"%d new notifications", [[GTIOUser currentUser].notifications count]];
    [_notificationsButton setTitle:title forState:UIControlStateNormal];
}

- (void)updateTodoBadge {
    NSString* title = [NSString stringWithFormat:@"to-do's (%d)", [[GTIOUser currentUser].todosBadge intValue]];
    [_todoButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateToolbar];
    
    [self updateNotificationsButton];
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

- (IBAction)myStylistsButtonWasPressed {
    TTOpenURL(@"gtio://stylists");
}
- (IBAction)featuredButtonWasPressed {}

- (IBAction)myLooksButtonWasPressed {
    NSString* apiURL = GTIORestResourcePath([NSString stringWithFormat:@"/profile/%@/looks", [GTIOUser currentUser].UID]);
    NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [apiURL stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
    TTOpenURL(url);
}

- (IBAction)uploadButtonWasPressed {
    TTOpenURL(@"gtio://getAnOpinion");
}

- (IBAction)todosButtonWasPressed {}

- (IBAction)browseButtonWasPressed {
    TTOpenURL(@"gtio://browse");
}

- (IBAction)myReviewsButtonWasPressed {
    NSString* apiURL = GTIORestResourcePath([NSString stringWithFormat:@"/profile/%@/reviews", [GTIOUser currentUser].UID]);
    NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [apiURL stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
    TTOpenURL(url);
}

- (IBAction)profileViewWasTouched {
    TTOpenURL(@"gtio://profile");
}

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

- (void)notificationsUpdatedNotification:(NSNotification*)note {
    [self updateNotificationsButton];
}

- (void)todoBadgeUpdated:(NSNotification*)note {
    [self updateTodoBadge];
}

#pragma mark - Notifications View / Button

- (IBAction)notificationButtonWasPressed {
    if (nil == _notificationsController) {
        _notificationsController = [[GTIONotificationsOverlayViewController alloc] initWithStyle:UITableViewStylePlain];
    } else {
        [_notificationsController.tableView reloadData];
    }
    _notificationsController.view.frame = self.view.frame;
    [_notificationsController viewWillAppear:YES];
    [self.view addSubview:_notificationsController.view];
}

@end
