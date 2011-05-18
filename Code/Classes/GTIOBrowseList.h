//
//  GTIOBrowseList.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOBrowseList : NSObject {
    NSString* _title;
    NSString* _subtitle;
    NSNumber* _includeSearch;
    NSString* _searchText;
    NSNumber* _includeAlphaNav;
    NSArray* _categories; // A browse list will either contain categories
    NSArray* _outfits;    // or it will contain outfits.
    NSString* _searchAPI;
    NSArray* _sortTabs;
    NSArray* _stylists;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* subtitle;
@property (nonatomic, retain) NSNumber* includeSearch;
@property (nonatomic, retain) NSString* searchText;
@property (nonatomic, retain) NSNumber* includeAlphaNav;
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray* outfits;
@property (nonatomic, retain) NSString* searchAPI;
@property (nonatomic, retain) NSArray* sortTabs;
@property (nonatomic, retain) NSArray* stylists;

@end
