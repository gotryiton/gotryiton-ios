//
//  GTIOAddStylistsViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/19/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOAddStylistsViewController.h"
#import <AddressBook/AddressBook.h>
#import <RestKit/Three20/Three20.h>
#import "GTIOBrowseList.h"


@implementation GTIOAddStylistsViewController

- (NSArray*)getEmailAddressesFromContacts {
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSMutableArray* arrayOfEmails = [NSMutableArray array];
    
    for (int i = 0; i < [(NSArray*)people count]; i++) {
        ABRecordRef person = [(NSArray*)people objectAtIndex:i];
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (int j = 0; j < ABMultiValueGetCount(emails); j++) {
            CFStringRef email = ABMultiValueCopyValueAtIndex(emails, j);
            [arrayOfEmails addObject:(NSString*)email];
            CFRelease(email);
        }
        CFRelease(emails);
    }
    
    CFRelease(people);
    CFRelease(addressBook);
    return arrayOfEmails;
}

- (void)createModel {
    // Depending on tab, load a different API Endpoint
    NSUInteger index = _tabBar.selectedTabIndex;
    NSString* apiEndpoint = nil;
    NSDictionary* params = nil;
    switch (index) {
        case GTIONetworkTab:
            apiEndpoint = GTIORestResourcePath(@"/stylists/network");
            // Params should be fbToken = <my fb token> if I have one
            // and emailContacts = [emails].
            NSArray* emails = [self getEmailAddressesFromContacts];
            NSLog(@"Emails: %@", emails);
            params = [NSDictionary dictionaryWithObjectsAndKeys:emails, @"emailContacts", nil];
            params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
            break;
        case GTIOContactsTab:
            // TODO
            break;
        case GTIORecomendedTab:
            // TODO
            break;
    }
    RKRequestTTModel* model = [[[RKRequestTTModel alloc] initWithResourcePath:apiEndpoint params:params method:RKRequestMethodPOST] autorelease];
    TTListDataSource* ds = [TTListDataSource dataSourceWithObjects:nil];
    ds.model = model;
    self.dataSource = ds;
}

- (void)didLoadModel:(BOOL)firstTime {
    RKRequestTTModel* model = (RKRequestTTModel*)self.model;
    
    GTIOBrowseList* list = [model.objects objectWithClass:[GTIOBrowseList class]];
    NSLog(@"List: %@", list);
}

@end
