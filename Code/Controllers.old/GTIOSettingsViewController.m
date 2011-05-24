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
}

- (void)createLoggedInModel {
	_pushNotificationsSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_pushNotificationsSwitch.on = [GTIOUser currentUser].iphonePush;
	_pushNotificationsSwitch.delegate = self;

    _alertActivitySwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_alertActivitySwitch.on = [GTIOUser currentUser].alertActivity;
	_alertActivitySwitch.delegate = self;
    
    _alertStylistActivitySwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_alertStylistActivitySwitch.on = [GTIOUser currentUser].alertStylistActivity;
	_alertStylistActivitySwitch.delegate = self;
    
    _alertStylistAddSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_alertStylistAddSwitch.on = [GTIOUser currentUser].alertStylistAdd;
	_alertStylistAddSwitch.delegate = self;
    
    _alertNewsletterSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_alertNewsletterSwitch.on = [GTIOUser currentUser].alertNewsletter;
	_alertNewsletterSwitch.delegate = self;
    
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:@"",
					   [TTTableControlItem itemWithCaption:@"push notifications" control:_pushNotificationsSwitch],
                       (_pushNotificationsSwitch.on ? @"email + alert me when..." : @"email me when..."),
                       [TTTableControlItem itemWithCaption:@"there's activity on my look" control:_alertActivitySwitch],
                       [TTTableControlItem itemWithCaption:@"I become someone's stylist" control:_alertStylistAddSwitch],
                       [TTTableControlItem itemWithCaption:@"someone needs my advice" control:_alertStylistActivitySwitch],
                       [TTTableControlItem itemWithCaption:@"there's GO TRY IT ON news" control:_alertNewsletterSwitch],
                       @"",
					   [TTTableTextItem itemWithText:@"about us" URL:settingsURL],
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
    user.iphonePush = _pushNotificationsSwitch.on;
	user.alertActivity = _alertActivitySwitch.on;
    user.alertStylistActivity = _alertStylistActivitySwitch.on;
    user.alertStylistAdd = _alertStylistAddSwitch.on;
    user.alertNewsletter = _alertNewsletterSwitch.on;
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            (user.iphonePush ? @"1" : @"0"), @"iphonePush",
                            (user.alertActivity ? @"1" : @"0"), @"alertActivity",
                            (user.alertStylistActivity ? @"1" : @"0"), @"alertStylistActivity",
                            (user.alertStylistAdd ? @"1" : @"0"), @"alertStylistAdd",
                            (user.alertNewsletter ? @"1" : @"0"), @"alertNewsletter",
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
