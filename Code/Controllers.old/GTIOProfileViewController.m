//
//  GTIOProfileViewController.m
//  GoTryItOn
//
//  Created by Blake Watters on 8/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

// Frameworks
#import <RestKit/RestKit.h>
#import <RestKit/Three20/Three20.h>
// Superclass
#import "GTIOProfileViewController.h"
// Datasource
#import "GTIOProfileViewDataSource.h"
// TTModel
#import "GTIOMapGlobalsTTModel.h"
// Table Items
#import "GTIOOutfitVerdictTableItem.h"
#import "GTIOTableStatsItem.h"
// Models
#import "GTIOUser.h"
#import "GTIOProfile.h"
#import "GTIOOutfit.h"
// Views
#import "GTIOTitleView.h"
#import "GTIOBarButtonItem.h"

@interface GTIOProfileViewController (Private)
- (void)registerForNotifications;
- (void)unregisterForNotifications;
@end

@implementation GTIOProfileViewController

#pragma mark -
#pragma mark Init and Dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nil bundle:nil]) {
		[self.navigationItem setHidesBackButton:YES];
        [self.navigationItem setLeftBarButtonItem:[GTIOBarButtonItem backButton]];
		[self registerForNotifications];
		_isShowingCurrentUser = YES;
	}
	return self;
}

- (id)initWithUserID:(NSString*)userID {
	if (self = [super initWithNibName:nil bundle:nil]) {
		_userID = [userID retain];
        NSLog(@"currentUserID=%@, displayUserID:%@",[GTIOUser currentUser].UID,_userID);
		_isShowingCurrentUser = [_userID isEqualToString:[GTIOUser currentUser].UID];
        NSLog(@"is current user:%d",_isShowingCurrentUser);
	}
	return self;
}

- (void)dealloc {
	[self unregisterForNotifications];
	[_userID release];
	[super dealloc];
}

#pragma mark -
#pragma mark View Controller Life Cycle

- (void)loadView {
	[super loadView];

	if (_isShowingCurrentUser) {
			TTOpenURL(@"gtio://analytics/trackMyProfilePageView");
	} else {
			TTOpenURL(@"gtio://analytics/trackProfilePageView");
	}

	self.variableHeightRows = YES;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

	// Set Navigation Bar Title
	self.navigationItem.titleView = [GTIOTitleView title:(_isShowingCurrentUser ? @"MY PROFILE" : @"PROFILE")];

	// Create Header View.
	_headerView = [[GTIOProfileHeaderView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,70)];
	[self.view addSubview:_headerView];
	// Setup Table
	[self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:_headerView.frame]];
	[self.tableView setExclusiveTouch:NO];

	_aboutMeView = [[GTIOProfileAboutMeView alloc] initWithFrame:CGRectZero];
	_aboutMeView.backgroundColor = kGTIOColorE3E3E3;
	[self.view addSubview:_aboutMeView];

	if (TTOSVersion() < 3.2) {
		// Fix frames for pre 3.2 iOS versions
		_notLoggedInOverlay.frame = CGRectMake(0, -50, 320, self.view.height);
	}
    
    // Set Accessibility Labels
    [_aboutMeView setAccessibilityLabel:@"about me label"];
    [_headerView setAccessibilityLabel:@"profile header view"];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self invalidateModel];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {	
	static BOOL firstAppearance = YES;
	
	[super viewDidAppear:animated];
	
	if (YES == firstAppearance) {
		firstAppearance = NO;
		
		GTIOUser* currentUser = [GTIOUser currentUser];
		if (!currentUser.loggedIn && _isShowingCurrentUser) {
			TTOpenURL(@"gtio://login");
		}
	}
}

#pragma mark -
#pragma mark Profile View
- (void)setupHeaderView:(GTIOProfile*)profile {
	[_headerView displayProfile:profile];
	
	_aboutMeView.text = profile.aboutMe;
	[_aboutMeView setNeedsDisplay];
	_aboutMeView.frame = CGRectMake(0, 70, 320, 200);
	[_aboutMeView sizeToFit];
	
	CGFloat height = _headerView.frame.size.height + _aboutMeView.frame.size.height;
	[self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,height)]];
	[self.tableView setExclusiveTouch:NO];
}

#pragma mark -
#pragma mark Button Actions

- (void)settingsButtonAction:(id)sender {
	TTOpenURL(@"gtio://settings");
}

#pragma mark -
#pragma mark Model Lifecycle

