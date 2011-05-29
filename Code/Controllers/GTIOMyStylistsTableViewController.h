//
//  GTIOMyStylistsTableViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/18/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOMyStylistsTableViewController is a TTTableViewController that displays the current user's stylists and provides editing controls

@interface GTIOMyStylistsTableViewController : TTTableViewController {
    UIBarButtonItem* _editButton;
    UIBarButtonItem* _cancelButton;
    UIBarButtonItem* _doneButton;
    NSMutableArray* _stylists;
    NSMutableArray* _stylistsToDelete;
}

@end
