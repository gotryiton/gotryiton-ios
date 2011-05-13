//
//  GTIOBrowseList.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOBrowseList.h"


@implementation GTIOBrowseList

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize includeSearch = _includeSearch;
@synthesize searchText = _searchText;
@synthesize includeAlphaNav = _includeAlphaNav;
@synthesize categories = _categories;
@synthesize outfits = _outfits;

- (void)dealloc {
    [_title release];
    [_subtitle release];
    [_includeSearch release];
    [_searchText release];
    [_includeAlphaNav release];
    [_categories release];
    [_outfits release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<GTIOBrowseList title: %@ subtitle: %@ includeSearch: %@ searchText: %@ includeAlphaNav: %@"
            @"categories: %@ num outfits: %d", _title, _subtitle, _includeSearch, _searchText, _includeAlphaNav,
            [[_categories valueForKey:@"name"] componentsJoinedByString:@","], [_outfits count]];
}

@end
