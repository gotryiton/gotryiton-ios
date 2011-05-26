//
//  GTIOWhoIStyleTableViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/23/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTIOWhoIStyleTableItem;

@protocol GTIOWhoIStyleTableItemDelegate <NSObject>

- (void)tableItem:(GTIOWhoIStyleTableItem*)item toggledAlertSwitch:(UISwitch*)alertSwitch;
- (void)tableItem:(GTIOWhoIStyleTableItem*)item silenceButtonWasPressed:(id)sender;
- (void)tableItem:(GTIOWhoIStyleTableItem*)item unSilenceButtonWasPressed:(id)sender;

@end

@interface GTIOWhoIStyleTableViewController : TTTableViewController <GTIOWhoIStyleTableItemDelegate> {
    
}

@end
