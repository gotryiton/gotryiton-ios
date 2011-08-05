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
#import "GTIOOutfitVerdictTableItem.h" // TODO : why is this here? remove?
#import "GTIOTableStatsItem.h"
// Models
#import "GTIOUser.h"
#import "GTIOProfile.h"
#import "GTIOOutfit.h"
#import "GTIOBannerAd.h"
// Views
#import "GTIOHeaderView.h"
#import "GTIOBarButtonItem.h"
#import <TWTURLButton.h>

@interface GTIOProfileViewController (Private)
- (void)registerForNotifications;
- (void)unregisterForNotifications;
@end

@interface GTIOProfileTableViewDelegate : TTTableViewVarHeightDelegate
@end

@implementation GTIOProfileTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* superView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,1)] autorelease];
    UIView* view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow-wallpaper.png"]] autorelease];
    view.backgroundColor = [UIColor clearColor];
    [superView addSubview:view];
    return superView;
}

@end

@implementation GTIOProfileViewController

#pragma mark -
#pragma mark Init and Dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nil bundle:nil]) {
		[self.navigationItem setHidesBackButton:YES];
        //        [self.navigationItem setLeftBarButtonItem:[GTIOBarButtonItem backButton]];
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
    [_topRightButton release];
	[_userID release];
    [_bannerAdView release];
	[super dealloc];
}

- (id)createDelegate {
    return [[[GTIOProfileTableViewDelegate alloc] initWithController:self] autorelease];
}

#pragma mark -
#pragma mark View Controller Life Cycle

- (void)loadView {
	[super loadView];

	self.variableHeightRows = YES;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

	// Set Navigation Bar Title
	self.navigationItem.titleView = [GTIOHeaderView viewWithText:(_isShowingCurrentUser ? @"MY PROFILE" : @"PROFILE")];

	// Create Header View.
	_headerView = [[GTIOProfileHeaderView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,70)];
	[self.view addSubview:_headerView];

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
    if (_isShowingCurrentUser) {
		GTIOAnalyticsEvent(kUserDidViewMyProfilePageEventName);
	} else {
        GTIOAnalyticsEvent(kUserDidViewProfilePageEventName);
	}
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

- (void)setupHeaderView:(GTIOProfile*)profile withAd:(GTIOBannerAd*)bannerAd {
    [_bannerAdView removeFromSuperview];
    [_bannerAdView release];
    _bannerAdView = nil;
    float bannerHeight = 0;
    if(bannerAd) {
        TWTURLButton* button = [TWTURLButton buttonWithType:UIButtonTypeCustom];
        TTImageView* imageView = [[TTImageView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               320,
                                                                               50)];
        imageView.exclusiveTouch = NO;
        imageView.userInteractionEnabled = YES;
        button.frame = imageView.bounds;
        [imageView addSubview:button];
        [imageView autorelease];
        button.clickUrl = bannerAd.clickUrl;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
            imageView.urlPath = bannerAd.bannerImageUrlLarge;
        } else {
            imageView.urlPath = bannerAd.bannerImageUrlSmall;
        }
        _bannerAdView = [imageView retain];
        [self.view addSubview:_bannerAdView];
        bannerHeight = CGRectGetMaxY(_bannerAdView.frame);
    }
    
	[_headerView displayProfile:profile];
	_headerView.frame = CGRectMake(0,bannerHeight,320, _headerView.bounds.size.height);
    
	_aboutMeView.text = profile.aboutMe;
	[_aboutMeView setNeedsDisplay];
	_aboutMeView.frame = CGRectMake(0,_headerView.bounds.size.height + bannerHeight, 320, 200);
	[_aboutMeView sizeToFit];
	
	CGFloat height = CGRectGetMaxY(_aboutMeView.frame);
    
    self.tableView.frame = CGRectMake(0,height,320, self.view.bounds.size.height - height);
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
    
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:nil];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    ds.model = [GTIOMapGlobalsTTModel modelWithObjectLoader:objectLoader];
	self.dataSource = ds;
}

- (void)model:(id <TTModel>)model didFailLoadWithError:(NSError *)error {
	[super model:model didFailLoadWithError:error];
	[self showLoading:NO];
	[self showError:YES];
}

