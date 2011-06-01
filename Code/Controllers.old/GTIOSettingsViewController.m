//
//  GTIOSettingsViewController.m
//  GoTryItOn
//
//  Created by Blake Watters on 8/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOSettingsViewController.h"
#import "GTIOUser.h"
#import "GTIOUpdateUserRequest.h"
#import "TWTAlertViewDelegate.h"

static NSString* const settingsURL = @"http://i.gotryiton.com/about-us.php";

@interface GTIOSettingsViewController (Private)
- (void)updateLoginOrLogoutButtonTitle;
@end

@implementation GTIOSettingsViewController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if (self = [super initWithNavigatorURL:URL query:query]) {
		self.tableViewStyle = UITableViewStyleGrouped;
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"settings"
														 image:TTSTYLEVAR(settingsTabBarImage) 
														   tag:0] autorelease];
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(updateLoginOrLogoutState) 
													 name:kGTIOUserDidLoginNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(updateLoginOrLogoutState) 
													 name:kGTIOUserDidLogoutNotificationName
												   object:nil];
	}
	
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)loadView {
	[super loadView];
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings.png"]] autorelease];
	TTOpenURL(@"gtio://analytics/trackUserDidViewSettings");
    UIBarButtonItem* signoutItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleBordered target:self action:@selector(signOutButtonWasPressed:)];
    self.navigationItem.rightBarButtonItem = signoutItem;
}

- (void)logoutConfirmed {
    [[GTIOUser currentUser] logout];
    TTOpenURL(@"gtio://home");
}

- (void)signOutButtonWasPressed:(id)sender {
    TWTAlertViewDelegate* delegate = [[TWTAlertViewDelegate new] autorelease];
    [delegate setTarget:self selector:@selector(logoutConfirmed) object:nil forButtonIndex:1];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure?" delegate:delegate cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
    [alert release];
}

- (void)createLoggedInModel {
	_pushNotificationsSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_pushNotificationsSwitch.on = [[GTIOUser currentUser].iphonePush boolValue];
	_pushNotificationsSwitch.delegate = self;

    _alertActivitySwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_alertActivitySwitch.on = [[GTIOUser currentUser].alertActivity boolValue];
	_alertActivitySwitch.delegate = self;
    
    _alertStylistActivitySwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_alertStylistActivitySwitch.on = [[GTIOUser currentUser].alertStylistActivity boolValue];
	_alertStylistActivitySwitch.delegate = self;
    
    _alertStylistAddSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_alertStylistAddSwitch.on = [[GTIOUser currentUser].alertStylistAdd boolValue];
	_alertStylistAddSwitch.delegate = self;
    
    _alertNewsletterSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_alertNewsletterSwitch.on = [[GTIOUser currentUser].alertNewsletter boolValue];
	_alertNewsletterSwitch.delegate = self;
    
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:@"",
					   [TTTableControlItem itemWithCaption:@"push notifications" control:_pushNotificationsSwitch],
                       (_pushNotificationsSwitch.on ? @"email + alert me when..." : @"email me when..."),
                       [TTTableControlItem itemWithCaption:@"there's activity on my look" control:_alertActivitySwitch],
                       [TTTableControlItem itemWithCaption:@"I become someone's stylist" control:_alertStylistAddSwitch],
                       [TTTableControlItem itemWithCaption:@"someone needs my advice" control:_alertStylistActivitySwitch],
                       [TTTableControlItem itemWithCaption:@"there's GO TRY IT ON news" control:_alertNewsletterSwitch],
//                       @"",
//					   [TTTableTextItem itemWithText:@"about us" URL:settingsURL],
					   nil];
}

- (void)createLoggedOutModel {
	self.dataSource = [TTListDataSource dataSourceWithObjects:
					   [TTTableTextItem itemWithText:@"about us" URL:settingsURL],
					   nil];
}

- (void)createModel {
	GTIOUser* currentUser = [GTIOUser currentUser];
	if ([currentUser isLoggedIn]) {
		[self createLoggedInModel];
	} else {
		[self createLoggedOutModel];
	}
}

- (void)updateLoginOrLogoutState {
	[self invalidateModel];
}

- (void)valueChangedInView:(CustomUISwitch*)view {
	GTIOUser* user = [GTIOUser currentUser];
    user.iphonePush = [NSNumber numberWithBool:_pushNotificationsSwitch.on];
	user.alertActivity = [NSNumber numberWithBool:_alertActivitySwitch.on];
    user.alertStylistActivity = [NSNumber numberWithBool:_alertStylistActivitySwitch.on];
    user.alertStylistAdd = [NSNumber numberWithBool:_alertStylistAddSwitch.on];
    user.alertNewsletter = [NSNumber numberWithBool:_alertNewsletterSwitch.on];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            user.iphonePush, @"iphonePush",
                            user.alertActivity, @"alertActivity",
                            user.alertStylistActivity, @"alertStylistActivity",
                            user.alertStylistAdd, @"alertStylistAdd",
                            user.alertNewsletter, @"alertNewsletter",
                            nil];
    
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/user") delegate:nil];
    loader.method = RKRequestMethodPOST;
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    [loader send];
    
    if (_pushNotificationsSwitch == view) {
        [self invalidateModel];
    }
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self invalidateModel];
	self.tableView.backgroundColor = [UIColor clearColor];
}

@end
