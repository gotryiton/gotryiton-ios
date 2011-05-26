//
//  GTIOUserOutfitsTableViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOOutfitListTableViewController.h"

@interface GTIOUserOutfitsTableViewController : GTIOOutfitListTableViewController {
	BOOL _isShowingCurrentUser;
	NSString* _userID;
}

@end
