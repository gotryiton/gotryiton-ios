//
//  GTIOAddStylistsViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/19/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOAddStylistsViewController is a view controller responsible for viewing new stylist potentials and adding them
#import <Foundation/Foundation.h>
#import "GTIOTableViewController.h"
#import "GTIOMessageComposer.h"
#import "GTIOFacebookInviteTableViewController.h"
#import "GTIOBrowseTableViewController.h"

typedef enum {
    GTIONetworkTab = 0,
    GTIORecomendedTab,
    GTIOInviteTab
} GTIOAddStylistsTab;

@interface GTIOAddStylistsViewController : GTIOTableViewController <TTTabDelegate, RKObjectLoaderDelegate, UITextFieldDelegate> {
    TTTabBar* _tabBar;
    GTIOBarButtonItem* _doneButton;
    NSMutableArray* _emailsToInvite;
    NSMutableArray* _profileIDsToInvite;
    UITextField* _emailField;
    NSMutableArray* _customEmailAddresses;
    
    UIView* _inviteOverlay;
}

@end
