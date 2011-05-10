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

@interface GTIOProfileViewController : GTIOTopPaddedTableViewController {
	UIView* _notLoggedInOverlay;
	UIView* _headerView;
	UILabel* _nameLabel;
	UILabel* _locationLabel;
	UIView* _bioContainerView;
	GTIOAboutMeView* _bioLabel;
	UILabel* _separatorLabel;
	BOOL _isShowingCurrentUser;
	NSString* _userID;
	
	NSMutableArray* _badgeImageViews;
}

@end
