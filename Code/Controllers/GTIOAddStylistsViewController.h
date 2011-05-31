//
//  GTIOAddStylistsViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/19/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOAddStylistsViewController is a view controller responsible for viewing new stylist potentials and adding them
#import <Foundation/Foundation.h>

typedef enum {
    GTIONetworkTab = 0,
    GTIOContactsTab,
    GTIORecomendedTab
} GTIOAddStylistsTab;

@interface GTIOAddStylistsViewController : TTTableViewController <TTTabDelegate, RKObjectLoaderDelegate, UITextFieldDelegate> {
    TTTabBar* _tabBar;
    UIView* _buttonView;
    UIButton* _doneButton;
    NSMutableArray* _emailsToInvite;
    NSMutableArray* _profileIDsToInvite;
    UITextField* _emailField;
    NSMutableArray* _customEmailAddresses;
}

@end
