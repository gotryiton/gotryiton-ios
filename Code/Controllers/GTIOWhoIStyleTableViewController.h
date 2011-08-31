//
//  GTIOWhoIStyleTableViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/23/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTIOWhoIStyleTableItem;

/// GTIOWhoIStyleTableItemDelegate is a protocol that handles actions on the list of users the current user styles
@protocol GTIOWhoIStyleTableItemDelegate <NSObject>
/// sent when the current user toggles the alert switch
- (void)tableItem:(GTIOWhoIStyleTableItem*)item toggledAlertSwitch:(UISwitch*)alertSwitch;
/// sent when the silence button was pressed on a user
- (void)tableItem:(GTIOWhoIStyleTableItem*)item silenceButtonWasPressed:(id)sender;
/// sent when the unsilence button was pressed on a user
- (void)tableItem:(GTIOWhoIStyleTableItem*)item unSilenceButtonWasPressed:(id)sender;
@end

#import "GTIOTableViewController.h"

/// GTIOWhoIStyleTableViewController is subclass of TTTableViewController that displays the list of who the current user styles
@interface GTIOWhoIStyleTableViewController : GTIOTableViewController <GTIOWhoIStyleTableItemDelegate> {}

@end
