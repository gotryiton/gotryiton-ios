//
//  GTIOProfileViewController.m
//  GoTryItOn
//
//  Created by Blake Watters on 8/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOProfileViewController.h"
#import "GTIOUser.h"
#import "GTIOProfile.h"
#import "GTIOOutfit.h"
#import "GTIOReachabilityObserver.h"
#import <RestKit/RestKit.h>
#import <RestKit/Three20/Three20.h>
#import "GTIOOutfitTableViewItem.h"
#import "GTIOProfileViewDataSource.h"
#import "GTIOTableStatsItem.h"
#import "GTIOTitleView.h"
#import "GTIOOutfitVerdictTableItem.h"
#import "GTIOMapGlobalsTTModel.h"
#import "GTIOBarButtonItem.h"

@interface GTIOProfileViewController (Private)
- (void)registerForNotifications;
- (void)unregisterForNotifications;
@end

@implementation GTIOProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nil bundle:nil]) {
		[self.navigationItem setHidesBackButton:YES];
		[self.navigationItem setLeftBarButtonItem:[GTIOBarButtonItem homeBackBarButtonWithTarget:self action:@selector(backAction)]];
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

- (void)viewDidUnload {
	[super viewDidUnload];
	TT_RELEASE_SAFELY(_notLoggedInOverlay);
	TT_RELEASE_SAFELY(_headerView);
	TT_RELEASE_SAFELY(_nameLabel);
	TT_RELEASE_SAFELY(_locationLabel);
	TT_RELEASE_SAFELY(_bioContainerView);
	TT_RELEASE_SAFELY(_bioLabel);
	TT_RELEASE_SAFELY(_separatorLabel);
	TT_RELEASE_SAFELY(_badgeImageViews);
}

- (void)loadView {
	[super loadView];
    
	if (_isShowingCurrentUser) {
			TTOpenURL(@"gtio://analytics/trackMyProfilePageView");
	} else {
			TTOpenURL(@"gtio://analytics/trackProfilePageView");
	}
    
	self.variableHeightRows = YES;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	_badgeImageViews = [NSMutableArray new];
	
	// Set custom header.
	self.navigationItem.titleView = [GTIOTitleView title:(_isShowingCurrentUser ? @"MY PROFILE" : @"PROFILE")];
	
	// Create header view.
	_headerView = [[UIView alloc] initWithFrame:CGRectZero];
	_headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"profile-background.png"]];
	[self.view addSubview:_headerView];
	_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 40)];
	_nameLabel.backgroundColor = [UIColor clearColor];
	_nameLabel.font = kGTIOFetteFontOfSize(36);
	_nameLabel.textColor = kGTIOColorBrightPink;
	[_headerView addSubview:_nameLabel];
	_locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50-6-1, 250, 20)];
	_locationLabel.backgroundColor = [UIColor clearColor];
	_locationLabel.font = [UIFont systemFontOfSize:15];
	_locationLabel.textColor = kGTIOColorB2B2B2;
	[_headerView addSubview:_locationLabel];
	
	_bioContainerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 71, 320, 36)];
	_bioContainerView.backgroundColor = kGTIOColorE3E3E3;
	
	_bioLabel = [[GTIOAboutMeView alloc] initWithFrame:CGRectZero];
	_bioLabel.backgroundColor = kGTIOColorE3E3E3;
	[_bioContainerView addSubview:_bioLabel];
	
	_separatorLabel = [[UIView alloc] initWithFrame:CGRectZero];
	_separatorLabel.backgroundColor = kGTIOColorAAAAAA;
	[_headerView addSubview:_separatorLabel];
	
	// Create not logged in view
	_notLoggedInOverlay = [[UIView alloc] initWithFrame:self.view.bounds];
	_notLoggedInOverlay.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"profile-loggedout-background.png"]];
	UIButton* signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[signInButton setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
	[signInButton sizeToFit];
	signInButton.frame = CGRectOffset(signInButton.frame, floor((320-signInButton.bounds.size.width)/2), 264);
	[signInButton addTarget:[GTIOUser currentUser] action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
	[_notLoggedInOverlay addSubview:signInButton];
	
	if (TTOSVersion() < 3.2) {
		// Fix frames for pre 3.2 iOS versions
		_notLoggedInOverlay.frame = CGRectMake(0, -50, 320, self.view.height);
		signInButton.frame = CGRectMake(signInButton.frame.origin.x, signInButton.frame.origin.y + 50, signInButton.frame.size.width, signInButton.frame.size.height);
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)editButtonWasPressed:(id)sender {
	TTOpenURL(@"gtio://profile/edit");
}

- (void)setupHeaderView:(GTIOProfile*)profile {
	BOOL userHasBio = ![profile.aboutMe isWhitespaceAndNewlines]; //TODO: hook this up
	NSString* bioString = profile.aboutMe;
	
	if (userHasBio) {
		[_headerView addSubview:_bioContainerView];
	} else {
		[_bioContainerView removeFromSuperview];
	}
	
	_nameLabel.text = [profile.displayName uppercaseString];
	[_nameLabel setNeedsDisplay];
	
	_bioLabel.text = bioString;
	[_bioLabel setNeedsDisplay];
	_bioLabel.frame = CGRectMake(0, 0, 320, 200);
	[_bioLabel sizeToFit];
	
	_bioLabel.frame = CGRectOffset(_bioLabel.frame, 0, 2);
	_bioContainerView.frame = CGRectMake(_bioContainerView.frame.origin.x, _bioContainerView.frame.origin.y, 320, _bioLabel.height + 4);
	
	float headerViewBaseHeight = 71;
	_headerView.frame = userHasBio ? CGRectMake(0, 0, 320, headerViewBaseHeight+_bioContainerView.height) : CGRectMake(0, 0, 320, headerViewBaseHeight);
	
	_separatorLabel.frame = CGRectMake(0, _headerView.bounds.size.height - 2, 320, 2);
	[_headerView addSubview:_separatorLabel];
	
	_locationLabel.text = profile.location;
	[_locationLabel setNeedsDisplay];
	
	self.tableView.frame = CGRectMake(0, _headerView.bounds.size.height, 320, self.view.bounds.size.height - _headerView.bounds.size.height);
	
	// Show badge images.
	NSArray* badgeURLs = [profile.badges valueForKeyPath:@"imgURL"];
	// Dispose of any old badge image views.
	for (TTImageView* imageView in _badgeImageViews) {
		[imageView removeFromSuperview];
	}
	[_badgeImageViews removeAllObjects];
	int i = 0;
	for (NSString* badgeURL in badgeURLs) {
		TTImageView* imageView = [[[TTImageView alloc] initWithFrame:CGRectMake(310 - 30 - (35*i), 10, 30, 30)] autorelease];
		imageView.backgroundColor = [UIColor whiteColor];
		[imageView setContentMode:UIViewContentModeScaleAspectFit];
		imageView.urlPath = badgeURL;
		[self.view addSubview:imageView];
		[_badgeImageViews addObject:imageView];
		i++;
	}
}

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
		GTIOBarButtonItem* item  = [[GTIOBarButtonItem alloc] initWithImage:editImage target:self action:@selector(editButtonWasPressed:)];
		[self.navigationItem setRightBarButtonItem:item];
	} else {
		[self.navigationItem setRightBarButtonItem:nil];
	}
}

- (void)handleUserStateChangedNotification:(NSNotification*)notification {
	[self invalidateModel];
}

- (void)handleOutfitUpdatedNotification:(NSNotification*)notification {
	[self invalidateModel];
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

- (void)backAction {
	[[self navigationController] popViewControllerAnimated:YES];
}

@end
