//
//  GTIOTableViewController.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/3/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOTableViewController.h"

@implementation GTIOTableViewController

- (void)loadView {
	[super loadView];
	
	// Show the Navigation Bar
	[self.navigationController setNavigationBarHidden:NO];
	
	// Background Image
	[self setConcreteBackgroundImage];
	
	// Show the concrete background through the table view
	self.tableView.backgroundColor = [UIColor clearColor];
}

@end
