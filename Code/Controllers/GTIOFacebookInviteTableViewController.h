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

@interface GTIOFacebookInviteTableViewController : GTIOTableViewController <UISearchBarDelegate> {
    UISearchBar* _searchBar;
}

@property (nonatomic, copy) NSString* facebookTitle;
@property (nonatomic, copy) NSString* facebookInviteURL;

- (id)initWithInviteTitle:(NSString*)title inviteURL:(NSString*)inviteURL;

- (void)loadedList:(GTIOBrowseList*)list;
- (UISearchBar*)searchBarForList:(GTIOBrowseList*)list;
- (NSMutableArray*)tableItemsFromList:(GTIOBrowseList*)list withSearchText:(NSString*)searchText;

@end
