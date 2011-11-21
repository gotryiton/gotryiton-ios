//
//  GTIOAddStylistsViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/19/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOAddStylistsViewController.h"
#import <AddressBook/AddressBook.h>
#import <RestKit/Three20/Three20.h>
#import "GTIOBrowseList.h"
#import "NSObject_Additions.h"
#import "GTIOListSection.h"
#import "GTIOProfile.h"
#import "GTIOHeaderView.h"
#import "GTIOAnalyticsTracker.h"

NSString* kGTIOInviteSMSPath = @"/stylists/invite/sms";
NSString* kGTIOInviteEmailPath = @"/stylists/invite/email";
NSString* kGTIOInviteFacebookPath = @"/stylists/invite/facebook";

@interface GTIOFacebookConnectTableItem : TTTableTextItem
@end
@implementation GTIOFacebookConnectTableItem
@end

@interface GTIOFacebookConnectTableItemCell : TTTableTextItemCell {
    UIButton* _facebookButton;
    UILabel* _titleLabel;
    UILabel* _label1;
    UILabel* _label2;
}
@end

@implementation GTIOFacebookConnectTableItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 175.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
        _facebookButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_facebookButton addTarget:self action:@selector(fbButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_facebookButton setImage:[UIImage imageNamed:@"add-fb.png"] forState:UIControlStateNormal];
        [_facebookButton sizeToFit];
        [self.contentView addSubview:_facebookButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = RGBCOLOR(80,80,80);
        _titleLabel.text = @"find your Facebook contacts!";
        [self.contentView addSubview:_titleLabel];
        
        _label1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label1.font = [UIFont systemFontOfSize:12];
        _label1.textColor = RGBCOLOR(88,88,88);
        _label1.text = @"you can sign in with Facebook and still remain completely anonymous if you like.";
        _label1.numberOfLines = 2;
        _label1.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_label1];
        
        _label2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label2.font = [UIFont systemFontOfSize:12];
        _label2.textColor = RGBCOLOR(88,88,88);
        _label2.text = @"...and we'll NEVER post to your wall or anything like that without your consent.";
        _label2.numberOfLines = 2;
        _label2.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_label2];
    }
    return self;
}

- (void)dealloc {
    [_facebookButton release];
    [_titleLabel release];
    [_label1 release];
    [_label2 release];
    [super dealloc];
}

- (void)fbButtonWasPressed:(id)sender {
    [[GTIOUser currentUser] loginWithFacebook];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _facebookButton.frame = CGRectOffset(_facebookButton.bounds, floor((320-_facebookButton.bounds.size.width)/2), 40);
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectOffset(_titleLabel.bounds, floor((320 - _titleLabel.bounds.size.width)/2), 15);
    _label1.frame = CGRectMake((320-230)/2,90,230, 40);
    _label2.frame = CGRectMake((320-230)/2,130,230, 40);
}

@end

@interface GTIOSelectableTableItem : TTTableImageItem {
@private
    BOOL _selected;
    NSString* _calloutURL;
    NSString* _subtitle;
}

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) NSString* calloutURL;
@property (nonatomic, retain) NSString* subtitle;

@end

@implementation GTIOSelectableTableItem

@synthesize selected = _selected;
@synthesize calloutURL = _calloutURL;
@synthesize subtitle = _subtitle;

- (void)dealloc {
    [_calloutURL release];
    [_subtitle release];
    [super dealloc];
}

@end

@interface GTIOSelectableTableCell : TTTableImageItemCell {
    UIImageView* _checkboxView;
    UIButton* _calloutButton;
    UILabel* _subtitleLabel;
}
@end

@implementation GTIOSelectableTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
        _checkboxView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add-checkbox-OFF.png"]];
        [self.contentView addSubview:_checkboxView];
        _calloutButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_calloutButton setImage:[UIImage imageNamed:@"add-view-profile.png"] forState:UIControlStateNormal];
        [_calloutButton addTarget:self action:@selector(calloutButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_calloutButton];
    }
    return self;
}

- (void)dealloc {
    [_checkboxView release];
    [_calloutButton release];
    [_subtitleLabel release];
    [super dealloc];
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	return 40;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _checkboxView.frame = CGRectMake(285,5,30,30);
    if (_imageView2.urlPath) {
        _imageView2.frame = CGRectMake(5,5,30,30);
        _imageView2.layer.borderColor = RGBCOLOR(218,218,218).CGColor;
        _imageView2.layer.borderWidth = 1;
        self.textLabel.frame = CGRectOffset(self.textLabel.frame, -20, 0);
    }
    [self.textLabel sizeToFit];
    _calloutButton.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame)+5, 10, 21, 21);
}

