//
//  GTIOBrowseListPresenter.m
//  GTIO
//
//  Created by Jeremy Ellison on 6/3/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOBrowseListPresenter.h"
#import "GTIOCategory.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOUserReviewTableItem.h"
#import "GTIOReview.h"
#import "GTIOListSection.h"

@implementation GTIOBrowseListPresenter

- (id)initWithList:(GTIOBrowseList*)list {
    if ((self = [super init])) {
        _list = [list retain];
    }
    return self;
}

+ (id)presenterWithList:(GTIOBrowseList*)list {
    return [[[self alloc] initWithList:list] autorelease];
}

- (void)dealloc {
    [_list release];
    [super dealloc];
}

- (NSString*)subtitle {
    return _list.subtitle;
}

- (NSMutableArray*)tableItemsForCategories:(NSArray*)categories {
    NSMutableArray* items = [NSMutableArray array];
    for (GTIOCategory* category in categories) {
        NSString* url = [NSString stringWithFormat:@"gtio://browse/%@", [category.apiEndpoint stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
        TTTableTextItem* item = [TTTableImageItem itemWithText:category.name imageURL:category.iconSmallURL URL:url];
        [items addObject:item];
    }
    return items;
}

- (NSMutableArray*)tableItemsForOutfits:(NSArray*)outfits {
    NSMutableArray* items = [NSMutableArray array];
    for (GTIOOutfit* outfit in outfits) {
        GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
        [items addObject:item];
    }
    return items;
}

- (NSMutableArray*)tableItemsForMyLooks:(NSArray*)outfits {
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
        outfit.userReviewAgreeVotes = review.agreeVotes;
        GTIOUserReviewTableItem* item = [GTIOUserReviewTableItem itemWithOutfit:outfit];
        item.userInfo = review;
        [items addObject:item];
    }
    return items;
}

- (NSMutableArray*)sectionNames {
    NSMutableArray* sectionNames = [NSMutableArray array];
    for (GTIOListSection* section in _list.sections) {
        [sectionNames addObject:section.title];
    }
    return sectionNames;
}

- (NSMutableArray*)tableItemsForSections {
    NSMutableArray* sections = [NSMutableArray array];
    for (GTIOListSection* section in _list.sections) {
        NSMutableArray* items  = [NSMutableArray array];
        for (GTIOOutfit* outfit in section.outfits) {
            GTIOOutfitTableViewItem* item = [GTIOOutfitTableViewItem itemWithOutfit:outfit];
            [items addObject:item];
        }
        [sections addObject:items];
    }
    return sections;
}

- (NSMutableArray*)tableItems {
    if (_list.categories) {
        return [self tableItemsForCategories:_list.categories];
    }
    if (_list.outfits) {
        return [self tableItemsForOutfits:_list.outfits];
    }
    if (_list.myLooks) {
        // TODO: these should use a different type of cell!
        return [self tableItemsForOutfits:_list.myLooks];
    }
    if (_list.reviews) {
        return [self tableItemsForReviews:_list.reviews];
    }
    if (_list.sections) {
        return [self tableItemsForSections];
    }
    
//    NSAssert(NO, @"No table items found for list: %@", self);
    return [NSMutableArray array];
}

- (NSMutableArray*)tableItemsWithSearchText:(NSString*)searchText {
    NSLog(@"Searching For Text: %@", searchText);
    if (_list.categories) {
        NSMutableArray* matchingCategories = [_list categoriesFilteredWithText:searchText];
        return [self tableItemsForCategories:matchingCategories];
    }
    NSAssert(NO, @"Don't know how to search anything but categories currently");
    return [NSMutableArray array];
}

- (UISearchBar*)searchBar {
    if ([_list.includeSearch boolValue]) {
        UISearchBar* searchBar = [[UISearchBar alloc] init];
        searchBar.tintColor = RGBCOLOR(212,212,212);
        [searchBar sizeToFit];
        
        searchBar.placeholder = _list.searchText;
        
        if ([_list.includeAlphaNav boolValue]) {
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
    return [self tableItemsGroupedAlphabeticallyFromCategories:_list.categories];
}

- (NSDictionary*)tableItemsGroupedAlphabeticallyWithFilterText:(NSString*)text {
    return [self tableItemsGroupedAlphabeticallyFromCategories:[_list categoriesFilteredWithText:text]];
}

- (NSArray*)tabs {
    if (_list.sortTabs) {
        return _list.sortTabs;
    }
    return _list.tabs;
}

- (NSArray*)tabNames {
    if (_list.sortTabs) {
        return [_list.sortTabs valueForKey:@"sortText"];
    }
    return [_list.tabs valueForKey:@"title"];
}

@end
