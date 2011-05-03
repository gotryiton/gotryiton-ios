//
//  GTIOGiveAnOpinionTableViewController.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/21/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "GTIOOutfitListTableViewController.h"

typedef enum {
	GTIOOpinionStateRecent,
	GTIOOpinionStatePopular,
	GTIOOpinionStateSearch
} GTIOOpinionState;

@interface GTIOGiveAnOpinionTableViewController : GTIOOutfitListTableViewController <UITextFieldDelegate> {
	GTIOOpinionState _state;
	UIButton* _recentButton;
	UIButton* _popularButton;
	UIButton* _searchButton;
	UIView* _searchBarView;
	UITextField* _searchBarTextField;
	UIView* _headerSeparator;
	BOOL _isSearchVisible;
}
@end