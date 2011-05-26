//
//  GTIOBrowseList.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

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

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* subtitle;
@property (nonatomic, retain) NSNumber* includeSearch;
@property (nonatomic, retain) NSString* searchText;
@property (nonatomic, retain) NSNumber* includeAlphaNav;
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray* outfits;
@property (nonatomic, retain) NSString* searchAPI;
@property (nonatomic, retain) NSArray* sortTabs;
@property (nonatomic, retain) NSArray* tabs;
@property (nonatomic, retain) NSArray* stylists;
@property (nonatomic, retain) NSArray* sections;
@property (nonatomic, retain) NSArray* reviews;
@property (nonatomic, retain) NSArray* myLooks;

@end
