//
//  GTIOHomeViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 Two Toasters. All rights reserved.
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
    _profileThumbnailView.defaultImage = [UIImage imageNamed:@"empty-profile-pic.png"];
    if (nil == _nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_nameLabel];
        [_nameLabel release];
    }
    if (nil == _locationLabel){
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_locationLabel];
        [_locationLabel release];
    }
    if ([GTIOUser currentUser].loggedIn) {
        _profileThumbnailView.urlPath = [GTIOUser currentUser].profileIconURL;
        
        _nameLabel.frame = CGRectZero;
        _nameLabel.text = [[GTIOUser currentUser].username uppercaseString];
        _nameLabel.font = kGTIOFetteFontOfSize(21);
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_nameLabel sizeToFit];
        _nameLabel.frame = CGRectOffset(_nameLabel.bounds, 49, 7);
        
        _locationLabel.frame = CGRectZero;
        _locationLabel.text = [GTIOUser currentUser].location;
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.textColor = RGBCOLOR(114,114,114);
        [_locationLabel sizeToFit];
        _locationLabel.frame = CGRectMake(50, 24, 200, _locationLabel.bounds.size.height);
        _locationLabel.backgroundColor = [UIColor clearColor];
        
    } else {
        _profileThumbnailView.urlPath = nil;
        
        _nameLabel.text = @"my profile";
        _nameLabel.textColor = RGBCOLOR(185,185,185);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [_nameLabel sizeToFit];
        _nameLabel.frame = CGRectOffset(_nameLabel.bounds, 50, 12);
        
        _locationLabel.text = @"";
    }
}

- (void)updateToolbar {
    [self updateUserLabel];
}

- (void)updateNotificationsButton {
    if ([[GTIOUser currentUser] numberOfUnseenNotifications] == 0) {
        [_notificationsBadgeButton setTitle:@"" forState:UIControlStateNormal];
        [_notificationsBadgeButton setSelected:NO];
        [_notificationsButton setTitle:@"notifications" forState:UIControlStateNormal];
    } else {
        NSString* title = [NSString stringWithFormat:@"new notification%@", ([[GTIOUser currentUser] numberOfUnseenNotifications] == 1 ? @"" : @"s")];
        [_notificationsButton setTitle:title forState:UIControlStateNormal];
        [_notificationsBadgeButton setTitle:[NSString stringWithFormat:@"%d", [[GTIOUser currentUser] numberOfUnseenNotifications]] forState:UIControlStateNormal];
        [_notificationsBadgeButton setSelected:YES];
        
    }
    
}

- (void)updateTodoBadge {
    if ([[GTIOUser currentUser].todosBadge intValue] > 0) {
        _todosBadgeButton.hidden = NO;
    } else {
        _todosBadgeButton.hidden = YES;
    }
    NSString* title = [NSString stringWithFormat:@"%d", [[GTIOUser currentUser].todosBadge intValue]];
    [_todosBadgeButton setTitle:title forState:UIControlStateNormal];
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
    // HRM.. don't really want to do this if we are presenting a modal view controller
    UINavigationController* navController = self.navigationController;
    if (nil == navController.modalViewController) {
        [navController setNavigationBarHidden:NO animated:animated];
    }
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

- (IBAction)todosButtonWasPressed {
    TTOpenURL(@"gtio://todos");
}

- (IBAction)browseButtonWasPressed {
    TTOpenURL(@"gtio://browse");
}

- (IBAction)myReviewsButtonWasPressed {
    NSString* apiURL = GTIORestResourcePath([NSString stringWithFormat:@"/profile/%@/reviews", [GTIOUser currentUser].UID]);
    NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [apiURL stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
    TTOpenURL(url);
}

- (IBAction)profileViewWasTouched {
    if ([[GTIOUser currentUser] isLoggedIn]) {
        TTOpenURL(@"gtio://profile");
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
        [_notificationsController invalidateModel];
    }
    _notificationsController.view.frame = CGRectOffset(self.view.frame,0,480);
    [self.view addSubview:_notificationsController.view];
    [_notificationsController viewWillAppear:YES];
    [UIView beginAnimations:nil context:nil];
    _notificationsController.view.frame = self.view.frame;
    [UIView commitAnimations];
}

@end
