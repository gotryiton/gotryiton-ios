//
//  GTIOBrowseList.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOBrowseList is a list of either categories, reviews, sections, or myLooks
#import <Foundation/Foundation.h>

@interface GTIOBrowseList : NSObject {
    NSString* _title;
    NSString* _subtitle;
    NSNumber* _includeSearch;
    NSString* _searchText;
    NSNumber* _includeAlphaNav;
    NSArray* _categories; // A browse list will either contain categories
    NSArray* _outfits;    // or it will contain outfits. or reviews. or sections. or myLooks.
    NSString* _searchAPI;
    NSArray* _sortTabs;
    NSArray* _tabs;
    NSArray* _stylists;
    NSArray* _sections;
    NSArray* _reviews;
    NSArray* _myLooks;
}
/// title of list
@property (nonatomic, retain) NSString* title;
/// subtitle of list
@property (nonatomic, retain) NSString* subtitle;
/// true if the list should include a search field
@property (nonatomic, retain) NSNumber* includeSearch;
/// placeholder text for the search field
@property (nonatomic, retain) NSString* searchText;
/// true if the list should have the alphabetic navigation on the right side
@property (nonatomic, retain) NSNumber* includeAlphaNav;
/// collection of categories
@property (nonatomic, retain) NSArray* categories;
/// collection of outfits
@property (nonatomic, retain) NSArray* outfits;
/// api end point for search
@property (nonatomic, retain) NSString* searchAPI;
/// collection of sort tabs for list
@property (nonatomic, retain) NSArray* sortTabs;
/// tabs of the list
@property (nonatomic, retain) NSArray* tabs;
/// collection of stylists
@property (nonatomic, retain) NSArray* stylists;
/// sections in list
@property (nonatomic, retain) NSArray* sections;
/// collection of reviews
@property (nonatomic, retain) NSArray* reviews;
/// collection of myLooks
@property (nonatomic, retain) NSArray* myLooks;

// A Collection of TTTableItems representing this list.
// May be an array of arrays if they are in sections.
@property (nonatomic, readonly) NSArray* tableItems;
- (NSArray*)tableItemsWithSearchText:(NSString*)searchText;

// A Search bar for use as the tableHeaderView of a table
// or nil if search is not enabled on thsi list.
@property (nonatomic, readonly) UISearchBar* searchBar;

// Methods for grouped category lists.
@property (nonatomic, readonly) NSArray* alphabeticalListKeys;
@property (nonatomic, readonly) NSDictionary* tableItemsGroupedAlphabetically;
- (NSDictionary*)tableItemsGroupedAlphabeticallyWithFilterText:(NSString*)text;

@end
