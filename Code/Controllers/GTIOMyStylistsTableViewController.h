//
//  GTIOMyStylistsTableViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/18/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOMyStylistsTableViewController : TTTableViewController {
    UIBarButtonItem* _editButton;
    UIBarButtonItem* _cancelButton;
    UIBarButtonItem* _doneButton;
    NSMutableArray* _stylists;
    NSMutableArray* _stylistsToDelete;
}

@end
