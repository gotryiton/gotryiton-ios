//
//  GTIOTodosTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/23/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOTodosTableViewController.h"


@implementation GTIOTodosTableViewController

- (void)loadView {
    [super loadView];
    self.title = @"To-Do's";
    UIBarButtonItem* whoIStyleItem = [[[UIBarButtonItem alloc] initWithTitle:@"who i style" style:UIBarButtonItemStyleBordered target:self action:@selector(whoIStyleButtonPressed:)] autorelease];
    self.navigationItem.rightBarButtonItem = whoIStyleItem;
}

- (void)whoIStyleButtonPressed:(id)sender {
    TTOpenURL(@"gtio://whoIStyle");
}

@end
