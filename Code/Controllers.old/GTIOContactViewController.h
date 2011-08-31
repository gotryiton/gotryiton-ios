//
//  GTIOContactViewController.h
//  GoTryItOn
//
//  Created by Blake Watters on 9/10/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOContactViewController is a subclass of [GTIOTableViewController](GTIOTableViewController) that displays a users contacts for sharing
/// probably ought to be refactored with [GTIOAddStylistsViewController](GTIOAddStylistsViewController)

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "GTIOTableViewController.h"
#import "GTIOOpinionRequest.h"

@interface GTIOContactViewController : GTIOConcreteBackgroundTableViewController <ABPeoplePickerNavigationControllerDelegate, TTPostControllerDelegate> {
	GTIOOpinionRequest* _opinionRequest;
}
/// GTIO Opinion request
@property (nonatomic, retain) GTIOOpinionRequest* opinionRequest;

@end
