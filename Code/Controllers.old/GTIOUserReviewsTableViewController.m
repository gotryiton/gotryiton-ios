//
//  GTIOUserReviewsTableViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOUserReviewsTableViewController.h"
#import "GTIOOutfit.h"
#import "GTIOHeaderView.h"
#import <RestKit/Three20/Three20.h>
#import "GTIOProfile.h"
#import "GTIOReview.h"
#import "GTIOTableItemCellWithQuote.h"
#import "GTIOPaginationTableViewDelegate.h"
#import "GTIOPaginatedTTModel.h"
#import "GTIOUserReviewTableItem.h"
#import "GTIOUserReviewTableItemCell.h"


@interface GTIOUserReviewsTableViewDataSource : TTListDataSource {
	
}
@end

@implementation GTIOUserReviewsTableViewDataSource


- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOUserReviewTableItem class]]) {
		return [GTIOUserReviewTableItemCell class];	
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
	
}

- (NSString*)titleForEmpty {
	return @"no reviews found!";
}

@end

@implementation GTIOUserReviewsTableViewController

- (id)initWithUserID:(NSString*)userID {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		NSLog(@"Showing reviews for user ID: %@", userID);
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
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	self.navigationItem.titleView = [GTIOHeaderView viewWithText:(_isShowingCurrentUser ? @"MY REVIEWS" : @"REVIEWS")];
	self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:nil action:nil] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isShowingCurrentUser) {
        GTIOAnalyticsEvent(kMyReviewsEventName);
    }
}

- (void)createModel {
	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
							@"true", @"requestReviews",
							nil];
    
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath([NSString stringWithFormat:@"/profile/%@", _userID]) delegate:nil];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    GTIOPaginatedTTModel* model = [GTIOPaginatedTTModel modelWithObjectLoader:objectLoader];
    
	model.objectsKey = @"reviewsOutfits";
    TTListDataSource* ds = [TTListDataSource dataSourceWithObjects:nil];
    ds.model = model;
    self.dataSource = ds;
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	
	GTIOPaginatedTTModel* model = (GTIOPaginatedTTModel*)self.model;
	if (![self.dataSource isKindOfClass:[GTIOUserReviewsTableViewDataSource class]] || 
		[[model objects] count] <= [[(GTIOUserReviewsTableViewDataSource*)self.dataSource items] count]) {
		GTIOProfile* profile = model.profile;
		
		NSMutableArray* outfits = [NSMutableArray arrayWithCapacity:[profile.reviewsOutfits count]];
		if (profile) {
			if (!_isShowingCurrentUser) {
				self.navigationItem.titleView = [GTIOHeaderView viewWithText:[profile.displayName uppercaseString]];
			}
		}
		int i = 0;
		for (GTIOOutfit* outfit in profile.reviewsOutfits) {
			[outfits addObject:[GTIOUserReviewTableItem itemWithOutfit:outfit index:i]];
		}
		TTListDataSource* dataSource = [GTIOUserReviewsTableViewDataSource dataSourceWithItems:outfits];
		dataSource.model = self.model;
		self.dataSource = dataSource;
	} else {
		NSLog(@"Loaded More");
		NSMutableArray* outfits = [(GTIOUserReviewsTableViewDataSource*)self.dataSource items];
		[self.tableView beginUpdates];
		NSMutableArray* indexPaths = [NSMutableArray array];
		for (int i = [outfits count]; i < [model.objects count]; i++) {
			GTIOOutfit* outfit = [model.objects objectAtIndex:i];
			[outfits addObject:[GTIOUserReviewTableItem itemWithOutfit:outfit index:i]];
			NSIndexPath* ip = [NSIndexPath indexPathForRow:i inSection:0];
			[indexPaths addObject:ip];
		}
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
		[self.tableView endUpdates];
	}
}




@end
