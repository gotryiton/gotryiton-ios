//
//  GTIOGiveAnOpinionTableViewController.m
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/21/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOGiveAnOpinionTableViewController.h"
#import "GTIOGiveAnOpinionTableViewDataSource.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOOutfitTableViewCell.h"
#import <RestKit/Three20/Three20.h>
#import "GTIOPaginationTableViewDelegate.h"
#import "GTIOPaginatedTTModel.h"
#import "GTIOAnalyticsTracker.h"

@interface GTIOGiveAnOpinionTableViewController (Private)

- (void)setHighlightedButton;

@end


@implementation GTIOGiveAnOpinionTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"give an opinion" 
														 image:TTSTYLEVAR(giveAnOpinionTabBarImage) 
														   tag:0] autorelease];
		_state = GTIOOpinionStateRecent;
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(loginStateChanged:) 
													 name:kGTIOUserDidLoginNotificationName
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(loginStateChanged:) 
													 name:kGTIOUserDidLogoutNotificationName
												   object:nil];
        
	}
	
	return self;
}

- (void)loginStateChanged:(NSNotification*)note {
    _loginStateChange = YES;
}

// This was here for some unknown but apparently intentional reason, removed it to fix error where the give an opinion
// displays a blank view after a memory warning occurs away from the screen and then you navigate back to it -DRH 5.17.2011
//
//- (void)didReceiveMemoryWarning {
//    ;
//}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	TT_RELEASE_SAFELY(_recentButton);
	TT_RELEASE_SAFELY(_popularButton);
	TT_RELEASE_SAFELY(_searchButton);
	TT_RELEASE_SAFELY(_searchBarView);
	TT_RELEASE_SAFELY(_searchBarTextField);
	TT_RELEASE_SAFELY(_headerSeparator);
	[super viewDidUnload];
}

