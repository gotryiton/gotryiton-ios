//
//  GTIOProfileCreatedAddStylistsViewController.m
//  GTIO
//
//  Created by Duncan Lewis on 11/10/11.
//  Copyright (c) 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOProfileCreatedAddStylistsViewController.h"

@implementation GTIOProfileCreatedAddStylistsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _stylists = nil;
        _stylistsToAdd = [NSMutableArray new];
        [GTIOUser currentUser].showAlmostDoneScreen = [NSNumber numberWithBool:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserNotificationFired:) name:kGTIOUserDidUpdateProfileNotificationName object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    TT_RELEASE_SAFELY(_stylists);
    TT_RELEASE_SAFELY(_addStylistContainer);
    TT_RELEASE_SAFELY(_addStylistsLabel);
    TT_RELEASE_SAFELY(_connectWithStylistsLabel);
    TT_RELEASE_SAFELY(_loadingStylistsLabel);
    TT_RELEASE_SAFELY(_stylistsToAdd);
    TT_RELEASE_SAFELY(_doneButton);
    [super dealloc];
}

- (void)viewDidUnload {
    TT_RELEASE_SAFELY(_profileThumbnailView);
    TT_RELEASE_SAFELY(_userNameLabel);
    TT_RELEASE_SAFELY(_userLocationLabel);
    [super viewDidUnload];
}

- (void)doneButtonAction {
    [[GTIOLoadingOverlayManager sharedManager] showLoading];
    
    [[GTIOAnalyticsTracker sharedTracker] trackUserDidAddStylists:[NSNumber numberWithInt:([_stylistsToAdd count])]];
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/stylists/add") delegate:self];
    
    NSMutableArray* stylistUIDs = [NSMutableArray array];
    for(GTIOProfile* stylist in _stylistsToAdd) {
        [stylistUIDs addObject:stylist.uid];
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [stylistUIDs jsonEncode], @"stylistUids",
                            @"1", @"quick-add", nil];
    loader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    loader.method = RKRequestMethodPOST;
    [loader send];
}

- (void)editButtonAction {
    TTOpenURL(@"gtio://profile/edit");
}

- (void)skipButtonAction {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)stylistSelected:(UIButton*)button {
    
    GTIOAddStylistButton* stylistButton = (GTIOAddStylistButton*)button;
    if(stylistButton.selected) {
        [stylistButton.checkboxView setImage:[UIImage imageNamed:@"add-checkbox-OFF.png"]];
        [_stylistsToAdd removeObject:stylistButton.profile];
    } else {
        [stylistButton.checkboxView setImage:[UIImage imageNamed:@"add-checkbox-ON.png"]];
        NSLog(@"stylist profile: %@", stylistButton.profile);
        [_stylistsToAdd addObject:stylistButton.profile];
    }
    
    stylistButton.selected = !stylistButton.selected;
    
    [self updateDoneButton];
    
    NSLog(@"Selected sylsits!: %@", _stylistsToAdd);
    
}

#pragma mark - Convience methods

- (void)updateDoneButton {
    int sum = [_stylistsToAdd count];
    
    if(sum == 0) {
        [_doneButton setTitle:@"done" forState:UIControlStateNormal];
    } else {
        [_doneButton setTitle:[NSString stringWithFormat:@"done - add %d stylist%@!", sum, (sum > 1 ? @"s" : @"")] forState:UIControlStateNormal];
    }
}

