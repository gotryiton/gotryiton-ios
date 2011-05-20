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
#import "NSObject_Additions.h"
#import "GTIOListSection.h"
#import "GTIOProfile.h"

@interface GTIOSelectableTableItem : TTTableImageItem {
@private
    BOOL _selected;
}

@property (nonatomic, assign) BOOL selected;

@end

@implementation GTIOSelectableTableItem

@synthesize selected = _selected;

@end

@interface GTIOSelectableTableCell : TTTableImageItemCell
@end

@implementation GTIOSelectableTableCell

- (void)setObject:(id)object {
    [super setObject:object];
    GTIOSelectableTableItem* item = (GTIOSelectableTableItem*)object;
    if (item.selected) {
        self.contentView.backgroundColor = [UIColor grayColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end

@interface GTIOAddStylistsListDataSource : TTListDataSource
@end
@implementation GTIOAddStylistsListDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOSelectableTableItem class]]) {
        return [GTIOSelectableTableCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end

@interface GTIOAddStylistsSectionedDataSource : TTSectionedDataSource
@end
@implementation GTIOAddStylistsSectionedDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOSelectableTableItem class]]) {
        return [GTIOSelectableTableCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end

@implementation GTIOAddStylistsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _emailsToInvite = [NSMutableArray new];
        _profileIDsToInvite = [NSMutableArray new];
        TTNavigator* navigator = [TTNavigator navigator];
        TTURLMap* map = navigator.URLMap;
        [map from:@"gtio://stylists/addEmailAddress/(addEmailAddress:)" toObject:self];
        [map from:@"gtio://stylists/addProfileID/(addProfileID:)" toObject:self];
    }
    return self;
}

- (void)dealloc {
    TTNavigator* navigator = [TTNavigator navigator];
    TTURLMap* map = navigator.URLMap;
    
    [map removeURL:@"gtio://stylists/addEmailAddress/(addEmailAddress:)"];
    [map removeURL:@"gtio://stylists/addProfileID/(addProfileID:)"];
    [_emailsToInvite release];
    [_profileIDsToInvite release];
    [super dealloc];
}

- (NSArray*)getEmailAddressesFromContacts {
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSMutableArray* arrayOfEmails = [NSMutableArray array];
    
    for (int i = 0; i < [(NSArray*)people count]; i++) {
        ABRecordRef person = [(NSArray*)people objectAtIndex:i];
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (int j = 0; j < ABMultiValueGetCount(emails); j++) {
            CFStringRef email = ABMultiValueCopyValueAtIndex(emails, j);
            if (![arrayOfEmails containsObject:(NSString*)email]) {
                [arrayOfEmails addObject:(NSString*)email];
            }
            CFRelease(email);
        }
        CFRelease(emails);
    }
    
    CFRelease(people);
    CFRelease(addressBook);
    return arrayOfEmails;
}

- (void)viewDidUnload {
    [_tabBar release];
    _tabBar = nil;
    [_doneButton release];
    _doneButton = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"add stylists";
    
    _tabBar = [[TTTabBar alloc] initWithFrame:CGRectMake(0,0,320,50)];
    [_tabBar setTabItems:[NSArray arrayWithObjects:
                          [[[TTTabItem alloc] initWithTitle:@"Network"] autorelease],
                          [[[TTTabItem alloc] initWithTitle:@"Contacts"] autorelease],
                          [[[TTTabItem alloc] initWithTitle:@"Recomended"] autorelease],
                          nil]];
    _tabBar.contentMode = UIViewContentModeScaleToFill;
    [_tabBar setDelegate:self];
    [self.view addSubview:_tabBar];
    
    _doneButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    _doneButton.frame = CGRectMake(30, self.view.bounds.size.height - 50, 320-60, 40);
    [self.view addSubview:_doneButton];
    
    self.tableView.frame = CGRectMake(0, _tabBar.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height - _tabBar.bounds.size.height - 60);
}

- (void)showLoading {
	TTActivityLabel* label = [[[TTActivityLabel alloc] initWithFrame:TTScreenBounds() style:TTActivityLabelStyleBlackBox text:@"loading..."] autorelease];
	label.tag = 9999;
	[[TTNavigator navigator].window addSubview:label];
}

- (void)hideLoading {
	[[[TTNavigator navigator].window viewWithTag:9999] removeFromSuperview];
}

- (void)updateDoneButton {
    int sum = [_emailsToInvite count] + [_profileIDsToInvite count];
    if (sum > 0) {
        [_doneButton setTitle:[NSString stringWithFormat:@"Done - send %d stylist requests", sum] forState:UIControlStateNormal];
    } else {
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    }
}

- (void)addEmailAddress:(NSString*)address {
    NSLog(@"Address: %@", address);
    if ([_emailsToInvite containsObject:address]) {
        [_emailsToInvite removeObject:address];
    } else {
        [_emailsToInvite addObject:address];
    }
    [self updateDoneButton];
}