- (void)loadView {
	[super loadView];
	
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(getAnOpinionOverlayTitleImage)] autorelease];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:nil action:nil] autorelease];
	
	_searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
	_searchBarView.clipsToBounds = YES;
	// TODO: get BG image.
	_searchBarView.backgroundColor = RGBCOLOR(212,212,212);
	UIImageView* bg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-background.png"]] autorelease];
	[_searchBarView addSubview:bg];
	
	[self.view addSubview:_searchBarView];
	self.tableView.frame = CGRectMake(0, 37, 320, self.view.bounds.size.height - 37);
	
	// TODO: images for these buttons
	int cellWidth = 103;
	_recentButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_recentButton.frame = CGRectMake(6-1, 7-3, cellWidth+1, 24+4);
	[_recentButton setImage:[UIImage imageNamed:@"tabs-recent-off.png"] forState:UIControlStateNormal];
	[_recentButton setImage:[UIImage imageNamed:@"tabs-recent-on.png"] forState:UIControlStateSelected];
	[_recentButton setImage:[UIImage imageNamed:@"tabs-recent-on.png"] forState:UIControlStateHighlighted];
	[_searchBarView addSubview:_recentButton];
	[_recentButton addTarget:self action:@selector(recentButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	_popularButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_popularButton.frame = CGRectMake(6+cellWidth, 7-3, cellWidth, 24+4);
	[_popularButton setImage:[UIImage imageNamed:@"tabs-popular-off.png"] forState:UIControlStateNormal];
	[_popularButton setImage:[UIImage imageNamed:@"tabs-popular-on.png"] forState:UIControlStateSelected];
	[_popularButton setImage:[UIImage imageNamed:@"tabs-popular-on.png"] forState:UIControlStateHighlighted];
	[_searchBarView addSubview:_popularButton];
	[_popularButton addTarget:self action:@selector(popularButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	_searchButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_searchButton.frame = CGRectMake(6+cellWidth+cellWidth, 7-3, cellWidth, 24+4);
	[_searchButton setImage:[UIImage imageNamed:@"tabs-search-off.png"] forState:UIControlStateNormal];
	[_searchButton setImage:[UIImage imageNamed:@"tabs-search-pink.png"] forState:UIControlStateSelected];
	[_searchButton setImage:[UIImage imageNamed:@"tabs-search-black.png"] forState:UIControlStateHighlighted];
	[_searchBarView addSubview:_searchButton];
	[_searchButton addTarget:self action:@selector(searchButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[self setHighlightedButton];
	
	TTView* backgroundView = [[[TTView alloc] initWithFrame:CGRectMake(3, 7+31, 320 - 6 + 1, 35)] autorelease];
	backgroundView.backgroundColor = _searchBarView.backgroundColor;
	backgroundView.style = 
							[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:14] next:
							 [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 0, 0) next:
							 [TTShadowStyle styleWithColor:[UIColor lightGrayColor] blur:1 offset:CGSizeMake(1, 1) next:
							  [TTShadowStyle styleWithColor:[UIColor lightGrayColor] blur:1 offset:CGSizeMake(-1, 0) next:
							[TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:nil]]]]];
	[_searchBarView addSubview:backgroundView];
	int vInset = 1;
	int hOffset = 4;
	int hInset = 4;
	_searchBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(4+hOffset+hInset,
																		5+37+vInset-1,
																		320 - 8 - hOffset - (2*hInset) + 3,
																		24-(2*vInset))];
	UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon.png"]] autorelease];
	[imageView setContentMode:UIViewContentModeScaleAspectFit];
	imageView.frame = CGRectMake(0, 0, 24, 14);
	_searchBarTextField.textColor = RGBCOLOR(84,84,84);
	_searchBarTextField.leftView = imageView;
	[_searchBarTextField setLeftViewMode:UITextFieldViewModeAlways];
	_searchBarTextField.placeholder = @"enter keywords here";
	[_searchBarTextField setClearButtonMode:UITextFieldViewModeAlways];
	[_searchBarView addSubview:_searchBarTextField];
	_searchBarTextField.returnKeyType = UIReturnKeySearch;
	_searchBarTextField.delegate = self;
	
	_headerSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 36, 320, 1)];
	_headerSeparator.backgroundColor = RGBCOLOR(187,187,187);
	[_searchBarView addSubview:_headerSeparator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (_loginStateChange) {
        [self invalidateModel];
        _loginStateChange = NO;
    }
}

- (void)showSearchBar:(BOOL)show {
	[UIView beginAnimations:@"show/hide search bar" context:nil];
	if (show) {
		_isSearchVisible = YES;
		[_searchButton setImage:[UIImage imageNamed:@"tabs-search-black.png"] forState:UIControlStateNormal];
		_searchBarView.frame = CGRectMake(0, 0, 320, 37*2);
		_loadingView.frame = CGRectMake(0, 37*2, 320, self.view.bounds.size.height - 37*2);
		self.tableView.frame = CGRectMake(0, 37*2, 320, self.view.bounds.size.height - 37*2);
		[_searchBarTextField becomeFirstResponder];
		_headerSeparator.frame = CGRectMake(0, 36+37, 320, 1);
	} else {
		_isSearchVisible = NO;
		[_searchButton setImage:[UIImage imageNamed:@"tabs-search-off.png"] forState:UIControlStateNormal];
		_searchBarView.frame = CGRectMake(0, 0, 320, 37);
		_loadingView.frame = CGRectMake(0, 37, 320, self.view.bounds.size.height - 37);
		self.tableView.frame = CGRectMake(0, 37, 320, self.view.bounds.size.height - 37);
		[_searchBarTextField resignFirstResponder];
		_headerSeparator.frame = CGRectMake(0, 36, 320, 1);
	}
	[UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	_state = GTIOOpinionStateSearch;
	[self setHighlightedButton];
	[self invalidateModel];
	[textField resignFirstResponder];
	return NO;
}

- (void)recentButtonWasPressed:(id)sender {
	if (_state == GTIOOpinionStateRecent) {
		if (_isSearchVisible) {
			[self showSearchBar:NO];
		}
		return;
	}
	_state = GTIOOpinionStateRecent;
	[self setHighlightedButton];
	[self invalidateModel];
}

- (void)popularButtonWasPressed:(id)sender {
	if (_state == GTIOOpinionStatePopular) {
		if (_isSearchVisible) {
			[self showSearchBar:NO];
		}
		return;
	}
	_state = GTIOOpinionStatePopular;
	[self setHighlightedButton];
	[self invalidateModel];
}

- (void)searchButtonWasPressed:(id)sender {
	if (_isSearchVisible || _modelError) {
		[self showSearchBar:NO];
	} else {
		[self showSearchBar:YES];
	}
	// Slide in text field.
}

- (void)setHighlightedButton {
	[self showSearchBar:_state == GTIOOpinionStateSearch];
	_recentButton.selected = NO;
	_popularButton.selected = NO;
	_searchButton.selected = NO;
	switch (_state) {
		case GTIOOpinionStateRecent:
			_recentButton.selected = YES;
			break;
		case GTIOOpinionStatePopular:
			_popularButton.selected = YES;
			break;
		case GTIOOpinionStateSearch:
			_searchButton.selected = YES;
			break;
	}
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[GTIOPaginationTableViewDelegate alloc] initWithController:self] autorelease];
}

