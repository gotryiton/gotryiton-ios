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
	TWTPickerControl* picker = emailPickerForUser([GTIOUser currentUser]);
	[picker.toolbar setItems:[NSArray arrayWithObjects:picker.doneButton, nil]];
	picker.delegate = self;
	CustomUISwitch* mySwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	mySwitch.on = [GTIOUser currentUser].iphonePush;
	mySwitch.delegate = self;
	self.dataSource = [TTListDataSource dataSourceWithObjects:
					   [TTTableControlItem itemWithCaption:@"push notifications" control:mySwitch],
					   [TTTableControlItem itemWithCaption:@"email alerts" control:picker],
					   [TTTableTextItem itemWithText:@"about us" URL:settingsURL],
					   nil];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
	[button addTarget:[GTIOUser currentUser] action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
	[button sizeToFit];
	self.tableView.tableFooterView = button;
}

- (void)createLoggedOutModel {
	self.dataSource = [TTListDataSource dataSourceWithObjects:
					   [TTTableTextItem itemWithText:@"about us" URL:settingsURL],
					   nil];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
	[button addTarget:[GTIOUser currentUser] action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
	[button sizeToFit];
	self.tableView.tableFooterView = button;
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
	user.iphonePush = [view isOn];
	[[GTIOUpdateUserRequest updateUser:user delegate:self selector:@selector(callback:)] retain];
}

- (void)picker:(TWTPickerControl*)picker willHidePicker:(UIView*)pickerView {
	GTIOUser* user = [GTIOUser currentUser];
	user.emailAlertSetting = emailPickerChoiceAsNumber(picker);
	[[GTIOUpdateUserRequest updateUser:user delegate:self selector:@selector(callback:)] retain];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self invalidateModel];
	self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)callback:(GTIOUpdateUserRequest*)r {
	NSLog(@"Request: %@", r);
	[r release];
}

@end
