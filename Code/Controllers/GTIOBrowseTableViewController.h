//
//  GTIOBrowseTableViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOBrowseTableViewController is the top level browse tableview controller that handles browsing categories, outfits, and searching

#import <Three20/Three20.h>
#import <RestKit/RestKit.h>
#import "GTIOBrowseList.h"
#import "GTIOTabBar.h"
#import "GTIOBrowseListPresenter.h"

@interface GTIOBrowseTableViewController : TTTableViewController <UISearchBarDelegate, GTIOTabBarDelegate> {
    NSString* _apiEndpoint; // default is /rest/v3/categories/ will be different for subcategories.
    UISearchBar* _searchBar;
    NSString* _queryText;
    GTIOTabBar* _sortTabBar;
    UIImageView* _topShadowImageView;
    NSArray* _sortTabs;
    GTIOBrowseListPresenter* _presenter;
}
/// Current api end point defaults to /rest/v3/categories/
@property (nonatomic, retain) NSString* apiEndpoint;
/// Current search query text
@property (nonatomic, retain) NSString* queryText;

@end

/// GTIOBrowseListDataSource is a [TTListDataSource](TTListDataSource) used by [GTIOBrowseTableViewController](GTIOBrowseTableViewController)
@interface GTIOBrowseListDataSource : TTListDataSource
@end
/// GTIOBrowseSectionedDataSource is a [TTSectionedDataSource](TTSectionedDataSource) used by [GTIOBrowseTableViewController](GTIOBrowseTableViewController)
@interface GTIOBrowseSectionedDataSource: TTSectionedDataSource
@end