- (void)displayStylists {
    
    if(nil == _stylists) {
        // TODO display some error text?
        return;
    }
    
    // got the stylists, proceed!
    NSLog(@"Stylists: %d", [_stylists.stylists count]);
    
    // start at 120
    int heightInContainer = 120;
    int heightOfStylists = 40;
    int heightBetweenStylists = 4;
    int containerXOffset = 9;
    int bottomPadding = 20;
    
    for(GTIOProfile* profile in _stylists.stylists) {
        NSLog(@"stylist: %@", profile);
        
        CGRect stylistRect = CGRectMake(containerXOffset, heightInContainer + ( [_stylists.stylists indexOfObject:profile] * (heightOfStylists + heightBetweenStylists) ), _addStylistContainer.width - (2 * containerXOffset), heightOfStylists);
        
        GTIOAddStylistButton* stylistButton = [[GTIOAddStylistButton alloc] initWithTitle:profile.displayName subtitle:profile.stylistDescription imageURL:profile.profileIconURL];
        stylistButton.backgroundColor = [UIColor clearColor];
        [stylistButton addTarget:self action:@selector(stylistSelected:) forControlEvents:UIControlEventTouchUpInside];
        stylistButton.frame = stylistRect;
        [stylistButton setProfile:profile];
        
        [_addStylistContainer addSubview:stylistButton];
        [_stylistsToAdd addObject:stylistButton.profile];
        
    }
    
    [self updateDoneButton];

    _addStylistContainer.frame = CGRectMake(_addStylistContainer.frame.origin.x, _addStylistContainer.frame.origin.y, _addStylistContainer.width, bottomPadding + heightInContainer + ((heightOfStylists + heightBetweenStylists) * [_stylists.stylists count]) );
    
    _scrollView.contentSize = CGSizeMake(320, 62 + _addStylistContainer.height + 10);
    
    _addStylistsLabel.text = _stylists.title;
    [_addStylistsLabel sizeToFit];
    _addStylistsLabel.frame = CGRectMake(0, 16, _addStylistContainer.frame.size.width, _addStylistsLabel.frame.size.height);
    
    _connectWithStylistsLabel.text = _stylists.subtitle;
    [_connectWithStylistsLabel sizeToFit];
    _connectWithStylistsLabel.frame = CGRectMake(0, 41, _addStylistContainer.frame.size.width, _connectWithStylistsLabel.frame.size.height);
    
    // stylists
    
    _addStylistsLabel.alpha = 0;
    _connectWithStylistsLabel.alpha = 0;
    
    [UIView beginAnimations:nil context:nil];
    
    _addStylistsLabel.alpha = 1;
    _connectWithStylistsLabel.alpha = 1;
    
    [UIView commitAnimations];
    
}

#pragma mark - Data request methods

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

- (void)requestStylists {
    
    _loadingStylistsLabel = [[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleGray];
    _loadingStylistsLabel.frame = _addStylistContainer.frame;
    _loadingStylistsLabel.isAnimating = YES;
    [_scrollView addSubview:_loadingStylistsLabel];
    
    NSArray* emails = [self getEmailAddressesFromContacts];
    NSLog(@"Emails: %@", emails);
    NSString* emailsAsJSON = [emails jsonEncode];
    
    NSString* endpoint = GTIORestResourcePath(@"/stylists/quick-add");
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:emailsAsJSON, @"emailContacts", nil];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:endpoint delegate:self];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    objectLoader.cacheTimeoutInterval = 5*60;
    [objectLoader send];   
    
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"Loaded objects: %@", objects);
    
    if([objectLoader.resourcePath isEqualToString:GTIORestResourcePath(@"/stylists/add")]) {
        [[GTIOLoadingOverlayManager sharedManager] stopLoading];
        TTAlert([NSString stringWithFormat:@"nice, you have added %d stylists!", [_stylistsToAdd count]]);
        [self dismissModalViewControllerAnimated:YES];
        
    } else {
        
        NSLog(@"Object at index 1: %@", [objects objectAtIndex:1]);
        _stylists = [[objects objectAtIndex:1] retain];
        
        _loadingStylistsLabel.isAnimating = NO;
        [_loadingStylistsLabel removeFromSuperview];
        
        [self displayStylists];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Did fail load with error");
    
    if([objectLoader.resourcePath isEqualToString:GTIORestResourcePath(@"/stylists/add")]) {
        [self hideLoading];
        GTIOErrorMessage(error);
    } else {
        _loadingStylistsLabel.isAnimating = NO;
        [_loadingStylistsLabel removeFromSuperview];
    }
}

