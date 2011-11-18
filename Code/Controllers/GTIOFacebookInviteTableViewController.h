//
//  GTIOFacebookInviteTableViewController.h
//  GTIO
//
//  Created by Duncan Lewis on 11/18/11.
//  Copyright (c) 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOTableViewController.h"
#import "GTIOHeaderView.h"
#import "GTIOProfile.h"
#import "GTIOBrowseListTTModel.h"

@interface GTIOFacebookInviteTableViewController : GTIOTableViewController {
    UISearchBar* _searchBar;
}

- (void)searchBar;

@end
