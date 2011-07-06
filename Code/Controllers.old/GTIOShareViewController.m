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
#import <RestKit/Three20/Three20.h>

@interface GTIOShareTableViewVarHeightDelegate : TTTableViewVarHeightDelegate
@end

@implementation GTIOShareTableViewVarHeightDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (![tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return 0.0f;
    }
    NSString* title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    if (title && ![title isWhitespaceAndNewlines]) {
        return 45.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return nil;
    }
    NSString* title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    UIView* header = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,40)] autorelease];
    header.backgroundColor = [UIColor clearColor];
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(20,10,300,30)] autorelease];
    [header addSubview:label];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBCOLOR(128,128,128);
    label.font = [UIFont systemFontOfSize:18];
    return header;
}


@end

@implementation GTIOShareViewController

@synthesize opinionRequest = _opinionRequest;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if (self = [super initWithNavigatorURL:URL query:query]) {
		self.opinionRequest = [query objectForKey:@"opinionRequest"];
		
		// Navigation Item
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(shareTitleImage)] autorelease];		
		self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" 
																				  
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
		
		[[TTNavigator navigator].URLMap from:@"gtio://share/addContacts" toObject:self selector:@selector(addContactWasTouched)];
	}
	
	return self;
}

- (void)dealloc {
	[[TTNavigator navigator].URLMap removeURL:@"gtio://share/addContacts"];
	TT_RELEASE_SAFELY(_opinionRequest);
	TT_RELEASE_SAFELY(_shareWithCommunitySwitch);
	[super dealloc];
}

- (void)loadView {
	[super loadView];
    self.variableHeightRows = YES;
    
    UIImage* topShadow = [UIImage imageNamed:@"list-top-shadow.png"];
    UIView* topShadowImageView = [[[UIImageView alloc] initWithImage:topShadow] autorelease];
    [self.view addSubview:topShadowImageView];
    
	TTOpenURL(@"gtio://analytics/trackUserDidViewContacts");
}

- (void)didReceiveMemoryWarning {
    ;
}

- (id<UITableViewDelegate>)createDelegate {
    return [[[GTIOShareTableViewVarHeightDelegate alloc] initWithController:self] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self invalidateModel];
}

- (void)createModel {
    
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/stylists/quick-look") delegate:nil];
    objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    objectLoader.method = RKRequestMethodPOST;
    RKObjectLoaderTTModel* model = [RKObjectLoaderTTModel modelWithObjectLoader:objectLoader];
    
    GTIOSectionedDataSource* ds = (GTIOSectionedDataSource*)[GTIOSectionedDataSource dataSourceWithObjects:nil];
    ds.model = model;
    self.dataSource = ds;
    
}

- (void)didLoadModel:(BOOL)firstTime {
    GTIOStylistsQuickLook* stylistsQuickLook = nil;
    for (id obj in [(RKObjectLoaderTTModel*)self.model objects]) {
        if ([obj isKindOfClass:[GTIOStylistsQuickLook class]]) {
            stylistsQuickLook = obj;
        }
    }
    
	NSMutableArray* secondSection = [NSMutableArray arrayWithObjects:
									[GTIOTableImageControlItem itemWithCaption:@"GO TRY IT ON community" image:nil control:_shareWithCommunitySwitch],
									nil];	
	NSMutableArray* firstSection = [NSMutableArray array];
    
    NSString* sectionText;
    if (stylistsQuickLook) {
        GTIOPersonalStylistsItem* personalStylistsItem = [[[GTIOPersonalStylistsItem alloc] init] autorelease];
        personalStylistsItem.stylistsQuickLook = stylistsQuickLook;
        [firstSection addObject:personalStylistsItem];
        [firstSection addObject:[TTTableTextItem itemWithText:@"edit my stylists" URL:@"gtio://stylists/edit"]];
        sectionText = @"share with:";
    } else {
        [firstSection addObject:[TTTableTextItem itemWithText:@"add your personal stylists!" URL:@"gtio://stylists/add"]];
        sectionText = @"share:";
    }
	
	// Data Source
    
	self.dataSource = [GTIOSectionedDataSource dataSourceWithArrays:
					   sectionText,
					   firstSection,
					   @"",
					   secondSection,
					   nil];
}

- (void)createMyOutfitButtonWasTouched:(id)sender {
    GTIOAnalyticsEvent(kUserDidTouchCreateMyOutfitPageEventName);
	
	// Write the settings back to the opinion request
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
