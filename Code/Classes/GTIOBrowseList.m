//
//  GTIOBrowseList.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOBrowseList.h"
#import "GTIOCategory.h"

@implementation GTIOBrowseList

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize includeSearch = _includeSearch;
@synthesize searchText = _searchText;
@synthesize includeAlphaNav = _includeAlphaNav;
@synthesize categories = _categories;
@synthesize outfits = _outfits;
@synthesize searchAPI = _searchAPI;
@synthesize sortTabs = _sortTabs;
@synthesize tabs = _tabs;
@synthesize stylists = _stylists;
@synthesize sections = _sections;
@synthesize reviews = _reviews;
@synthesize myLooks = _myLooks;

- (void)dealloc {
    [_title release];
    [_subtitle release];
    [_includeSearch release];
    [_searchText release];
    [_includeAlphaNav release];
    [_categories release];
    [_outfits release];
    [_searchAPI release];
    [_sortTabs release];
    [_tabs release];
    [_stylists release];
    [_sections release];
    [_reviews release];
    [_myLooks release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<GTIOBrowseList title: %@ subtitle: %@ includeSearch: %@ searchAPI: %@ searchText: %@ includeAlphaNav: %@"
            @"categories: %@ num outfits: %d", _title, _subtitle, _includeSearch, _searchAPI, _searchText, _includeAlphaNav,
            [[_categories valueForKey:@"name"] componentsJoinedByString:@","], [_outfits count]];
}

- (NSMutableArray*)categoriesFilteredWithText:(NSString*)text {
    if (text && [text length] > 0) {
        NSMutableArray* matchingCategories = [NSMutableArray array];
        for (GTIOCategory* category in self.categories) {
            if ([[category.name uppercaseString] rangeOfString:[text uppercaseString]].length > 0) {
                NSLog(@"Matched against category name: %@", category.name);
                [matchingCategories addObject:category];
            }
        }
        return matchingCategories;
    }
    return [[self.categories mutableCopy] autorelease];
}

@end
