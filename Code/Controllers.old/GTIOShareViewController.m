//
//  GTIOShareViewController.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/3/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOShareViewController.h"
#import "GTIOSectionedDataSource.h"
#import "GTIOTableImageControlItem.h"

@implementation GTIOShareViewController

@synthesize opinionRequest = _opinionRequest;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if (self = [super initWithNavigatorURL:URL query:query]) {
		self.opinionRequest = [query objectForKey:@"opinionRequest"];
		
		// Navigation Item
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(shareTitleImage)] autorelease];		
		self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"back" 
																				  style:UIBarButtonItemStyleBordered 
																				 target:nil 
																				 action:nil] autorelease];		
		
		// Table View
		self.tableViewStyle = UITableViewStyleGrouped;
		self.tableView.backgroundColor = [UIColor clearColor];
		self.tableView.rowHeight = 56;
		
		_privateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)]; // 8 is the height of container - height of self / 2
		_privateLabel.text = @"";
		_privateLabel.backgroundColor = [UIColor clearColor];
		_privateLabel.numberOfLines = 2;
		_privateLabel.textColor = TTSTYLEVAR(greyTextColor);
		_privateLabel.font = [UIFont boldSystemFontOfSize:14];
		_privateLabel.textAlignment = UITextAlignmentCenter;
		
		// Center the label in a container to give it spacing from the bottom of the table view
		UIView* footerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
		[footerContainerView addSubview:_privateLabel];
		self.tableView.tableFooterView = footerContainerView;
		[footerContainerView release];		
		
		// Controls
		_createMyOutfitPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_createMyOutfitPageButton.frame = CGRectMake(7, 10, 305, 48);
		[_createMyOutfitPageButton setImage:TTSTYLEVAR(createMyOutfitPageButtonImageNormal) forState:UIControlStateNormal];
		[_createMyOutfitPageButton setImage:TTSTYLEVAR(createMyOutfitPageButtonImageHighlighted) forState:UIControlStateHighlighted];
		[_createMyOutfitPageButton addTarget:self action:@selector(createMyOutfitButtonWasTouched:) forControlEvents:UIControlEventTouchUpInside];
		
		// Center the button in a container to give it spacing from the bottom of the table view
		UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
		[containerView addSubview:_createMyOutfitPageButton];
		self.tableView.tableHeaderView = containerView;
		[containerView release];
		
		_shareSwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
		_facebookSwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
		_twitterSwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
		_alertMeWithFeedbackSwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
		_keepThisLookPrivateSwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
		
		// Set defaults values for controls
		GTIOUser* user = [GTIOUser currentUser];
		_keepThisLookPrivateSwitch.on = NO;
		_facebookSwitch.on = user.isRegisteredWithFacebook ? _opinionRequest.shareOnFacebook : NO;
		_twitterSwitch.on = user.isRegisteredWithTwitter ? _opinionRequest.shareOnTwitter : NO;
		_alertMeWithFeedbackSwitch.on = _opinionRequest.alertMeWithFeedback;
		
 		_shareSwitch.on = _opinionRequest.shareWithContacts && [_opinionRequest.contactEmails count] > 0;
		[_shareSwitch addTarget:self action:@selector(shareSwitchToggled:) forControlEvents:UIControlEventTouchUpInside];
		
		[_keepThisLookPrivateSwitch addTarget:self action:@selector(togglePrivateLabelText:) forControlEvents:UIControlEventTouchUpInside];
		
		[[TTNavigator navigator].URLMap from:@"gtio://share/addContacts" toObject:self selector:@selector(addContactWasTouched)];
	}
	
	return self;
}

- (void)dealloc {
	[[TTNavigator navigator].URLMap removeURL:@"gtio://share/addContacts"];
	TT_RELEASE_SAFELY(_opinionRequest);
	TT_RELEASE_SAFELY(_shareSwitch);
	TT_RELEASE_SAFELY(_facebookSwitch);
	TT_RELEASE_SAFELY(_twitterSwitch);
	TT_RELEASE_SAFELY(_alertMeWithFeedbackSwitch);
	TT_RELEASE_SAFELY(_keepThisLookPrivateSwitch);
	TT_RELEASE_SAFELY(_privateLabel);
	[super dealloc];
}

- (void)loadView {
	[super loadView];
	
	TTOpenURL(@"gtio://analytics/trackUserDidViewContacts");
}