- (void)createModel {
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
	
	NSString* url = nil;
	switch (_state) {
		case GTIOOpinionStateRecent:
			url = GTIORestResourcePath(@"/lists/recent/");
            TTOpenURL(@"gtio://analytics/trackRecentListPageView");
			break;
		case GTIOOpinionStatePopular:
			url = GTIORestResourcePath(@"/lists/popular/");
            TTOpenURL(@"gtio://analytics/trackPopularListPageView");
			break;
		case GTIOOpinionStateSearch:
			[params setObject:_searchBarTextField.text forKey:@"q"];
			url = GTIORestResourcePath(@"/lists/search/");
            [[GTIOAnalyticsTracker sharedTracker] trackSearchListPageViewWithQuery:_searchBarTextField.text];
			break;
	}
	
    
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:url delegate:nil];
    objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    objectLoader.method = RKRequestMethodPOST;
    GTIOPaginatedTTModel* model = [GTIOPaginatedTTModel modelWithObjectLoader:objectLoader];
    
	NSString* outfitKey = nil;
	switch (_state) {
		case GTIOOpinionStateRecent:
			outfitKey = @"recent";
			break;
		case GTIOOpinionStatePopular:
			outfitKey = @"popular";
			break;
		case GTIOOpinionStateSearch:
			outfitKey = @"search";
			break;
	}
	model.objectsKey = outfitKey;
	TTListDataSource* ds = [TTListDataSource dataSourceWithObjects:nil];
    ds.model = model;
    self.dataSource = ds;
//	self.model = model;
	
	if (self.tableView.delegate) {
		// Fixes drag to refresh issues when invalidating model.
		[self.model.delegates addObject:self.tableView.delegate];
	}
}

- (void)invalidateModel {
	[(GTIOPaginationTableViewDelegate*)self.tableView.delegate hideLoadMore];
	[super invalidateModel]; 
}

- (void)didLoadModel:(BOOL)firstTime {
	// TODO: figure out why the delegate isn't getting this...
	[(GTIOPaginationTableViewDelegate*)self.tableView.delegate hideLoadMore];
	
	GTIOPaginatedTTModel* model = (GTIOPaginatedTTModel*)self.model;
	if (![self.dataSource isKindOfClass:[GTIOGiveAnOpinionTableViewDataSource class]] || 
		[[model objects] count] <= [[(GTIOGiveAnOpinionTableViewDataSource*)self.dataSource items] count]) {
		NSArray* outfits = [model objects];
		
		NSMutableArray* items = [NSMutableArray arrayWithCapacity:[outfits count]];
		int i = 0;
		for (GTIOOutfit* outfit in outfits) {
			[items addObject:[GTIOOutfitTableViewItem itemWithOutfit:outfit index:i]];
			i++;
		}
		TTListDataSource* dataSource = [GTIOGiveAnOpinionTableViewDataSource dataSourceWithItems:items];
		dataSource.model = self.model;
		self.dataSource = dataSource;
	} else {
		NSLog(@"Loaded More!");
		GTIOGiveAnOpinionTableViewDataSource* ds = (GTIOGiveAnOpinionTableViewDataSource*)self.dataSource;
		NSMutableArray* items = [ds items];
		[self.tableView beginUpdates];
		NSMutableArray* indexPaths = [NSMutableArray array];
		for (int i = [items count]; i < [model.objects count]; i++) {
			GTIOOutfit* outfit = [model.objects objectAtIndex:i];
			GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit index:i];
			NSIndexPath* ip = [NSIndexPath indexPathForRow:i inSection:0];
			[indexPaths addObject:ip];
			[items addObject:item];	
		}
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
		[self.tableView endUpdates];
	}
}

@end
