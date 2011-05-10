//
//  GTIOContactViewController.h
//  GoTryItOn
//
//  Created by Blake Watters on 9/10/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "GTIOTableViewController.h"
#import "GTIOOpinionRequest.h"

@interface GTIOContactViewController : GTIOTableViewController <ABPeoplePickerNavigationControllerDelegate, TTPostControllerDelegate> {
	GTIOOpinionRequest* _opinionRequest;
}

@property (nonatomic, retain) GTIOOpinionRequest* opinionRequest;

@end