- (void)addProfileID:(NSString*)profileID {
    NSLog(@"Profile ID: %@", profileID);
    if ([_profileIDsToInvite containsObject:profileID]) {
        [_profileIDsToInvite removeObject:profileID];
    } else {
        [_profileIDsToInvite addObject:profileID];
    }
    [self updateDoneButton];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    NSLog(@"Object: %@", object);
    if ([object isKindOfClass:[GTIOSelectableTableItem class]]) {
        GTIOSelectableTableItem* item = (GTIOSelectableTableItem*)object;
        item.selected = !item.selected;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)createModel {
    // Depending on tab, load a different API Endpoint
    NSUInteger index = _tabBar.selectedTabIndex;
    NSString* apiEndpoint = nil;
    NSDictionary* params = nil;
    if (index == GTIONetworkTab) {
            apiEndpoint = GTIORestResourcePath(@"/stylists/network");
            // Params should be fbToken = <my fb token> if I have one
            // and emailContacts = [emails].
            NSArray* emails = [self getEmailAddressesFromContacts];
            NSLog(@"Emails: %@", emails);
            NSString* emailsAsJSON = [emails jsonEncode];
            params = [NSDictionary dictionaryWithObjectsAndKeys:emailsAsJSON, @"emailContacts", nil];
            params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    } else if (index == GTIOContactsTab) {
            NSArray* emailsAddresses = [self getEmailAddressesFromContacts];
            NSMutableArray* items = [NSMutableArray arrayWithCapacity:[emailsAddresses count]];
            for (NSString* email in emailsAddresses) {
                NSString* url = [NSString stringWithFormat:@"gtio://stylists/addEmailAddress/%@", email];
                GTIOSelectableTableItem* item = [GTIOSelectableTableItem itemWithText:email URL:url];
                if ([_emailsToInvite containsObject:email]) {
                    item.selected = YES;
                }
                [items addObject:item];
            }
            self.dataSource = [GTIOAddStylistsListDataSource dataSourceWithItems:items];
            return;
    } else {
        // GTIORecomendedTab
        // TODO
        return;
    }
    RKRequestTTModel* model = [[[RKRequestTTModel alloc] initWithResourcePath:apiEndpoint params:params method:RKRequestMethodPOST] autorelease];
    GTIOAddStylistsListDataSource* ds = (GTIOAddStylistsListDataSource*)[GTIOAddStylistsListDataSource dataSourceWithObjects:nil];
    ds.model = model;
    self.dataSource = ds;
}

- (void)didLoadModel:(BOOL)firstTime {
    RKRequestTTModel* model = (RKRequestTTModel*)self.model;
    if ([model isKindOfClass:[RKRequestTTModel class]]) {
        GTIOBrowseList* list = [model.objects objectWithClass:[GTIOBrowseList class]];
        NSArray* sections = list.sections;
        NSLog(@"List: %@, sections: %@", list, sections);
        NSMutableArray* sectionTitles = [NSMutableArray array];
        NSMutableArray* sectionItems = [NSMutableArray array];
        for (GTIOListSection* section in sections) {
            [sectionTitles addObject:section.title];
            NSMutableArray* items = [NSMutableArray array];
            for (GTIOProfile* stylist in section.stylists) {
                NSString* url = [NSString stringWithFormat:@"gtio://stylists/addProfileID/%@", stylist.uid];
                GTIOSelectableTableItem* item = [GTIOSelectableTableItem itemWithText:stylist.displayName imageURL:stylist.profileIconURL URL:url];
                item.imageStyle = [TTImageStyle styleWithImageURL:nil
                                                     defaultImage:nil
                                                      contentMode:UIViewContentModeScaleAspectFit
                                                             size:CGSizeMake(40,40)
                                                             next:nil];
                if ([_profileIDsToInvite containsObject:stylist.uid]) {
                    item.selected = YES;
                }
                [items addObject:item];
            }
            [sectionItems addObject:items];
        }
        GTIOAddStylistsSectionedDataSource* ds = (GTIOAddStylistsSectionedDataSource*)[GTIOAddStylistsSectionedDataSource dataSourceWithItems:sectionItems sections:sectionTitles];
        ds.model = model;
        self.dataSource = ds;
    }
}

- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex {
    [self invalidateModel];
}

- (void)doneButtonWasPressed:(id)sender {
    [self showLoading];
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/stylists/add") delegate:self];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[_emailsToInvite jsonEncode], @"stylistEmails",
                            [_profileIDsToInvite jsonEncode], @"stylistUids", nil];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    loader.method = RKRequestMethodPOST;
    [loader send];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    NSLog(@"Error: %@", error);
    [self hideLoading];
    [[[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Objects: %@", objects);
    [self hideLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