- (void)calloutButtonWasPressed:(id)sender {
    GTIOSelectableTableItem* item = (GTIOSelectableTableItem*)_item;
    TTOpenURL(item.calloutURL);
}

- (void)setObject:(id)object {
    [super setObject:object];
    GTIOSelectableTableItem* item = (GTIOSelectableTableItem*)object;
    if (item.selected) {
        _checkboxView.image = [UIImage imageNamed:@"add-checkbox-ON.png"];
    } else {
        _checkboxView.image = [UIImage imageNamed:@"add-checkbox-OFF.png"];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.textLabel.font = [UIFont systemFontOfSize:16];
    if (item.calloutURL) {
        [self.contentView addSubview:_calloutButton];
    } else {
        [_calloutButton removeFromSuperview];
    }
    [self setNeedsLayout];
}

@end

@interface GTIOAddStylistsListDataSource : TTListDataSource
@end
@implementation GTIOAddStylistsListDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOSelectableTableItem class]]) {
        return [GTIOSelectableTableCell class];
    } if ([object isKindOfClass:[GTIOFacebookConnectTableItem class]]) {
        return [GTIOFacebookConnectTableItemCell class];
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
	} if ([object isKindOfClass:[GTIOFacebookConnectTableItem class]]) {
        return [GTIOFacebookConnectTableItemCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end

@interface GTIOAddStylistTableViewDelegate : TTTableViewVarHeightDelegate
@end

@implementation GTIOAddStylistTableViewDelegate

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (NO == [tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
		return nil;
	}
	
	NSString* title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
	if (title.length > 0) {
		UILabel* label = [[UILabel alloc] init];
		label.text = title;
		label.font = [UIFont systemFontOfSize:12];
		label.textColor = RGBCOLOR(147,147,147);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[label sizeToFit];
		
		UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        container.backgroundColor = RGBCOLOR(227,227,227);
		[container addSubview:label];
        label.frame = CGRectOffset(label.frame, 5, 2);
		[label release];
		
		return container;
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(nil != [self tableView:tableView viewForHeaderInSection:section]) {
        return 20.0f;
    } else {
        return 0;
    }
}

@end

@implementation GTIOAddStylistsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _emailsToInvite = [NSMutableArray new];
        _profileIDsToInvite = [NSMutableArray new];
        _customEmailAddresses = [NSMutableArray new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn:) name:kGTIOUserDidUpdateProfileNotificationName object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_emailsToInvite release];
    [_profileIDsToInvite release];
    [_customEmailAddresses release];
    [super dealloc];
}

- (void)userLoggedIn:(NSNotification*)note {
    [self invalidateModel];
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
    
    return [arrayOfEmails sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (void)viewDidUnload {
    [_tabBar release];
    _tabBar = nil;
    [_doneButton release];
    _doneButton = nil;
    [_emailField release];
    _emailField = nil;
}

- (void)loadView {
    [super loadView];
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"ADD STYLISTS"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"full-wallpaper.png"]];
    self.variableHeightRows = YES;
    
    _emailField = [[UITextField alloc] initWithFrame:CGRectZero];
    _emailField.delegate = self;
    _emailField.placeholder = @"type a friend's email address";
    _emailField.returnKeyType = UIReturnKeyDone;
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    _tabBar = [[TTTabBar alloc] initWithFrame:CGRectMake(0,0,320,50)];
    _tabBar.backgroundColor = [UIColor clearColor];
    _tabBar.style = TTSTYLEVAR(addAStylistTabStyle);
    _tabBar.tabStyle = @"addAStylistTab:";
    [_tabBar setTabItems:[NSArray arrayWithObjects:
                          [[[TTTabItem alloc] initWithTitle:@"CONNECTIONS"] autorelease],
                          [[[TTTabItem alloc] initWithTitle:@"RECOMMENDED"] autorelease],
                          [[[TTTabItem alloc] initWithTitle:@"INVITE"] autorelease],
                          nil]];
    _tabBar.contentMode = UIViewContentModeScaleToFill;
    [_tabBar setDelegate:self];
    [self.view addSubview:_tabBar];
    
    _doneButton = [[GTIOBarButtonItem alloc] initPinkButtonWithTitle:@"done" target:self action:@selector(doneButtonWasPressed:) backButton:NO];
    self.navigationItem.rightBarButtonItem = _doneButton;
    
//    _buttonView = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.view.height,320,66)];
//    _buttonView.image = [UIImage imageNamed:@"add-done-ON.png"];
//    _buttonView.userInteractionEnabled = YES;
//    _doneButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
//    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
//    _doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    [_doneButton addTarget:self action:@selector(doneButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
//    _doneButton.frame = CGRectMake(13, 20, 320-26, 33);
//    [_buttonView addSubview:_doneButton];
//    [self.view addSubview:_buttonView];
    
    self.tableView.frame = CGRectMake(0, _tabBar.bounds.size.height, self.tableView.bounds.size.width, self.view.bounds.size.height - _tabBar.bounds.size.height);
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
    
    //re-making the button because you can't change the title of a custom GTIOBarButtonItem
    TT_RELEASE_SAFELY(_doneButton);
    _doneButton = [[GTIOBarButtonItem alloc] initPinkButtonWithTitle:[NSString stringWithFormat:@"done%@", (sum > 0 ? [NSString stringWithFormat:@" (%d)", sum] : @"")] target:self action:@selector(doneButtonWasPressed:) backButton:NO];
    self.navigationItem.rightBarButtonItem = _doneButton;
    
    
    
//    [_doneButton setTitle:[NSString stringWithFormat:@"done%@", (sum > 0 ? [NSString stringWithFormat:@" (%d)", sum] : @"")] forState:UIControlStateNormal];
    
    // Move done button on or off the screen
//    if (_buttonView.frame.origin.y >= self.view.bounds.size.height && sum > 0) {
//        [UIView beginAnimations:nil context:nil];
//        _buttonView.frame = CGRectMake(0, self.view.bounds.size.height - _buttonView.bounds.size.height, _buttonView.bounds.size.width, _buttonView.bounds.
//                                       size.height);
//        self.tableView.frame = CGRectMake(0, _tabBar.bounds.size.height, self.tableView.bounds.size.width, self.view.bounds.size.height - _tabBar.bounds.size.height - _buttonView.bounds.size.height + 6);
//        [UIView commitAnimations];
//    } else if (sum == 0 && _buttonView.frame.origin.y < self.view.bounds.size.height) {
//        [UIView beginAnimations:nil context:nil];
//        _buttonView.frame = CGRectMake(0, self.view.bounds.size.height, _buttonView.bounds.size.width, _buttonView.bounds.size.height);
//        self.tableView.frame = CGRectMake(0, _tabBar.bounds.size.height, self.tableView.bounds.size.width, self.view.bounds.size.height - _tabBar.bounds.size.height);
//        [UIView commitAnimations];
//    }
}

- (void)selectedItem:(GTIOSelectableTableItem*)item {
    NSLog(@"Item: %@", item);
    item.selected = !item.selected;
    id emailOrProfile = item.userInfo;
    if ([emailOrProfile isKindOfClass:[GTIOProfile class]]) {
        NSString* profileID = [(GTIOProfile*)emailOrProfile uid];
        if (item.selected) {
            if (![_profileIDsToInvite containsObject:profileID]){
                [_profileIDsToInvite addObject:profileID];
            }
        } else {
            [_profileIDsToInvite removeObject:profileID];
        }
    } else {
        if (item.selected) {
            if (![_emailsToInvite containsObject:emailOrProfile]){
                [_emailsToInvite addObject:emailOrProfile];
            }
        } else {
            [_emailsToInvite removeObject:emailOrProfile];
        }
    }
    // Handles Reloading of the appropriate cells and selecting/deselecting matchhing cells.
    NSMutableArray* indexPaths = [NSMutableArray array];
    for (NSArray* items in [(TTSectionedDataSource*)self.dataSource items]) {
        for (GTIOSelectableTableItem* tableItem in items) {
            NSLog(@"Comparing: %@ == %@", item.userInfo, tableItem.userInfo);
            if ([tableItem isKindOfClass:[GTIOSelectableTableItem class]] &&
                [item.userInfo isEqual:tableItem.userInfo]) {
                //                - (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object
                tableItem.selected = item.selected;
                [indexPaths addObject:[self.dataSource tableView:self.tableView indexPathForObject:tableItem]];
            }
        }
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    NSLog(@"Emails: %@", _emailsToInvite);
    NSLog(@"Profiles: %@", _profileIDsToInvite);
    [self updateDoneButton];
}

- (id)createDelegate {
    return [[[GTIOAddStylistTableViewDelegate alloc] initWithController:self] autorelease];
}

- (id)itemForEmailAddress:(NSString*)email {
    GTIOSelectableTableItem* item = [GTIOSelectableTableItem itemWithText:email URL:nil];
    item.delegate = self;
    item.selector = @selector(selectedItem:);
    item.userInfo = email;
    if ([_emailsToInvite containsObject:email]) {
        item.selected = YES;
    }
    return item;
}

- (void)createModel {
    if(nil != _inviteOverlay) {
        [_inviteOverlay removeFromSuperview];
        TT_RELEASE_SAFELY(_inviteOverlay);
    }
    
    // Depending on tab, load a different API Endpoint
    NSUInteger index = _tabBar.selectedTabIndex;
    NSString* apiEndpoint = nil;
    NSDictionary* params = nil;
    if (index == GTIONetworkTab) {
        GTIOAnalyticsEvent(kAddStylistsEventName);
        apiEndpoint = GTIORestResourcePath(@"/stylists/network");
        NSArray* emails = [self getEmailAddressesFromContacts];
        NSLog(@"Emails: %@", emails);
        NSString* emailsAsJSON = [emails jsonEncode];
        params = [NSDictionary dictionaryWithObjectsAndKeys:emailsAsJSON, @"emailContacts", nil];
        params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    } else if (index == GTIOInviteTab) {
        GTIOAnalyticsEvent(kAddContactsStylistsEventName);

        NSLog(@"On the invite tab");
        
        self.dataSource = [TTSectionedDataSource dataSourceWithArrays:nil];
        
        _inviteOverlay = [[UIView alloc] initWithFrame:self.tableView.frame];
        
        UIImageView* inviteBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invite-bg.png"]];
        [inviteBackground setFrame:CGRectMake(0, 0, _inviteOverlay.width, _inviteOverlay.height)];
        
        //facebook
        UIButton* facebookInviteButton = [[UIButton alloc] initWithFrame:CGRectMake(23, 158, 90, 90)];
        [facebookInviteButton setBackgroundImage:[UIImage imageNamed:@"invite-fb-OFF.png"] forState:UIControlStateNormal];
        [facebookInviteButton setBackgroundImage:[UIImage imageNamed:@"invite-fb-ON.png"] forState:UIControlStateHighlighted];
        [facebookInviteButton addTarget:self action:@selector(facebookInviteWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //sms
        UIButton* smsInviteButton = [[UIButton alloc] initWithFrame:CGRectMake(115, 158, 90, 90)];
        [smsInviteButton setBackgroundImage:[UIImage imageNamed:@"invite-sms-OFF.png"] forState:UIControlStateNormal];
        [smsInviteButton setBackgroundImage:[UIImage imageNamed:@"invite-sms-ON.png"] forState:UIControlStateHighlighted];
        [smsInviteButton addTarget:self action:@selector(smsInviteWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //email
        UIButton* emailInviteButton = [[UIButton alloc] initWithFrame:CGRectMake(207, 158, 90, 90)];
        [emailInviteButton setBackgroundImage:[UIImage imageNamed:@"invite-email-OFF.png"] forState:UIControlStateNormal];
        [emailInviteButton setBackgroundImage:[UIImage imageNamed:@"invite-email-ON.png"] forState:UIControlStateHighlighted];
        [emailInviteButton addTarget:self action:@selector(emailInviteWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //labels
        UILabel* facebookLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 244, 90, 20)];
        [facebookLabel setBackgroundColor:[UIColor clearColor]];
        [facebookLabel setTextAlignment:UITextAlignmentCenter];
        [facebookLabel setFont:kGTIOFontBoldHelveticaNeueOfSize(12)];
        [facebookLabel setTextColor:kGTIOColorB4B4B4];
        [facebookLabel setText:@"facebook"];
        
        UILabel* smsLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 244, 90, 20)];
        [smsLabel setBackgroundColor:[UIColor clearColor]];
        [smsLabel setTextAlignment:UITextAlignmentCenter];
        [smsLabel setFont:kGTIOFontBoldHelveticaNeueOfSize(12)];
        [smsLabel setTextColor:kGTIOColorB4B4B4];
        [smsLabel setText:@"sms"];
        
        UILabel* emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(207, 244, 90, 20)];        
        [emailLabel setBackgroundColor:[UIColor clearColor]];
        [emailLabel setTextAlignment:UITextAlignmentCenter];
        [emailLabel setFont:kGTIOFontBoldHelveticaNeueOfSize(12)];
        [emailLabel setTextColor:kGTIOColorB4B4B4];
        [emailLabel setText:@"email"];
        
        [_inviteOverlay addSubview:inviteBackground];
        [_inviteOverlay addSubview:facebookInviteButton];
        [_inviteOverlay addSubview:smsInviteButton];
        [_inviteOverlay addSubview:emailInviteButton];
        
        [_inviteOverlay addSubview:facebookLabel];
        [_inviteOverlay addSubview:smsLabel];
        [_inviteOverlay addSubview:emailLabel];
        
        [inviteBackground release];
        [facebookInviteButton release];
        [smsInviteButton release];
        [emailInviteButton release];
        
        [facebookLabel release];
        [smsLabel release];
        [emailLabel release];
        
        [self.view addSubview:_inviteOverlay];
        
//        NSMutableArray* section1 = [NSMutableArray arrayWithCapacity:[_customEmailAddresses count] + 1];
//        TTTableControlItem* item = [TTTableControlItem itemWithCaption:nil control:(UIControl*)_emailField];
//        [section1 addObject:item];
//        for (NSString* email in _customEmailAddresses) {
//            [section1 addObject:[self itemForEmailAddress:email]];
//        }
//        NSArray* emailsAddresses = [self getEmailAddressesFromContacts];
//        NSMutableArray* section2 = [NSMutableArray arrayWithCapacity:[emailsAddresses count]];
//        for (NSString* email in emailsAddresses) {
//            [section2 addObject:[self itemForEmailAddress:email]];
//        }        
//        self.dataSource = [GTIOAddStylistsSectionedDataSource dataSourceWithArrays:@"enter an email address", section1,
//                           @"choose from your phone contacts", section2, nil];
        return;
    } else {
        GTIOAnalyticsEvent(kAddRecommendedStylistsEventName);
        apiEndpoint = GTIORestResourcePath(@"/stylists/recommended");
        params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    }
    
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:apiEndpoint delegate:nil];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    objectLoader.cacheTimeoutInterval = 5*60;
    RKObjectLoaderTTModel* model = [RKObjectLoaderTTModel modelWithObjectLoader:objectLoader];
    
    GTIOAddStylistsListDataSource* ds = (GTIOAddStylistsListDataSource*)[GTIOAddStylistsListDataSource dataSourceWithObjects:nil];
    ds.model = model;
    self.dataSource = ds;
}

- (void)didLoadModel:(BOOL)firstTime {
    // TODO: 
    // use featuredText for "% helpful".
    RKObjectLoaderTTModel* model = (RKObjectLoaderTTModel*)self.model;
    if ([model isKindOfClass:[RKObjectLoaderTTModel class]]) {
        GTIOBrowseList* list = [model.objects objectWithClass:[GTIOBrowseList class]];
        NSArray* sections = list.sections;
        NSLog(@"List: %@, sections: %@", list, sections);
        NSMutableArray* sectionTitles = [NSMutableArray array];
        NSMutableArray* sectionItems = [NSMutableArray array];
        for (GTIOListSection* section in sections) {
            [sectionTitles addObject:section.title];
            NSMutableArray* items = [NSMutableArray array];
            for (GTIOProfile* stylist in section.stylists) {
                NSString* url = nil;
                GTIOSelectableTableItem* item = [GTIOSelectableTableItem itemWithText:stylist.displayName imageURL:stylist.profileIconURL URL:url];
                NSLog(@"Featured Text: %@", stylist.featuredText);
                
                item.subtitle = stylist.featuredText;
                item.calloutURL = [NSString stringWithFormat:@"gtio://profile/%@", stylist.uid];
                
                item.delegate = self;
                item.selector = @selector(selectedItem:);
                item.userInfo = stylist;
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
        GTIOUser* user = [GTIOUser currentUser];
        if (_tabBar.selectedTabIndex == GTIONetworkTab && [user.isFacebookConnected boolValue] == NO) {
            // ADD FB Login Item Section here.
            [sectionTitles addObject:@"connect to Facebook"];
            [sectionItems addObject:[NSArray arrayWithObject:[[[GTIOFacebookConnectTableItem alloc] init] autorelease]]];
        }
        GTIOAddStylistsSectionedDataSource* ds = (GTIOAddStylistsSectionedDataSource*)[GTIOAddStylistsSectionedDataSource dataSourceWithItems:sectionItems sections:sectionTitles];
        ds.model = model;
        self.dataSource = ds;
    }
}

- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex {
    [self invalidateModel];
}

#pragma mark - Button Action Methods

- (void)doneButtonWasPressed:(id)sender {
    [self showLoading];
    [[GTIOAnalyticsTracker sharedTracker] trackUserDidAddStylists:[NSNumber numberWithInt:([_emailsToInvite count] + [_profileIDsToInvite count])]];
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/stylists/add") delegate:self];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[_emailsToInvite jsonEncode], @"stylistEmails",
                            [_profileIDsToInvite jsonEncode], @"stylistUids", nil];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    loader.method = RKRequestMethodPOST;
    [loader send];
}

- (void)facebookInviteWasPressed:(id)sender {
    NSLog(@"facebook invite pressed!");
    
    NSDictionary* params = [NSDictionary dictionary];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    
    [[RKClient sharedClient] post:GTIORestResourcePath(kGTIOInviteFacebookPath) params:params delegate:self];
    
    [self showLoading];
}

- (void)smsInviteWasPressed:(id)sender {
    NSLog(@"sms invite pressed!");

    NSDictionary* params = [NSDictionary dictionary];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    
    [[RKClient sharedClient] post:GTIORestResourcePath(kGTIOInviteSMSPath) params:params delegate:self];
    
    [self showLoading];
}

- (void)emailInviteWasPressed:(id)sender {
    NSLog(@"email invite pressed!");
    
    NSDictionary* params = [NSDictionary dictionary];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    
    [[RKClient sharedClient] post:GTIORestResourcePath(kGTIOInviteEmailPath) params:params delegate:self];
    
    [self showLoading];
}

#pragma mark - RKRequestDelegate methods

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    
    NSError* error = nil;
    NSDictionary* body = [response parsedBody:&error];
    
    [self hideLoading];
    
    NSLog(@"resource path: %@", request.resourcePath);
    
    if([request.resourcePath rangeOfString:kGTIOInviteSMSPath].location != NSNotFound) {
        
        NSString* text = [body valueForKey:@"text"];
        
        GTIOMessageComposer* composer = [[GTIOMessageComposer alloc] init];
        // TODO: outfit id not used in composer creation method - ask jeremy if should be removed
        [self.navigationController presentModalViewController:[composer textMessageComposerWithOutfitID:@"" body:text] animated:YES]; 
    } else if([request.resourcePath rangeOfString:kGTIOInviteEmailPath].location != NSNotFound) {
        
        NSString* text = [body valueForKey:@"text"];
        NSString* subject = [body valueForKey:@"subject"];
        
        GTIOMessageComposer* composer = [[GTIOMessageComposer alloc] init];
        // TODO: again, the outfit id is irrelevant
        [self.navigationController presentModalViewController:[composer emailComposerWithOutfitID:@"" subject:subject body:text] animated:YES];
    } else if([request.resourcePath rangeOfString:kGTIOInviteFacebookPath].location != NSNotFound) {
        
        //grab title and url 
        NSString* title = [body valueForKey:@"text"];
        NSString* url = [body valueForKey:@"url"];
        
        GTIOFacebookInviteTableViewController* controller = [[GTIOFacebookInviteTableViewController alloc] initWithInviteTitle:title imageURL:url];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    [self hideLoading];
    GTIOErrorMessage(error);
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    NSLog(@"Error: %@", error);
    [self hideLoading];
    GTIOErrorMessage(error);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Objects: %@", objects);
    [self hideLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textLooksLikeAnEmail:(NSString*)text {
    return [text rangeOfString:@"@"].length == 1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString* text = [[textField.text copy] autorelease];
    
    if ([text isWhitespaceAndNewlines]) {
        return NO;
    }
    
    if ([self textLooksLikeAnEmail:text]) {
        textField.text = nil;
        if (![_customEmailAddresses containsObject:text]) {
            [_customEmailAddresses insertObject:text atIndex:0];
            if (![_emailsToInvite containsObject:text]){
                [_emailsToInvite addObject:text];
                [self updateDoneButton];
            }
        }
        [self invalidateModel];
    } else {
        TTAlert(@"Please enter a valid email address");
    }
    
    return NO;
}

@end
