//
//  GTIOInviteFriendsViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOInviteFriendsViewController.h"

#import <RestKit/RestKit.h>

#import "GTIOInviteFriendsPerson.h"
#import "GTIOButton.h"

#import "GTIOInviteFriendsTableViewHeader.h"
#import "GTIOInviteFriendsTableCell.h"
#import "GTIOInviteFriendsSectionHeaderView.h"
#import "GTIOActionSheet.h"

#import "GTIOMailComposer.h"
#import "GTIOMessageComposer.h"
#import "GTIOProgressHUD.h"
#import "GTIOInvitation.h"
#import "GTIOTweetComposer.h"

#import <AddressBook/AddressBook.h>

static NSString * const kGTIOSMSMessage = @"kGTIOSMSMessage";
static NSString * const kGTIOSMSMessageType = @"sms";
static NSString * const kGTIOEmailMessage = @"kGTIOEmailMessage";
static NSString * const kGTIOEmailMessageType = @"email";
static NSString * const kGTIOTweetMessageType = @"twitter";
static NSString * const kGTIONoTwitterMessage = @"You're not set up to Tweet yet! Find the Twitter option in your iPhone's Settings to get started!";

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
        self.hidesBottomBarWhenPushed = NO;
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
    
    __block typeof(self) blockSelf = self;
    self.tableHeader = [[GTIOInviteFriendsTableViewHeader alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 100 }];
    [self.tableHeader.smsButton setTapHandler:^(id sender) {
        [blockSelf createInviationWithType:kGTIOSMSMessageType toRecipients:[NSArray array]];
    }];
    [self.tableHeader.emailButton setTapHandler:^(id sender) {
        [blockSelf createInviationWithType:kGTIOEmailMessageType toRecipients:[NSArray array]];
    }];
    [self.tableHeader.twitterButton setTapHandler:^(id sender) {
        [blockSelf createInviationWithType:kGTIOTweetMessageType toRecipients:[NSArray array]];
    }];
    [self.view addSubview:self.tableHeader];
    
    [self buildContacts];
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, self.tableHeader.frame.origin.y + self.tableHeader.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - self.tableHeader.bounds.size.height }];
    [self.tableView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
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
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
    NSArray *rawContacts = [NSArray arrayWithArray:(__bridge NSArray *)people];

    for (int i = 0; i < rawContacts.count; i++) {
        ABRecordRef person = (__bridge ABRecordRef)[rawContacts objectAtIndex:i];
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        NSString *phoneNumber = nil;
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if (ABMultiValueGetCount(phoneNumbers) > 0) {
            phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
        }
        
        NSString *email = nil;
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        if (ABMultiValueGetCount(emails)) {
            email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, 0);
        }
        
        if (firstName.length > 0) {
            GTIOInviteFriendsPerson *person = [[GTIOInviteFriendsPerson alloc] init];
            person.firstName = firstName;
            person.lastName = lastName;
            person.phoneNumber = phoneNumber;
            person.email = email;
            
            // Get first letter of last name, if no last name then first name
            NSString *firstLetter = nil;
            if ([person.lastName length] > 0) {
                firstLetter = [person.lastName substringToIndex:1];
            } else if ([person.firstName length] > 0) {
                firstLetter = [person.firstName substringToIndex:1];
            }
            
            // If user has first or last name, an email or phone number add them to contact list dict
            if ([firstLetter length] > 0 && ([person.phoneNumber length] > 0 || [person.email length] > 0) ) {
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
    
    NSArray *sections = [self sortedContactListKeys];
    NSArray *section = [self.contactList objectForKey:[sections objectAtIndex:indexPath.section]];
    GTIOInviteFriendsPerson *person = [section objectAtIndex:indexPath.row];
    
    NSMutableArray *buttonModels = [NSMutableArray array];
    
    if ([person.email length] > 0) {
        GTIOButton *emailButtonModel = [[GTIOButton alloc] init];
        emailButtonModel.text = [NSString stringWithFormat:@"Email: %@", person.email];
        emailButtonModel.attribute = person.email;
        emailButtonModel.state = [NSNumber numberWithInt:1];
        emailButtonModel.name = kGTIOEmailMessage;
        [buttonModels addObject:emailButtonModel];
    }
    
    if ([person.phoneNumber length] > 0) {
        GTIOButton *smsButtonModel = [[GTIOButton alloc] init];
        smsButtonModel.text = [NSString stringWithFormat:@"SMS: %@", person.phoneNumber];
        smsButtonModel.attribute = person.phoneNumber;
        smsButtonModel.state = [NSNumber numberWithInt:1];
        smsButtonModel.name = kGTIOSMSMessage;
        [buttonModels addObject:smsButtonModel];
    }
    
    GTIOActionSheet *actionSheet = [[GTIOActionSheet alloc] initWithButtons:buttonModels buttonTapHandler:^(GTIOActionSheet *actionSheet, GTIOButton *buttonModel) {
        
        if ([buttonModel.name isEqualToString:kGTIOEmailMessage]) {
            [self createInviationWithType:kGTIOEmailMessageType toRecipients:[NSArray arrayWithObject:buttonModel.attribute]];
        } else if ([buttonModel.name isEqualToString:kGTIOSMSMessage]) {
            [self createInviationWithType:kGTIOSMSMessageType toRecipients:[NSArray arrayWithObject:buttonModel.attribute]];
        }
        
        [actionSheet dismiss];
    }];
    [actionSheet show];
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
    NSArray *peopleInSection = [self.contactList objectForKey:[sections objectAtIndex:section]];
    return [peopleInSection count];
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

#pragma mark - Composer Helpers

- (void)openMessageComposerWithRecipients:(NSArray *)recipients body:(NSString *)body
{
    GTIOMessageComposer *messageComposer = [[GTIOMessageComposer alloc] init];
    __block GTIOMessageComposer *blockMessageComposer = messageComposer;
    [messageComposer setRecipients:recipients];
    [messageComposer setBody:body];
    [messageComposer setDidFinishHandler:^(MFMessageComposeViewController *controller, MessageComposeResult result) {
        [blockMessageComposer dismissModalViewControllerAnimated:YES];
    }];
    [self.navigationController presentModalViewController:messageComposer animated:YES];
}

- (void)openMailComposerWithRecipients:(NSArray *)recipients subject:(NSString *)subject body:(NSString *)body
{
    GTIOMailComposer *mailComposer = [[GTIOMailComposer alloc] init];
    [mailComposer.mailComposeViewController setToRecipients:recipients];
    [mailComposer.mailComposeViewController setSubject:subject];
    [mailComposer.mailComposeViewController setMessageBody:body isHTML:NO];
    [mailComposer setDidFinishHandler:^(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error){ 
        [mailComposer.mailComposeViewController dismissModalViewControllerAnimated:YES];
    }];
    [self.navigationController presentModalViewController:mailComposer.mailComposeViewController animated:YES];
}

- (void)openTweetComposerWithTweet:(NSString *)tweet url:(NSURL *)url
{
    if ([TWTweetComposeViewController canSendTweet]) {
        GTIOTweetComposer *tweetComposer = [[GTIOTweetComposer alloc] initWithText:tweet URL:url completionHandler:^(TWTweetComposeViewControllerResult result) {
            [self dismissModalViewControllerAnimated:YES];
        }];
        
        [self presentViewController:tweetComposer animated:YES completion:nil];
    } else {
        [[[GTIOAlertView alloc] initWithTitle:nil message:kGTIONoTwitterMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)createInviationWithType:(NSString *)invitationType toRecipients:(NSArray *)recipients
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __block typeof(self) blockSelf = self;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/invitation/create" usingBlock:^(RKObjectLoader *loader) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: 
                                        invitationType, @"type",
                                        nil];
        loader.params = GTIOJSONParams(params);
        loader.method = RKRequestMethodPOST;
        loader.onDidLoadObjects = ^(NSArray *objects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOInvitation class]]) {
                    GTIOInvitation *invitation = (GTIOInvitation *)object;
                    if ([invitationType isEqualToString:kGTIOEmailMessageType]) {
                        [blockSelf openMailComposerWithRecipients:[NSArray array] subject:invitation.subject body:invitation.body];
                    } else if ([invitationType isEqualToString:kGTIOSMSMessageType]){
                        [blockSelf openMessageComposerWithRecipients:[NSArray array] body:invitation.body];
                    } else if ([invitationType isEqualToString:kGTIOTweetMessageType]){
                        [blockSelf openTweetComposerWithTweet:invitation.body url:invitation.twitterURL];
                    }                    
                }
            }            
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                [self createInviationWithType:invitationType toRecipients:recipients];
            }];
        };
    }];
    
}

@end