- (void)didReceiveMemoryWarning {
    ;
}

- (void)createModel {
	GTIOUser* user = [GTIOUser currentUser];
	
	TTStyledText* styledText = [TTStyledText textFromXHTML:@"<span class=\"greyText\">share with contacts</span>"];		
	TTTableStyledTextItem* styledTextItem = [TTTableStyledTextItem itemWithText:styledText URL:@"gtio://getAnOpinion/share/contacts"];
	styledTextItem.margin = UIEdgeInsetsMake(12, 68, 12, 50);
	
	NSString* caption = nil;
	if ([_opinionRequest.contactEmails count] == 1) {
		caption = [NSString stringWithFormat:@"share with %d contact", [_opinionRequest.contactEmails count]];
	} else if ([_opinionRequest.contactEmails count] > 1) { 
		caption = [NSString stringWithFormat:@"share with %d contacts", [_opinionRequest.contactEmails count]];
	} else {
		caption = @"share with contacts";
	}
	NSMutableArray* firstSection = [NSMutableArray arrayWithObjects:
									[GTIOTableImageControlItem itemWithCaption:caption image:nil control:_shareSwitch],
									[TTTableTextItem itemWithText:@"add contacts" URL:@"gtio://share/addContacts"],
									nil];	
	NSMutableArray* secondSection = [NSMutableArray arrayWithCapacity:4];
	
	if (user.isRegisteredWithFacebook) {
		[firstSection insertObject:[GTIOTableImageControlItem itemWithCaption:nil image:TTSTYLEVAR(facebookTableCellImage) control:_facebookSwitch] atIndex:0];
	}
	
	if (user.isRegisteredWithTwitter) {
		[firstSection insertObject:[GTIOTableImageControlItem itemWithCaption:nil image:TTSTYLEVAR(twitterTableCellImage) control:_twitterSwitch] atIndex:0];
	}
	
	// removed for the time being
	if (NO) {
		[firstSection insertObject:[GTIOTableImageControlItem itemWithCaption:@"alert me with feedback" image:nil control:_alertMeWithFeedbackSwitch] atIndex:0];
	}
	
	[secondSection addObject:[GTIOTableImageControlItem itemWithCaption:@"keep this look private" image:nil control:_keepThisLookPrivateSwitch]];
	
	// Data Source
	self.dataSource = [GTIOSectionedDataSource dataSourceWithArrays:
					   @"",
					   firstSection,
					   @"",
					   secondSection,
					   nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (_shareSwitch.isOn && [_opinionRequest.contactEmails count] == 0) {
		[_shareSwitch setOn:NO animated:animated];
	}
	[self invalidateModel];
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark Actions

- (void)togglePrivateLabelText:(id)sender {
	if (_keepThisLookPrivateSwitch.isOn) {
		_privateLabel.text = @"don't share with GO TRY IT ON visitors.\nI'll send my link to friends to get reviewed.";
	} else {
		_privateLabel.text = @"";
	}
}

- (void)createMyOutfitButtonWasTouched:(id)sender {
	TTOpenURL(@"gtio://analytics/trackUserDidTouchCreateMyOutfitPage");
	
	// Write the settings back to the opinion request
	self.opinionRequest.shareWithContacts = _shareSwitch.isOn;
	self.opinionRequest.shareOnFacebook = _facebookSwitch.isOn;
	self.opinionRequest.shareOnTwitter = _twitterSwitch.isOn;
	self.opinionRequest.alertMeWithFeedback = _alertMeWithFeedbackSwitch.isOn;
	self.opinionRequest.isPrivate = _keepThisLookPrivateSwitch.isOn;
		
	// Ask the session to submit the request
	[[TTNavigator globalNavigator] openURLAction:
	 [TTURLAction actionWithURLPath:@"gtio://getAnOpinion/submit"]];
}

- (void)addContactWasTouched {
	TTOpenURL(@"gtio://getAnOpinion/share/contacts");
	[self performSelector:@selector(toggleSwitchOn) withObject:nil afterDelay:0.5];
}

- (void)toggleSwitchOn {
	_shareSwitch.on = YES;
}

- (void)shareSwitchToggled:(id)sender {
	if (_shareSwitch.isOn && [_opinionRequest.contactEmails count] == 0) {
		TTOpenURL(@"gtio://getAnOpinion/share/contacts");
	}
}

@end
