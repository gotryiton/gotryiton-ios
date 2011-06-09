//
//  GTIOTodosTableViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/23/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOTodosTableViewController.h"
#import "GTIOBrowseListTTModel.h"
#import "GTIOSortTab.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOOutfitViewController.h"
#import "GTIOHeaderView.h"

@implementation GTIOTodosTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.apiEndpoint = GTIORestResourcePath(@"/todos");
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"TO-DOs"];
    
    if ([GTIOUser currentUser].loggedIn && [[GTIOUser currentUser].istyleCount intValue] > 0) {
        GTIOBarButtonItem* whoIStyleItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"who i style" target:self action:@selector(whoIStyleButtonPressed:)] autorelease];
        self.navigationItem.rightBarButtonItem = whoIStyleItem;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)whoIStyleButtonPressed:(id)sender {
    TTOpenURL(@"gtio://whoIStyle");
}

- (void)createModel {
    _queryText = nil;
    [super createModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[self invalidateModel];
}

@end
