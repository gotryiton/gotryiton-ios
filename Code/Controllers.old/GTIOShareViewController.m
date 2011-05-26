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
		
		_shareWithCommunitySwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
		_shareWithStylistsSwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
		
		[[TTNavigator navigator].URLMap from:@"gtio://share/addContacts" toObject:self selector:@selector(addContactWasTouched)];
	}
	
	return self;
}

- (void)dealloc {
	[[TTNavigator navigator].URLMap removeURL:@"gtio://share/addContacts"];
	TT_RELEASE_SAFELY(_opinionRequest);
	TT_RELEASE_SAFELY(_shareWithCommunitySwitch);
	TT_RELEASE_SAFELY(_shareWithStylistsSwitch);
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
	NSMutableArray* firstSection = [NSMutableArray arrayWithObjects:
									[GTIOTableImageControlItem itemWithCaption:@"share with community" image:nil control:_shareWithCommunitySwitch],
									nil];	
	NSMutableArray* secondSection = [NSMutableArray array];
    
	
    TTStyledText* styledText = [TTStyledText textFromXHTML:@"add personal stylists"];
    
	[secondSection addObject:[GTIOTableImageControlItem itemWithCaption:@"send to my stylists" image:nil control:_shareWithStylistsSwitch]];
    [secondSection addObject:[TTTableStyledTextItem itemWithText:styledText URL:@"gtio://stylists/add"]];
	
	// Data Source
	self.dataSource = [GTIOSectionedDataSource dataSourceWithArrays:
					   @"",
					   firstSection,
					   @"",
					   secondSection,
					   nil];
}

- (void)createMyOutfitButtonWasTouched:(id)sender {
	TTOpenURL(@"gtio://analytics/trackUserDidTouchCreateMyOutfitPage");
	
	// Write the settings back to the opinion request
	self.opinionRequest.shareWithStylists = _shareWithStylistsSwitch.isOn;
	self.opinionRequest.isPublic = _shareWithCommunitySwitch.isOn;
		
	// Ask the session to submit the request
	[[TTNavigator globalNavigator] openURLAction:
	 [TTURLAction actionWithURLPath:@"gtio://getAnOpinion/submit"]];
}

- (void)addContactWasTouched {
	TTOpenURL(@"gtio://getAnOpinion/share/contacts");
	[self performSelector:@selector(toggleSwitchOn) withObject:nil afterDelay:0.5];
}

@end
