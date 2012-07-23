//
//  GTIOInviteFriendsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOInviteFriendsViewController.h"
#import "GTIOInviteFriendsTableViewHeader.h"
#import "GTIOInviteFriendsTableCell.h"
#import "GTIOInviteFriendsSectionHeaderView.h"
#import "GTIOInviteFriendsPerson.h"

#import <AddressBook/AddressBook.h>

@interface GTIOInviteFriendsViewController ()

@property (nonatomic, strong) GTIOInviteFriendsTableViewHeader *tableHeader;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *contactList;

@end

@implementation GTIOInviteFriendsViewController

@synthesize tableHeader = _tableHeader, tableView = _tableView;
@synthesize contactList = _contactList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"invite friends" italic:YES];
    [self useTitleView:navTitleView];
	
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = backButton;
    
    self.tableHeader = [[GTIOInviteFriendsTableViewHeader alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 100 }];
    [self.view addSubview:self.tableHeader];
    
    [self buildContacts];
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, self.tableHeader.frame.origin.y + self.tableHeader.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - self.tableHeader.bounds.size.height }];
    self.tableView.separatorColor = [UIColor gtio_groupedTableBorderColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
    self.tableHeader = nil;
    self.contactList = nil;
}

- (void)buildContacts
{
    self.contactList = [NSMutableDictionary dictionary];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByLastName);
    NSArray *rawContacts = [NSArray arrayWithArray:(__bridge NSArray *)people];

    for (int i = 0; i < rawContacts.count; i++) {
        ABRecordRef person = (__bridge ABRecordRef)[rawContacts objectAtIndex:i];
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (firstName.length > 0) {
            GTIOInviteFriendsPerson *person = [[GTIOInviteFriendsPerson alloc] init];
            person.firstName = firstName;
            person.lastName = lastName;
            
            // Get first letter of last name, if no last name then first name
            NSString *firstLetter = nil;
            if ([person.lastName length] > 0) {
                firstLetter = [person.lastName substringToIndex:1];
            } else if ([person.firstName length] > 0) {
                firstLetter = [person.firstName substringToIndex:1];
            }
            
            // If user has first or last name add them to contact list dict
            if ([firstLetter length] > 0) {
                NSMutableArray *arrayOfPeopleForLetter = [self.contactList objectForKey:firstLetter];
                
                if (arrayOfPeopleForLetter) {
                    [arrayOfPeopleForLetter addObject:person];
                } else {
                    arrayOfPeopleForLetter = [NSMutableArray array];
                    [arrayOfPeopleForLetter addObject:person];
                    [self.contactList setObject:arrayOfPeopleForLetter forKey:firstLetter];
                }
            }
        }
    }
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sections = [self sortedContactListKeys];
    NSArray *people = [self.contactList objectForKey:[sections objectAtIndex:indexPath.section]];
    GTIOInviteFriendsPerson *person = (GTIOInviteFriendsPerson *)[people objectAtIndex:indexPath.row];
    [(GTIOInviteFriendsTableCell *)cell setFirstName:person.firstName lastName:person.lastName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *sections = [self sortedContactListKeys];
    GTIOInviteFriendsSectionHeaderView *sectionHeaderView = [[GTIOInviteFriendsSectionHeaderView alloc] initWithFrame:CGRectZero];
    sectionHeaderView.titleLabel.text = (NSString *)[sections objectAtIndex:section];
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29.0;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self sortedContactListKeys];
    return [[self.contactList objectForKey:[sections objectAtIndex:section]] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self sortedContactListKeys] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self sortedContactListKeys];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"WhoHeartedThisCell";
    
    GTIOInviteFriendsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[GTIOInviteFriendsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Helpers

- (NSArray *)sortedContactListKeys
{
    return [self.contactList.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

@end
