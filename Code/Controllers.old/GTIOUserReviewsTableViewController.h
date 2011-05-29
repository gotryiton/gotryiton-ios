//
//  GTIOUserReviewsTableViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOUserReviewsTableViewController is a GTIOOutfitListTableViewController that shows a user's reviews
#import <Foundation/Foundation.h>
#import "GTIOOutfitListTableViewController.h"

@interface GTIOUserReviewsTableViewController : GTIOOutfitListTableViewController {
	BOOL _isShowingCurrentUser;
	NSString* _userID;
}

@end
