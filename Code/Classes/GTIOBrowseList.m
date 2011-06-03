//
//  GTIOBrowseList.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOBrowseList.h"
#import "GTIOCategory.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOUserReviewTableItem.h"
#import "GTIOReview.h"


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

- (NSArray*)tableItemsForCategories:(NSArray*)categories {
    NSMutableArray* items = [NSMutableArray array];
    for (GTIOCategory* category in categories) {
        NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [category.apiEndpoint stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
        TTTableTextItem* item = [TTTableImageItem itemWithText:category.name imageURL:category.iconSmallURL URL:url];
        [items addObject:item];
    }
    return items;
}

- (NSArray*)tableItemsForOutfits:(NSArray*)outfits {
    NSMutableArray* items = [NSMutableArray array];
    for (GTIOOutfit* outfit in outfits) {
        GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
        [items addObject:item];
    }
    return items;
}

- (NSArray*)tableItemsForMyLooks:(NSArray*)outfits {
    NSMutableArray* items = [NSMutableArray array];
    for (GTIOOutfit* outfit in outfits) {
        GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
        [items addObject:item];
    }
    return items;
}

- (NSMutableArray*)tableItemsForReviews:(NSArray*)reviews {
    NSMutableArray* items = [NSMutableArray array];
    for (GTIOReview* review in reviews) {
        // Note: This allows us to use the old GTIOUserReviewTableItem... may want to refactor to make it more straight forward.
        GTIOOutfit* outfit = review.outfit;
        outfit.userReview = review.text;
        outfit.timestamp = review.timestamp;
        GTIOUserReviewTableItem* item = [GTIOUserReviewTableItem itemWithOutfit:outfit];
        [items addObject:item];
    }
    return items;
}

- (NSArray*)tableItems {
    if (self.categories) {
        return [self tableItemsForCategories:self.categories];
    }
    if (self.outfits) {
        return [self tableItemsForOutfits:self.outfits];
    }
    if (self.myLooks) {
        // TODO: these should use a different type of cell!
        return [self tableItemsForOutfits:self.myLooks];
    }
    if (self.reviews) {
        return [self tableItemsForReviews:self.reviews];
    }
    
    NSAssert(NO, @"No table items found for list: %@", self);
    return [NSArray array];
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

- (NSArray*)tableItemsWithSearchText:(NSString*)searchText {
    NSLog(@"Searching For Text: %@", searchText);
    if (self.categories) {
        NSMutableArray* matchingCategories = [self categoriesFilteredWithText:searchText];
        return [self tableItemsForCategories:matchingCategories];
    }
    NSAssert(NO, @"Don't know how to search anything but categories currently");
    return [NSArray array];
}

- (UISearchBar*)searchBar {
    if ([self.includeSearch boolValue]) {
        UISearchBar* searchBar = [[UISearchBar alloc] init];
        searchBar.tintColor = RGBCOLOR(212,212,212);
        [searchBar sizeToFit];
        
        searchBar.placeholder = self.searchText;
        
        if ([self.includeAlphaNav boolValue]) {
            [(UIScrollView*)searchBar setContentInset:UIEdgeInsetsMake(5, 0, 5, 35)];
        } else {
            [(UIScrollView*)searchBar setContentInset:UIEdgeInsetsMake(5, 0, 5, 0)];
        }
        return searchBar;
    }
    return nil;
}

- (NSArray*)alphabeticalListKeys {
    NSArray* sections = [@"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,#" componentsSeparatedByString:@","];
    return sections;
}

- (NSDictionary*)tableItemsGroupedAlphabeticallyFromCategories:(NSArray*)categories {
    if (nil == categories) {
        NSAssert(NO, @"We don't know how to group anything but categories currently.");
    }
    NSMutableDictionary* alphabeticalCategories = [NSMutableDictionary dictionary];
    for (GTIOCategory* category in categories) {
        NSString* upcasedFirstCharacterOfName = [[category.name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        if ([self.alphabeticalListKeys indexOfObject:upcasedFirstCharacterOfName] == NSNotFound) {
            upcasedFirstCharacterOfName = @"#";
        }
        NSMutableArray* items = [alphabeticalCategories objectForKey:upcasedFirstCharacterOfName];
        if (nil == items) {
            items = [NSMutableArray array];
            [alphabeticalCategories setObject:items forKey:upcasedFirstCharacterOfName];
        }
        NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [category.apiEndpoint stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
        TTTableTextItem* item = [TTTableImageItem itemWithText:category.name imageURL:category.iconSmallURL URL:url];
        [items addObject:item];
    }
    return alphabeticalCategories;
}

- (NSDictionary*)tableItemsGroupedAlphabetically {
    return [self tableItemsGroupedAlphabeticallyFromCategories:self.categories];
}

- (NSDictionary*)tableItemsGroupedAlphabeticallyWithFilterText:(NSString*)text {
    return [self tableItemsGroupedAlphabeticallyFromCategories:[self categoriesFilteredWithText:text]];
}

@end