#pragma mark - View lifecycle

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    // the only option is the skip button, so dont even check the url
    [self skipButtonAction];
}

- (void)updateUserLabel {
    _userNameLabel.text = [[GTIOUser currentUser].username uppercaseString];
    [_userNameLabel sizeToFit];
    _userNameLabel.frame = CGRectOffset(_userNameLabel.bounds, 45, 6);
    
    _userLocationLabel.text = [GTIOUser currentUser].location;
    [_userLocationLabel sizeToFit];
    _userLocationLabel.frame = CGRectMake(45, 25, 200, _userLocationLabel.bounds.size.height);
    
    _profileThumbnailView.urlPath = [GTIOUser currentUser].profileIconURL;
}

- (void)updateUserNotificationFired:(NSNotification*)note {
    [self updateUserLabel];
}

- (void)loadView {
    [super loadView];

    UIImageView* bgImage = [[UIImageView alloc] initWithImage:TTSTYLEVAR(modalBackgroundImage)];
    bgImage.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 58);
    [bgImage setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];

    [self.view addSubview:bgImage];
    TT_RELEASE_SAFELY(bgImage);

    // user header view

    UIImageView* userHeaderBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outfit-navbar.png"]];
    [userHeaderBackground setFrame:CGRectMake(0, 0, 320, 44)];
    [userHeaderBackground setUserInteractionEnabled:YES];

    UIImageView* thumbOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home-thumb-overlay.png"]];
    [thumbOverlay setFrame:CGRectMake(1, 1, 42, 42)];

    _profileThumbnailView = [[TTImageView alloc] initWithFrame:CGRectMake(5, 5, 34, 34)];
    _profileThumbnailView.defaultImage = [UIImage imageNamed:@"empty-profile-pic.png"];

    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.frame = CGRectZero;
    _userNameLabel.font = kGTIOFetteFontOfSize(22);
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.backgroundColor = [UIColor clearColor];


    _userLocationLabel = [[UILabel alloc] init];
    _userLocationLabel.frame = CGRectZero;
    _userLocationLabel.font = [UIFont systemFontOfSize:13];
    _userLocationLabel.textColor = RGBCOLOR(156,156,156);
    _userLocationLabel.backgroundColor = [UIColor clearColor];

    //extracted from the bar button item

    // Calculate Size of Text
    NSString* title = @"edit";
    CGSize textSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:12.0]];
    // Create Container View
    UIView* view = [[UIView new] autorelease];
    [view setFrame:CGRectMake(260, 5, textSize.width+30, 32)];
    [view setUserInteractionEnabled:YES];
    // Create The Background Image
    UIImage* bg = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    // Create Button
    UIButton* editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setFrame:view.frame];
    [editButton setBackgroundColor:[UIColor clearColor]];
    [editButton setTitle:title forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton setBackgroundImage:bg forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [[editButton titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0]];
    [[editButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
    [[editButton titleLabel] setShadowColor:kGTIOColor888888];

    [userHeaderBackground addSubview:editButton];

    [userHeaderBackground addSubview:thumbOverlay];
    [userHeaderBackground addSubview:_profileThumbnailView];
    [userHeaderBackground addSubview:_userNameLabel];
    [userHeaderBackground addSubview:_userLocationLabel];
    [self.view addSubview:userHeaderBackground];

    TT_RELEASE_SAFELY(thumbOverlay);
    TT_RELEASE_SAFELY(userHeaderBackground);

    // scroll view

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 58)];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [_scrollView setBackgroundColor:[UIColor clearColor]];

    UIImageView* congratsBanner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-created-congratulations.png"]];
    [congratsBanner setFrame:CGRectMake(16, 0, 287, 51)];
    [congratsBanner setBackgroundColor:[UIColor clearColor]];

    [_scrollView addSubview:congratsBanner];
    TT_RELEASE_SAFELY(congratsBanner);


    _addStylistContainer = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"fb-container.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [_addStylistContainer setFrame:CGRectMake(9, 62, 302, 290)];
    [_addStylistContainer setBackgroundColor:[UIColor clearColor]];
    [_addStylistContainer setUserInteractionEnabled:YES];

    _addStylistsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _addStylistsLabel.font = kGTIOFontBoldHelveticaNeueOfSize(18);
    _addStylistsLabel.textColor = kGTIOColorED139A;
    [_addStylistsLabel sizeToFit];
    _addStylistsLabel.frame = CGRectMake(0, 16, _addStylistContainer.frame.size.width, _addStylistsLabel.frame.size.height);
    _addStylistsLabel.backgroundColor = [UIColor clearColor];
    _addStylistsLabel.textAlignment = UITextAlignmentCenter;
    _addStylistsLabel.alpha = 0;
                                 
    [_addStylistContainer addSubview:_addStylistsLabel];

    _connectWithStylistsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _connectWithStylistsLabel.numberOfLines = 2;
    _connectWithStylistsLabel.font = kGTIOFontHelveticaNeueOfSize(13);
    _connectWithStylistsLabel.textColor = kGTIOColor8E8E8E;
    [_connectWithStylistsLabel sizeToFit];
    _connectWithStylistsLabel.frame = CGRectMake(0, 41, _addStylistContainer.frame.size.width, _connectWithStylistsLabel.frame.size.height);
    _connectWithStylistsLabel.backgroundColor = [UIColor clearColor];
    _connectWithStylistsLabel.textAlignment = UITextAlignmentCenter;
    _connectWithStylistsLabel.alpha = 0;

    [_addStylistContainer addSubview:_connectWithStylistsLabel];


    NSString* skipText = @"skip this step";

    NSMutableAttributedString* attributedSkipText = [[NSMutableAttributedString alloc] initWithString:skipText];

    [attributedSkipText setTextColor:kGTIOColorB4B4B4 range:NSMakeRange(0, attributedSkipText.length)];
    [attributedSkipText setFont:kGTIOFontHelveticaNeueOfSize(12)];
    [attributedSkipText setTextAlignment:kCTCenterTextAlignment lineBreakMode:kCTLineBreakByWordWrapping];
    
    TTTAttributedLabel* skipLabel = [[TTTAttributedLabel new] autorelease];
    [skipLabel setFrame:CGRectMake(191, 90, 80, 28)];
    [skipLabel setBackgroundColor:[UIColor clearColor]];
    [skipLabel setNumberOfLines:0];
    [skipLabel setText:attributedSkipText];

    NSMutableDictionary* dict = [[skipLabel.linkAttributes mutableCopy] autorelease];
    [dict setValue:(id)kGTIOColorB4B4B4.CGColor forKey:(NSString*)kCTForegroundColorAttributeName];
    skipLabel.linkAttributes = dict;

    [skipLabel addLinkToURL:[NSURL URLWithString:@"gtio://profile/new/addStylists/skip"] withRange:NSMakeRange(0, 14)];
    skipLabel.userInteractionEnabled = YES;
    [skipLabel setDelegate:self];

    [_addStylistContainer addSubview:skipLabel];

    UIImageView* skipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-created-skip-chevron.png"]];
    [skipIcon setFrame:CGRectMake(274, 91, 9, 13)];
    [skipIcon setBackgroundColor:[UIColor clearColor]];

    [_addStylistContainer addSubview:skipIcon];
    TT_RELEASE_SAFELY(skipIcon);

    [_scrollView addSubview:_addStylistContainer];

    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(320, 62 + _addStylistContainer.height + 10)];

    // bottom

    UIImageView* buttonView = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height - 66,320,66)];
    buttonView.image = [UIImage imageNamed:@"add-done-ON.png"];
    buttonView.userInteractionEnabled = YES;
    [buttonView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];

    _doneButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _doneButton.frame = CGRectMake(13, 20, 320-26, 33);

    [buttonView addSubview:_doneButton];
    [self.view addSubview:buttonView];

    TT_RELEASE_SAFELY(buttonView);

    [self updateUserLabel];
    
    [self requestStylists];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
