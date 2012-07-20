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

#import <AddressBook/AddressBook.h>

@interface GTIOInviteFriendsPerson : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end

@implementation GTIOInviteFriendsPerson

@synthesize firstName = _firstName, lastName = _lastName;

@end

@interface GTIOInviteFriendsViewController ()

@property (nonatomic, strong) GTIOInviteFriendsTableViewHeader *tableHeader;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSArray *alphabetIndex;

@end

@implementation GTIOInviteFriendsViewController

@synthesize tableHeader = _tableHeader, tableView = _tableView, contacts = _contacts, alphabetIndex = _alphabetIndex;

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
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByLastName);
    _contacts = [NSArray arrayWithArray:(__bridge_transfer NSArray*)people];
    [self cleanContacts];
    self.alphabetIndex = [self firstLettersOfContactsLastNames];
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, self.tableHeader.frame.origin.y + self.tableHeader.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - self.tableHeader.bounds.size.height }];
    self.tableView.separatorColor = [UIColor gtio_groupedTableBorderColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (NSArray *)firstLettersOfContactsLastNames
{
    NSMutableArray *firstLetters = [NSMutableArray array];
    for (GTIOInviteFriendsPerson *person in self.contacts) {
        if (person.lastName.length > 0) {
            if (![firstLetters containsObject:[person.lastName substringToIndex:1]]) {
                [firstLetters addObject:[person.lastName substringToIndex:1]];
            }
        }
    }
    return [NSArray arrayWithArray:firstLetters];
}

- (void)cleanContacts
{
    NSMutableArray *cleanedContacts = [NSMutableArray array];
    for (int i = 0; i < _contacts.count; i++) {
        ABRecordRef person = (__bridge_retained  ABRecordRef)[_contacts objectAtIndex:i];
        NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (firstName.length > 0) {
            GTIOInviteFriendsPerson *person = [[GTIOInviteFriendsPerson alloc] init];
            person.firstName = firstName;
            person.lastName = lastName;
            [cleanedContacts addObject:person];
        }
    }
    self.contacts = [NSArray arrayWithArray:cleanedContacts];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
    self.tableHeader = nil;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIOInviteFriendsPerson *person = (GTIOInviteFriendsPerson *)[self.contacts objectAtIndex:0];
    [(GTIOInviteFriendsTableCell *)cell setFirstName:person.firstName lastName:person.lastName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GTIOInviteFriendsSectionHeaderView *sectionHeaderView = [[GTIOInviteFriendsSectionHeaderView alloc] initWithFrame:CGRectZero];
    sectionHeaderView.titleLabel.text = (NSString *)[self.alphabetIndex objectAtIndex:section];
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29.0;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = [self.contacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastName BEGINSWITH %@", [self.alphabetIndex objectAtIndex:section], [self.alphabetIndex objectAtIndex:section]]]; 
    return [sectionArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.alphabetIndex.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.alphabetIndex;
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

@end
