//
//  GTIOProfileViewController.h
//  GoTryItOn
//
//  Created by Blake Watters on 8/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOProfileViewController is a subclass of [GTIOTopPaddedTableViewController](GTIOTopPaddedTableViewController) that displays an arbitrary user's profile

// Superclass
#import "GTIOTableViewController.h"
#import "GTIOTopPaddedTableViewController.h"
// Subviews
#import "GTIOProfileAboutMeView.h"
#import "GTIOProfileHeaderView.h"
#import "GTIOTopRightBarButton.h"

@interface GTIOProfileViewController : GTIOTopPaddedTableViewController {
	UIView* _notLoggedInOverlay;
	GTIOProfileHeaderView* _headerView;
    UIView* _bannerAdView;
	GTIOProfileAboutMeView* _aboutMeView;
    GTIOTopRightBarButton* _topRightButton;
	NSString* _userID;	
	BOOL _isShowingCurrentUser;
}

@end
