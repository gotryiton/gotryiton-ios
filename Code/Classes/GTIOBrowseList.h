//
//  GTIOBrowseList.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOBrowseList is a list of either categories, reviews, sections, or myLooks
#import <Foundation/Foundation.h>
#import "GTIOBannerAd.h"
#import "GTIOTopRightBarButton.h"

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
    GTIOBannerAd* _bannerAd;
    GTIOTopRightBarButton* _topRightButton;
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

@property (nonatomic, retain) GTIOBannerAd* bannerAd;
@property (nonatomic, retain) GTIOTopRightBarButton* topRightButton;

- (NSMutableArray*)categoriesFilteredWithText:(NSString*)text;

@end