- (void)rightBarButtonItemPressed:(id)sender {
    if (_topRightButton.url) {
        TTOpenURL(_topRightButton.url);
    }
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	
    // set settings button
	if (_isShowingCurrentUser && [[GTIOUser currentUser] isLoggedIn]) {
		UIImage* settingsButtonImage = [UIImage imageNamed:@"settingsBarButton.png"];
		GTIOBarButtonItem* item  = [[GTIOBarButtonItem alloc] initWithImage:settingsButtonImage target:self action:@selector(settingsButtonAction:)];
		[self.navigationItem setRightBarButtonItem:item];
	} else {
		[self.navigationItem setRightBarButtonItem:nil];
	}
    
	if (([[GTIOUser currentUser] isLoggedIn] || !_isShowingCurrentUser) && [self.model isKindOfClass:[RKObjectLoaderTTModel class]]) {
		GTIOProfile* profile = nil;
        GTIOBannerAd* bannerAd = nil;
        _isBrandedProfileView = NO;
        [_topRightButton release];
        _topRightButton = nil;
		for (id object in [(RKObjectLoaderTTModel*)self.model objects]) {
			if ([object isKindOfClass:[GTIOProfile class]]) {
                if ([(GTIOProfile*)object isBranded]) {
                    _isBrandedProfileView = YES;
                    // Analytics for brands
                    GTIOAnalyticsEvent(GTIOAnalyticsBrandedProfileEventNameFor([(GTIOProfile*)object displayName]));
                }
				profile = object;
			}
            if ([object isKindOfClass:[GTIOBannerAd class]]) {
				bannerAd = object;
			}
            if ([object isKindOfClass:[GTIOTopRightBarButton class]]) {
				_topRightButton = [object retain];
			}
		}
        
        if (_topRightButton) {
            self.navigationItem.rightBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:_topRightButton.text target:self action:@selector(rightBarButtonItemPressed:)] autorelease];
        }
		
		[self setupHeaderView:profile withAd:bannerAd];
		
		[_notLoggedInOverlay removeFromSuperview];
		NSMutableArray* items = [NSMutableArray arrayWithCapacity:3];
		
        if (_isShowingCurrentUser) {
            TTTableTextItem* statsItem = [GTIOTableStatsItem itemWithText:@"stats"];
            [items addObject:statsItem];
        }
        for (NSDictionary* stat in profile.userStats) {
			[items addObject:[GTIOIndividualStatItem itemWithText:[NSString stringWithFormat:@"%@", [stat valueForKey:@"value"]] caption:[stat valueForKey:@"name"]]];
		}
        
        if (profile.extraProfileRow) {
            NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [profile.extraProfileRow.api stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
            TTTableTextItem* looksItem = [GTIOPinkTableTextItem itemWithText:profile.extraProfileRow.text URL:url];
            [items addObject:looksItem];
        }
        
		
        NSString* looksApiURL = GTIORestResourcePath([NSString stringWithFormat:@"/profile/%@/looks", profile.uid]);
        NSString* looksURL = [NSString stringWithFormat:@"gtio://browse/%@", [looksApiURL stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
		TTTableTextItem* looksItem = [TTTableTextItem itemWithText:(_isShowingCurrentUser ? @"my looks" : @"looks") URL:looksURL];
		[items addObject:looksItem];
		
        NSString* reviewsAPIURL = GTIORestResourcePath([NSString stringWithFormat:@"/profile/%@/reviews", profile.uid]);
        NSString* reviewsURL = [NSString stringWithFormat:@"gtio://browse/%@", [reviewsAPIURL stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
		TTTableTextItem* reviewsItem = [TTTableTextItem itemWithText:(_isShowingCurrentUser ? @"my reviews" : @"reviews") URL:reviewsURL];
		[items addObject:reviewsItem];
        
        if (_isShowingCurrentUser) {
            TTTableTextItem* stylistsItem = [TTTableTextItem itemWithText:@"my stylists" URL:@"gtio://stylists"];
            [items addObject:stylistsItem];
        } else {
            // Stylists grid.
            if ([profile.stylists count] > 0) {
                GTIOStylistBadgesTableViewItem* item = [GTIOStylistBadgesTableViewItem itemWithStylists:profile.stylists];
                [items addObject:item];
            }
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
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    if ([object isKindOfClass:[GTIOStylistBadgesTableViewItem class]]) {
        return;
    }
    // Handle Analytics here, since this is the only place we still know whether or not it was branded
    if ([[object text] isEqualToString:@"looks"]) {
        if (_isBrandedProfileView) {
            GTIOAnalyticsEvent(GTIOAnalyticsBrandedProfileLooksEventNameFor([[_headerView nameLabel] text]));
        } else {
            GTIOAnalyticsEvent(kProfileLooksEventName);
        }
    } else if ([[object text] isEqualToString:@"reviews"]) {
        if (_isBrandedProfileView) {
            GTIOAnalyticsEvent(GTIOAnalyticsBrandedProfileReviewsEventNameFor([[_headerView nameLabel] text]));
        } else {
            GTIOAnalyticsEvent(kProfileReviewsEventName);
        }
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