- (void)createModel {
	GTIOUser* user = [GTIOUser currentUser];
	NSString* uid = (_isShowingCurrentUser ? user.UID : _userID);
	
	if (uid == nil) {
		self.dataSource = [GTIOProfileViewDataSource dataSourceWithObjects:nil];
		return;
	}
	
	NSString* path = GTIORestResourcePath([NSString stringWithFormat:@"/profile/%@", uid]);
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithKeysAndObjects:nil];
	
	GTIOProfileViewDataSource* ds = (GTIOProfileViewDataSource*)[GTIOProfileViewDataSource dataSourceWithObjects:nil];
	ds.model = [[GTIOMapGlobalsTTModel alloc] initWithResourcePath:path
                                                            params:[GTIOUser paramsByAddingCurrentUserIdentifier:params]
															method:RKRequestMethodGET];
	self.dataSource = ds;
}

- (void)model:(id <TTModel>)model didFailLoadWithError:(NSError *)error {
	[super model:model didFailLoadWithError:error];
	[self showLoading:NO];
	[self showError:YES];
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	
	if (([[GTIOUser currentUser] isLoggedIn] || !_isShowingCurrentUser) && [self.model isKindOfClass:[RKRequestTTModel class]]) {
		GTIOProfile* profile = nil;
		for (id object in [(RKRequestTTModel*)self.model objects]) {
			if ([object isKindOfClass:[GTIOProfile class]]) {
				profile = object;
				break;
			}
		}
		
		[self setupHeaderView:profile];
		
		[_notLoggedInOverlay removeFromSuperview];
		NSMutableArray* items = [NSMutableArray arrayWithCapacity:3];
		
		TTTableTextItem* statsItem = [GTIOTableStatsItem itemWithText:(_isShowingCurrentUser ? @"my stats" : @"stats")];
		[items addObject:statsItem];		
		
        NSString* looksApiURL = GTIORestResourcePath([NSString stringWithFormat:@"/profile/%@/looks", profile.uid]);
        NSString* looksURL = [NSString stringWithFormat:@"gtio://browse/%@", [looksApiURL stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
		TTTableTextItem* looksItem = [TTTableTextItem itemWithText:(_isShowingCurrentUser ? @"my looks" : @"looks") URL:looksURL];
		[items addObject:looksItem];
		
        NSString* reviewsAPIURL = GTIORestResourcePath([NSString stringWithFormat:@"/profile/%@/reviews", profile.uid]);
        NSString* reviewsURL = [NSString stringWithFormat:@"gtio://browse/%@", [reviewsAPIURL stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
		TTTableTextItem* reviewsItem = [TTTableTextItem itemWithText:(_isShowingCurrentUser ? @"my reviews" : @"reviews") URL:reviewsURL];
		[items addObject:reviewsItem];
		
		
		for (NSDictionary* stat in profile.userStats) {
			[items addObject:[GTIOIndividualStatItem itemWithText:[NSString stringWithFormat:@"%@", [stat valueForKey:@"value"]] caption:[stat valueForKey:@"name"]]];
		}
		
		TTListDataSource* dataSource = [GTIOProfileViewDataSource dataSourceWithItems:items];
		dataSource.model = self.model;
		self.dataSource = dataSource;
	} else {
		TTListDataSource* dataSource = [GTIOProfileViewDataSource dataSourceWithObjects:nil];
		dataSource.model = self.model;
		self.dataSource = dataSource;
		[self.view addSubview:_notLoggedInOverlay];
	}
	
	// set settings button
	if (_isShowingCurrentUser && [[GTIOUser currentUser] isLoggedIn]) {
		UIImage* settingsButtonImage = [UIImage imageNamed:@"settingsBarButton.png"];
		GTIOBarButtonItem* item  = [[GTIOBarButtonItem alloc] initWithImage:settingsButtonImage target:self action:@selector(settingsButtonAction:)];
		[self.navigationItem setRightBarButtonItem:item];
	} else {
		[self.navigationItem setRightBarButtonItem:nil];
	}
}

#pragma mark -
#pragma mark State Change Notifications

- (void)handleUserStateChangedNotification:(NSNotification*)notification {
	[self invalidateModel];
}

- (void)handleOutfitUpdatedNotification:(NSNotification*)notification {
	[self invalidateModel];
}

- (void)registerForNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleUserStateChangedNotification:) 
												 name:kGTIOUserDidLoginNotificationName 
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleUserStateChangedNotification:) 
												 name:kGTIOUserDidLogoutNotificationName 
												 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(handleUserStateChangedNotification:) 
												 name:kGTIOUserDidUpdateProfileNotificationName
												 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleOutfitUpdatedNotification:)
                                                 name:@"OutfitWasUpdatedNotification"
												 object:nil];
}

- (void)unregisterForNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
