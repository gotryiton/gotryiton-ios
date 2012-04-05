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
#import "GTIOHeaderView.h"
#import "GTIOSignInTermsView.h"

@interface GTIOSettingsTableControlItem : TTTableControlItem
@end
@implementation GTIOSettingsTableControlItem
@end

@interface GTIOSettingsTableControlItemCell : TTTableControlCell
@end

@implementation GTIOSettingsTableControlItemCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.font = [UIFont boldSystemFontOfSize:12];
}

@end


@interface GTIOSettingsDataSource : TTSectionedDataSource
@end

@implementation GTIOSettingsDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOSettingsTableControlItem class]]) {
        return [GTIOSettingsTableControlItemCell class];
    } else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end

@interface GTIOSettingsTableViewDelegate : TTTableViewDelegate
@end
@implementation GTIOSettingsTableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        NSString* text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
        if (text && ![text isWhitespaceAndNewlines]) {
            UIView* section = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,20)] autorelease];
            UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(20,8,300,20)] autorelease];
            label.text = text;
            label.textColor = RGBCOLOR(128,128,128);
            label.font = [UIFont boldSystemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            [section addSubview:label];
            
            return section;
        }
    }
    return nil;
}

@end

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
	self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"SETTINGS"];
    GTIOAnalyticsEvent(kUserDidViewSettingsEventName);
    UIBarButtonItem* signoutItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"sign out" target:self action:@selector(signOutButtonWasPressed:)] autorelease];
    self.navigationItem.rightBarButtonItem = signoutItem;
    self.tableView.tableFooterView = [GTIOSupportInfoView supportView];
    
}

- (void)logoutConfirmed {
    [[GTIOUser currentUser] logout];
    TTOpenURL(@"gtio://home");
}

- (void)signOutButtonWasPressed:(id)sender {
    TWTAlertViewDelegate* delegate = [[TWTAlertViewDelegate new] autorelease];
    [delegate setTarget:self selector:@selector(logoutConfirmed) object:nil forButtonIndex:1];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"sign out" message:@"are you sure?" delegate:delegate cancelButtonTitle:@"no" otherButtonTitles:@"yes", nil];
    [alert show];
    [alert release];
}

- (id)createDelegate {
    return [[[GTIOSettingsTableViewDelegate alloc] initWithController:self] autorelease];
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
    
    _shareSuggestionsToFacebookSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] autorelease];
	_shareSuggestionsToFacebookSwitch.on = [[GTIOUser currentUser].facebookSuggestionShare boolValue];
	_shareSuggestionsToFacebookSwitch.delegate = self;
    
    if ([[[GTIOUser currentUser] isFacebookConnected] boolValue]) {
        self.dataSource = [GTIOSettingsDataSource dataSourceWithObjects:@"",
                           [TTTableControlItem itemWithCaption:@"push notifications" control:_pushNotificationsSwitch],
                           (_pushNotificationsSwitch.on ? @"email + alert me when..." : @"email me when..."),
                           [GTIOSettingsTableControlItem itemWithCaption:@"there's activity on my look" control:_alertActivitySwitch],
                           [GTIOSettingsTableControlItem itemWithCaption:@"I become someone's stylist" control:_alertStylistAddSwitch],
                           [GTIOSettingsTableControlItem itemWithCaption:@"someone needs my advice" control:_alertStylistActivitySwitch],
                           [GTIOSettingsTableControlItem itemWithCaption:@"there's GO TRY IT ON news" control:_alertNewsletterSwitch],
                           @"Facebook share settings",
                           [GTIOSettingsTableControlItem itemWithCaption:@"share product suggestions" control:_shareSuggestionsToFacebookSwitch],
                           nil];
    } else {
        self.dataSource = [GTIOSettingsDataSource dataSourceWithObjects:@"",
                           [TTTableControlItem itemWithCaption:@"push notifications" control:_pushNotificationsSwitch],
                           (_pushNotificationsSwitch.on ? @"email + alert me when..." : @"email me when..."),
                           [GTIOSettingsTableControlItem itemWithCaption:@"there's activity on my look" control:_alertActivitySwitch],
                           [GTIOSettingsTableControlItem itemWithCaption:@"I become someone's stylist" control:_alertStylistAddSwitch],
                           [GTIOSettingsTableControlItem itemWithCaption:@"someone needs my advice" control:_alertStylistActivitySwitch],
                           [GTIOSettingsTableControlItem itemWithCaption:@"there's GO TRY IT ON news" control:_alertNewsletterSwitch],
                           nil];
    }
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
    user.facebookSuggestionShare = [NSNumber numberWithBool:_shareSuggestionsToFacebookSwitch.on];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            user.iphonePush, @"iphonePush",
                            user.alertActivity, @"alertActivity",
                            user.alertStylistActivity, @"alertStylistActivity",
                            user.alertStylistAdd, @"alertStylistAdd",
                            user.alertNewsletter, @"alertNewsletter",
                            user.facebookSuggestionShare, @"facebookSuggestionShare",
                            user.deviceToken, @"deviceToken",
                            nil];
    
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/user") delegate:self];
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

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    GTIOErrorMessage(error);
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    NSLog(@"Response: %@", [response bodyAsString]);
    GTIOUser* user = [GTIOUser currentUser];
    NSError* error = nil;;
    id body = [response parsedBody:&error];
    if (body == nil && error) {
        return;
    }
    
    NSValue* facebookSuggestionSharePermission = [body valueForKeyPath:@"user.facebookSuggestionSharePermission"];
    bool boolValue;
    [facebookSuggestionSharePermission getValue:&boolValue];
    if (_shareSuggestionsToFacebookSwitch.on &&
        boolValue == NO) {
        [user loginWithFacebook];
    }
    
    [user digestProfileInfo:body];
    [_pushNotificationsSwitch setOn:[user.iphonePush boolValue] animated:YES];
    [_alertActivitySwitch setOn:[user.alertActivity boolValue] animated:YES];
    [_alertStylistActivitySwitch setOn:[user.alertStylistActivity boolValue] animated:YES];
    [_alertStylistAddSwitch setOn:[user.alertStylistAdd boolValue] animated:YES];
    [_alertNewsletterSwitch setOn:[user.alertNewsletter boolValue] animated:YES];
    [_shareSuggestionsToFacebookSwitch setOn:[user.facebookSuggestionShare boolValue] animated:YES];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    ;
}

@end
