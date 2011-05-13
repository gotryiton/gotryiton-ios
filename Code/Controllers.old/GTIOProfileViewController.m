//
//  GTIOProfileViewController.m
//  GoTryItOn
//
//  Created by Blake Watters on 8/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
#import <RestKit/RestKit.h>
#import <RestKit/Three20/Three20.h>

#import "GTIOProfileViewController.h"

#import "GTIOReachabilityObserver.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOProfileViewDataSource.h"
#import "GTIOTableStatsItem.h"
#import "GTIOOutfitVerdictTableItem.h"
#import "GTIOMapGlobalsTTModel.h"
#import "GTIOBarButtonItem.h"

#import "GTIOUser.h"
#import "GTIOProfile.h"
#import "GTIOOutfit.h"

#import "GTIOTitleView.h"

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
		[self.navigationItem setLeftBarButtonItem:[GTIOBarButtonItem homeBackBarButtonWithTarget:self action:@selector(backButtonAction)]];
		[self registerForNotifications];
		_isShowingCurrentUser = YES;
	}
	
	return self;
}

- (id)initWithUserID:(NSString*)userID {
	if (self = [super initWithNibName:nil bundle:nil]) {
		_userID = [userID retain];
		_isShowingCurrentUser = [_userID isEqualToString:[GTIOUser currentUser].UID];
		NSLog(@"Showing Current User: %d", _isShowingCurrentUser);
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
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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

- (void)editButtonAction:(id)sender {
	TTOpenURL(@"gtio://profile/edit");
}

- (void)backButtonAction {
	[[self navigationController] popViewControllerAnimated:YES];
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
	
	NSString* path = GTIORestResourcePath(@"/profile/");
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithKeysAndObjects:@"uid", uid,nil];
	if (_isShowingCurrentUser) {
		[params setValue:@"true" forKey:@"requestOutfits"];
		[params setValue:@"1" forKey:@"limit"];
	}
	
	GTIOProfileViewDataSource* ds = (GTIOProfileViewDataSource*)[GTIOProfileViewDataSource dataSourceWithObjects:nil];
	ds.model = [[GTIOMapGlobalsTTModel alloc] initWithResourcePath:path
																													params:[GTIOUser paramsByAddingCurrentUserIdentifier:params]
																													method:RKRequestMethodPOST];
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
		
		if ([profile.outfits count] > 0 && _isShowingCurrentUser) {
			GTIOOutfit* outfit = [profile.outfits objectAtIndex:0];
			[items addObject:[GTIOOutfitVerdictTableItem itemWithOutfit:outfit]];
		} else {
			[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
		}
		
		NSString* looksURL = [NSString stringWithFormat:@"gtio://user_looks/%@", profile.uid];
		TTTableTextItem* looksItem = [TTTableTextItem itemWithText:(_isShowingCurrentUser ? @"my looks" : @"looks") URL:looksURL];
		[items addObject:looksItem];
		
		NSString* reviewsURL = [NSString stringWithFormat:@"gtio://user_reviews/%@", profile.uid];
		TTTableTextItem* reviewsItem = [TTTableTextItem itemWithText:(_isShowingCurrentUser ? @"my reviews" : @"reviews") URL:reviewsURL];
		[items addObject:reviewsItem];
		
		TTTableTextItem* statsItem = [GTIOTableStatsItem itemWithText:(_isShowingCurrentUser ? @"my stats" : @"stats")];
		[items addObject:statsItem];
		
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
	
	// set edit button
	if (_isShowingCurrentUser && [[GTIOUser currentUser] isLoggedIn]) {
		UIImage* editImage = [UIImage imageNamed:@"settingsBarButton.png"];
		GTIOBarButtonItem* item  = [[GTIOBarButtonItem alloc] initWithImage:editImage target:self action:@selector(editButtonAction:)];
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
