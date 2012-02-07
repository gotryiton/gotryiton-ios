//
//  GTIOContactViewController.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/10/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOContactViewController.h"
#import "GTIOSectionedDataSource.h"
#import "GTIOAdditionalEmailsController.h"

///////////////////////////////////////////////////////////////////////////////////////////

@interface GTIOContactTableViewDelegate : TTTableViewDelegate {
}

@end

@implementation GTIOContactTableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (0 == indexPath.section) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryNone;
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (0 == indexPath.section) {
		return UITableViewCellEditingStyleNone;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return (0 != indexPath.section);
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (NO == [tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
		return nil;
	}
	
	NSString* title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
	if (title.length > 0) {
		UILabel* label = [[UILabel alloc] init];
		label.text = title;
		label.font = [UIFont boldSystemFontOfSize:14];
		label.textColor = [UIColor blackColor];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[label sizeToFit];
		
		UIView* container = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)] autorelease];
		[container addSubview:label];
		label.center = container.center;
		[label release];
		
		return container;
	}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	// Release the selection immediately to avoid a drawing anomaly on iOS 4.0.1
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////

@interface GTIOContactTableViewDataSource : TTSectionedDataSource {
	GTIOOpinionRequest* _opinionRequest;
}

@property (nonatomic, assign) GTIOOpinionRequest* opinionRequest;

@end

@implementation GTIOContactTableViewDataSource

@synthesize opinionRequest = _opinionRequest;

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[self removeItemAtIndexPath:indexPath andSectionIfEmpty:YES];
	[self.opinionRequest.contactEmails removeObjectAtIndex:indexPath.row];
	[tableView reloadData];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////

// Constants
static NSString* const kGTIOContactViewAddressBookURLString = @"gtio://getAnOpinion/share/contacts/addressBook";
static NSString* const kGTIOContactViewAdditionalEmailsURLString = @"gtio://getAnOpinion/share/contacts/emails";

@implementation GTIOContactViewController

@synthesize opinionRequest = _opinionRequest;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if (self = [super initWithNavigatorURL:URL query:query]) {
		self.opinionRequest = [query objectForKey:@"opinionRequest"];
		
		// Connect me to URL dispatch
		TTURLMap* map = [TTNavigator globalNavigator].URLMap;
		[map from:kGTIOContactViewAddressBookURLString toModalViewController:self selector:@selector(peoplePickerNavigationController)];
		[map from:kGTIOContactViewAdditionalEmailsURLString toViewController:self selector:@selector(additionalEmailsController:)];
		
		// Navigation Item
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(shareTitleImage)] autorelease];
		self.navigationItem.rightBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"done"
																				  style:UIBarButtonItemStyleDone
																				 target:self 
																				 action:@selector(doneButtonWasTouched:)] autorelease];
		
		// Table View
		self.tableViewStyle = UITableViewStyleGrouped;
		self.tableView.backgroundColor = [UIColor clearColor];
		self.tableView.rowHeight = 56;
		self.tableView.editing = YES;
		self.tableView.allowsSelectionDuringEditing = YES;
	}
	
	return self;
}

- (void)dealloc {
	// Remove our internal URL's
	TTURLMap* map = [TTNavigator globalNavigator].URLMap;
	[map removeURL:kGTIOContactViewAddressBookURLString];
	[map removeURL:kGTIOContactViewAdditionalEmailsURLString];
	 
	TT_RELEASE_SAFELY(_opinionRequest);
	
	[super dealloc];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[GTIOContactTableViewDelegate alloc] initWithController:self] autorelease];
}

- (void)createModel {
	NSMutableArray* topItems = [NSMutableArray arrayWithObjects:
								[TTTableTextItem itemWithText:@"add from contacts" URL:kGTIOContactViewAddressBookURLString],
								[TTTableTextItem itemWithText:@"enter other email addresses" URL:kGTIOContactViewAdditionalEmailsURLString],
								nil];
	
	NSUInteger capacity = [self.opinionRequest.contactEmails count];
	NSMutableArray* emailItems = [NSMutableArray arrayWithCapacity:capacity];
	NSString* sectionTitle = (capacity > 0) ? @"share my outfit with..." : nil;
	
	for (NSString* emailAddress in self.opinionRequest.contactEmails) {
		[emailItems addObject:[TTTableTextItem itemWithText:emailAddress]];
	}

	GTIOContactTableViewDataSource* dataSource = 
		(GTIOContactTableViewDataSource*) [GTIOContactTableViewDataSource dataSourceWithArrays:
										   @"",
										   topItems,
										   sectionTitle,
										   emailItems,
										   nil];
	dataSource.opinionRequest = self.opinionRequest;
	
	self.dataSource = dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (ABPeoplePickerNavigationController*)peoplePickerNavigationController {
	ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];
	picker.navigationBar.tintColor = TTSTYLEVAR(navigationBarTintColor);
	picker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]];
    picker.peoplePickerDelegate = self;
	
	return picker;
}

- (UIViewController*)additionalEmailsController:(NSDictionary*)query {
	GTIOAdditionalEmailsController* controller = [[[GTIOAdditionalEmailsController alloc] init] autorelease];
	controller.originView = [query objectForKey:@"__target__"];
	controller.delegate = self;	
	return controller;
}

- (void)doneButtonWasTouched:(id)sender {
	[[TTNavigator globalNavigator].URLMap removeURL:kGTIOContactViewAddressBookURLString];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	CFTypeRef value = ABRecordCopyValue(person, property);
	CFIndex index = ABMultiValueGetIndexForIdentifier(value, identifier);
	NSString* emailAddress = (NSString *) ABMultiValueCopyValueAtIndex(value, index);
	CFRelease(value);
	
	// Add to the opinion request
	if (NO == [self.opinionRequest.contactEmails containsObject:emailAddress]) {
		[self.opinionRequest.contactEmails addObject:emailAddress];
	}
	
	[emailAddress release];
	
	[self dismissModalViewControllerAnimated:YES];
	[self invalidateModel];
	
	return NO;
}

#pragma mark TTPostControllerDelegate methods

- (BOOL)postController:(TTPostController*)postController willPostText:(NSString*)text {
	text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ([text length] > 0) {
		text = [text stringByReplacingOccurrencesOfString:@"," withString:@" "];
		text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
		text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
		
		NSMutableArray* contacts = [NSMutableArray arrayWithArray:[text componentsSeparatedByString:@" "]];
		[contacts removeObject:@""];
		
		NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
		NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
		NSMutableArray* invalidContacts = [NSMutableArray arrayWithCapacity:[contacts count]];
		for (NSString* email in contacts) {
			if (NO == [emailTest evaluateWithObject:email]) {
				[invalidContacts addObject:email];
			}
		}
		
		if (0 < [invalidContacts count]) {
			NSString* addressOrAddresses = ([invalidContacts count] == 1) ? @"address" : @"addresses";
			NSString* message = [NSString stringWithFormat:@"check %@: %@.", addressOrAddresses, [invalidContacts componentsJoinedByString:@", "]];
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"whoops!  something\ndoesn't look right..." 
																message:message
															   delegate:nil	
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			
			return NO;
		} else {			
			[self.opinionRequest.contactEmails addObjectsFromArray:contacts];
			[self invalidateModel];
		}				
	}
	
	return YES;
}

@end
