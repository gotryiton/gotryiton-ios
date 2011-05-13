//
//  GTIOBrowseTableViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>
#import <RestKit/RestKit.h>
#import "GTIOBrowseList.h"

@interface GTIOBrowseTableViewController : TTTableViewController <RKObjectLoaderDelegate, UISearchBarDelegate> {
    NSString* _apiEndpoint; // default is /rest/v3/categories/ will be different for subcategories.
    UISearchBar* _searchBar;
    NSString* _queryText;
}

@property (nonatomic, retain) NSString* apiEndpoint;
@property (nonatomic, retain) NSString* queryText;

@end
