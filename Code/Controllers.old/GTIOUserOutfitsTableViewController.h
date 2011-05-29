//
//  GTIOUserOutfitsTableViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOUserOutfitsTableViewController is a subclass of [GTIOOutfitListTableViewController](GTIOOutfitListTableViewController) that displays the current users outfits

#import <Foundation/Foundation.h>
#import "GTIOOutfitListTableViewController.h"

@interface GTIOUserOutfitsTableViewController : GTIOOutfitListTableViewController {
	BOOL _isShowingCurrentUser;
	NSString* _userID;
}

@end
