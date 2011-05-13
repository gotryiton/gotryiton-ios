//
//  GTIOProfileViewController.h
//  GoTryItOn
//
//  Created by Blake Watters on 8/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOTableViewController.h"
#import "GTIOTopPaddedTableViewController.h"
#import "GTIOProfileAboutMeView.h"
#import "GTIOProfileHeaderView.h"

@interface GTIOProfileViewController : GTIOTopPaddedTableViewController {
	UIView* _notLoggedInOverlay;
	GTIOProfileHeaderView* _headerView;
	GTIOProfileAboutMeView* _aboutMeView;
	NSString* _userID;	
	// ??
	UIView* _bioContainerView;
	UILabel* _separatorLabel;
	BOOL _isShowingCurrentUser;

	
	NSMutableArray* _badgeImageViews;
}

@end
