//
//  GTIOUserReviewsTableViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOOutfitListTableViewController.h"

@interface GTIOUserReviewsTableViewController : GTIOOutfitListTableViewController {
	BOOL _isShowingCurrentUser;
	NSString* _userID;
}

@end
