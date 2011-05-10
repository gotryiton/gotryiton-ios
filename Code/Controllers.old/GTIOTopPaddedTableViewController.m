//
//  GTIOTopPaddedTableViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOTopPaddedTableViewController.h"

@implementation GTIOTopPaddedTableViewController

- (void)loadView {
	[super loadView];
	[self.tableView setContentInset:UIEdgeInsetsMake(8-3, 0, 0, 0)];
}

@end
