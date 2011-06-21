//
//  GTIOBrowseListPresenter.h
//  GTIO
//
//  Created by Jeremy Ellison on 6/3/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOBrowseList.h"

@interface GTIOBrowseListPresenter : NSObject {
    GTIOBrowseList* _list;
}

+ (id)presenterWithList:(GTIOBrowseList*)list;

@property (nonatomic, readonly) GTIOBrowseList* list;

@property (nonatomic, readonly) NSString* subtitle;

// A Collection of TTTableItems representing this list.
// May be an array of arrays if they are in sections.
@property (nonatomic, readonly) NSMutableArray* tableItems;
- (NSMutableArray*)tableItemsWithSearchText:(NSString*)searchText;
@property (nonatomic, readonly) NSMutableArray* sectionNames;

// A Search bar for use as the tableHeaderView of a table
// or nil if search is not enabled on thsi list.
@property (nonatomic, readonly) UISearchBar* searchBar;

@property (nonatomic, readonly) UIView* bannerAd;

// Methods for grouped category lists.
@property (nonatomic, readonly) NSArray* alphabeticalListKeys;
@property (nonatomic, readonly) NSDictionary* tableItemsGroupedAlphabetically;
- (NSDictionary*)tableItemsGroupedAlphabeticallyWithFilterText:(NSString*)text;

- (NSMutableArray*)tableItemsForOutfits:(NSArray*)outfits;
- (NSMutableArray*)tableItemsForReviews:(NSArray*)reviews;

// TODO: test these.
@property (nonatomic, readonly) NSArray* tabs;
@property (nonatomic, readonly) NSArray* tabNames;

@property (nonatomic, readonly) NSString* titleForEmptyList;

@end
