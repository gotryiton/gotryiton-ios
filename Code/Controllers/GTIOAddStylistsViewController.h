//
//  GTIOAddStylistsViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/19/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GTIONetworkTab = 0,
    GTIOContactsTab,
    GTIORecomendedTab
} GTIOAddStylistsTab;

@interface GTIOAddStylistsViewController : TTTableViewController <TTTabDelegate, RKObjectLoaderDelegate> {
    TTTabBar* _tabBar;
    UIButton* _doneButton;
    NSMutableArray* _emailsToInvite;
    NSMutableArray* _profileIDsToInvite;
}

@end
