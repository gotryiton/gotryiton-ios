//
//  GTIOProfileViewController.h
//  GoTryItOn
//
//  Created by Blake Watters on 8/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOTableViewController.h"
#import "GTIOTopPaddedTableViewController.h"
#import "GTIOAboutMeView.h"
#import "GTIOProfileHeaderView.h"

@interface GTIOProfileViewController : GTIOTopPaddedTableViewController {
	UIView* _notLoggedInOverlay;
	GTIOProfileHeaderView* _headerView;
	GTIOAboutMeView* _bioLabel;
	NSString* _userID;	
	// ??
	UIView* _bioContainerView;
	UILabel* _separatorLabel;
	BOOL _isShowingCurrentUser;

	
	NSMutableArray* _badgeImageViews;
}

@end
