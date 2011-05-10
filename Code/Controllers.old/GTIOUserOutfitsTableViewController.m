//
//  GTIOUserOutfitsTableViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOUserOutfitsTableViewController.h"
#import "GTIOUser.h"
#import "GTIOHeaderView.h"
#import <RestKit/Three20/Three20.h>
#import "GTIOProfile.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOGiveAnOpinionTableViewDataSource.h"
#import "GTIOOutfitVerdictTableItem.h"
#import "GTIOOutfitVerdictTableItemCell.h"
#import "GTIOPaginationTableViewDelegate.h"
#import "GTIOPaginatedTTModel.h"

@interface GTIOUserOutfitsTableViewDataSource : TTListDataSource {
	
}
@end

@implementation GTIOUserOutfitsTableViewDataSource


- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOOutfitVerdictTableItem class]]) {
		return [GTIOOutfitVerdictTableItemCell class];	
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
	
}

- (NSString*)titleForEmpty {
	return @"no looks found!";
}

@end



@implementation GTIOUserOutfitsTableViewController

- (id)initWithUserID:(NSString*)userID {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		NSLog(@"Showing outfits for user ID: %@", userID);
		_isShowingCurrentUser = [[GTIOUser currentUser].UID isEqualToString:userID];
		_userID = [userID copy];
		self.variableHeightRows = YES;
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}

- (void)dealloc {
	[_userID release];
	[super dealloc];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[GTIOPaginationTableViewDelegate alloc] initWithController:self] autorelease];
}

- (void)loadView {
	[super loadView];
	[self.tableView setSeparatorStyle:UITableViewCellSelectionStyleNone];
	self.navigationItem.titleView = [GTIOHeaderView viewWithText:(_isShowingCurrentUser ? @"MY LOOKS" : @"LOOKS")];
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:nil action:nil] autorelease];
}

- (void)createModel {
	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
							_userID, @"uid",
							@"true", @"requestOutfits",
							nil];
	params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
	GTIOPaginatedTTModel* model = [[GTIOPaginatedTTModel alloc] initWithResourcePath:GTIORestResourcePath(@"/profile/") params:params method:RKRequestMethodPOST];						
	model.objectsKey = @"outfits";
    TTListDataSource* ds = [TTListDataSource dataSourceWithObjects:nil];
    ds.model = model;
    self.dataSource = ds;
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	GTIOPaginatedTTModel* model = (GTIOPaginatedTTModel*)self.model;
	if (![self.dataSource isKindOfClass:[GTIOUserOutfitsTableViewDataSource class]] || 
		[[model objects] count] <= [[(GTIOUserOutfitsTableViewDataSource*)self.dataSource items] count]) {
		NSMutableArray* items = [NSMutableArray arrayWithCapacity:[[model objects] count]];
		
		if (model.profile) {
			if (!_isShowingCurrentUser) {
				self.navigationItem.titleView = [GTIOHeaderView viewWithText:[model.profile.displayName uppercaseString]];
			}
		}
		
		int i = 0;
		for (GTIOOutfit* outfit in [model objects]) {
			[items addObject:[GTIOOutfitVerdictTableItem itemWithOutfit:outfit index:i]];
			i++;
		}
		
		TTListDataSource* dataSource = [GTIOUserOutfitsTableViewDataSource dataSourceWithItems:items];
		dataSource.model = self.model;
		self.dataSource = dataSource;
	} else {
		NSLog(@"Loaded More");
		GTIOUserOutfitsTableViewDataSource* ds = (GTIOUserOutfitsTableViewDataSource*)self.dataSource;
		NSMutableArray* items = [ds items];
		[self.tableView beginUpdates];
		NSMutableArray* indexPaths = [NSMutableArray array];
		for (int i = [items count]; i < [model.objects count]; i++) {
			GTIOOutfit* outfit = [model.objects objectAtIndex:i];
			GTIOOutfitVerdictTableItem* item = [GTIOOutfitVerdictTableItem itemWithOutfit:outfit index:i];
			NSIndexPath* ip = [NSIndexPath indexPathForRow:i inSection:0];
			[indexPaths addObject:ip];
			[items addObject:item];	
		}
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
		[self.tableView endUpdates];
	}
}

@end
