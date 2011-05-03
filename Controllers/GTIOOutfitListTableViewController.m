//
//  GTIOOutfitListTableViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOOutfitListTableViewController.h"
#import "GTIOOutfitViewController.h"

@implementation GTIOOutfitListTableViewController

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-list.png"] style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
	NSLog(@"URL: %@", [object URL]);
	GTIOOutfitViewController* viewController = [[GTIOOutfitViewController alloc] initWithModel:(GTIOPaginatedTTModel*)self.model outfitIndex:indexPath.row];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (BOOL)shouldOpenURL:(NSString*)URL {
	return NO;
}

@end
