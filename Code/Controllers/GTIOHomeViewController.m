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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStateChangedNotification:) name:kGTIOUserDidEndLoginProcess object:nil];
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

- (void)fadeInTodosBadge {
    _todosBadgeButton.alpha = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (_backgroundImageView.hidden == YES) {
        _todoButton.titleLabel.alpha = 0;
        _uploadButton.titleLabel.alpha = 0;
        _featuredButton.titleLabel.alpha = 0;
        _browseButton.titleLabel.alpha = 0;
        _todoButton.titleLabel.alpha = 0;
        _todosBadgeButton.alpha = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_backgroundImageView.hidden == YES) {
        // begin fade in animations
        _backgroundImageView.alpha = 0;
        _backgroundImageView.hidden = NO;
        if (!_animatedInThisLaunch) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:2];
            [UIView setAnimationDelay:1];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(fadeInTodosBadge)];
        }
        _backgroundImageView.alpha = 1;
        if (!_animatedInThisLaunch) {
            [UIView commitAnimations];
        
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:2];
            [UIView setAnimationDelay:2];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        }
        _uploadButton.titleLabel.alpha = 1;
        _featuredButton.titleLabel.alpha = 1;
        _browseButton.titleLabel.alpha = 1;
        _todoButton.titleLabel.alpha = 1;
        _todoButton.titleLabel.alpha = 1;
        if (!_animatedInThisLaunch) {
            [UIView commitAnimations];
            _animatedInThisLaunch = YES;
        }
    } else {
        // Reload TODO's and notifications.
        [[GTIOUser currentUser] resumeSession];
    }
}

- (void)updateUserLabel {
    _profileThumbnailView.defaultImage = [UIImage imageNamed:@"empty-profile-pic.png"];
    if ([GTIOUser currentUser].loggedIn) {
        _profileThumbnailView.urlPath = [GTIOUser currentUser].profileIconURL;
        
        _nameLabel.frame = CGRectZero;
        _nameLabel.text = [[GTIOUser currentUser].username uppercaseString];
        _nameLabel.font = kGTIOFetteFontOfSize(22);
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_nameLabel sizeToFit];
        _nameLabel.frame = CGRectOffset(_nameLabel.bounds, 45, 6);
        
        _locationLabel.frame = CGRectZero;
        _locationLabel.text = [GTIOUser currentUser].location;
        _locationLabel.font = [UIFont systemFontOfSize:13];
        _locationLabel.textColor = RGBCOLOR(156,156,156);
        [_locationLabel sizeToFit];
        _locationLabel.frame = CGRectMake(45, 25, 200, _locationLabel.bounds.size.height);
        _locationLabel.backgroundColor = [UIColor clearColor];
        
    } else {
        _profileThumbnailView.urlPath = nil;
        
        _nameLabel.text = @"my profile";
        _nameLabel.textColor = RGBCOLOR(185,185,185);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_nameLabel sizeToFit];
        _nameLabel.frame = CGRectOffset(_nameLabel.bounds, 45, 12);
        
        _locationLabel.text = @"";
    }
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
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:_nameLabel belowSubview:_notificationsContainer];
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:_locationLabel belowSubview:_notificationsContainer];
    
    _featuredButton.clipsToBounds = NO;
    _featuredButton.titleLabel.textAlignment = UITextAlignmentCenter;
    
    [self updateUserLabel];
    [self updateNotificationsButton];
    [self updateTodoBadge];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [_nameLabel release];
    _nameLabel = nil;
    [_locationLabel release];
    _locationLabel = nil;
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

#pragma mark - Actions

- (IBAction)myStylistsButtonWasPressed {
    TTOpenURL(@"gtio://stylists");
}
- (IBAction)featuredButtonWasPressed {
    TTOpenURL(@"gtio://featured");
}

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
    [self updateUserLabel];
}

- (void)notificationsUpdatedNotification:(NSNotification*)note {
    [self updateNotificationsButton];
}

- (void)todoBadgeUpdated:(NSNotification*)note {
    [self updateTodoBadge];
}

#pragma mark - Notifications View / Button

- (IBAction)notificationButtonWasPressed {
    if (_notificationsVisible) {
        [self closeNotificationsButtonWasPressed];
        return;
    }
    _notificationsVisible = YES;
    if (nil == _notificationsController) {
        _notificationsController = [[GTIONotificationsOverlayViewController alloc] initWithStyle:UITableViewStylePlain];
        _notificationsController.view.frame = CGRectMake(0, _notificationsButton.bounds.size.height - 10, self.view.bounds.size.width, self.view.bounds.size.height - _notificationsButton.bounds.size.height + 15);
        [_notificationsContainer addSubview:_notificationsController.view];
    } else {
        [_notificationsController invalidateModel];
    }
    [_notificationsController viewWillAppear:YES];
    [UIView beginAnimations:nil context:nil];
    _notificationsContainer.frame = CGRectMake(0,-5,320, 465);
    _closeNotificationsButton.hidden = NO;
    [UIView commitAnimations];
    [_notificationsController viewDidAppear:YES];
}

- (IBAction)closeNotificationsButtonWasPressed {
    _notificationsVisible = NO;
    [UIView beginAnimations:nil context:nil];
    _notificationsContainer.frame = CGRectMake(0,421,320, 465);
    _closeNotificationsButton.hidden = YES;
    [UIView commitAnimations];
}

@end
