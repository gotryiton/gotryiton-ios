//
//  GTIOSortTab.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/16/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOSortTab.h"


@implementation GTIOSortTab

@synthesize sortText = _sortText;
@synthesize defaultTab = _defaultTab;
@synthesize selected = _selected;
@synthesize sortAPI = _sortAPI;

- (void)dealloc {
    [_sortText release];
    [_defaultTab release];
    [_selected release];
    [_sortAPI release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<GTIOSortTab sortText: %@ defaultTab: %@ selected: %@ sortAPI: %@", _sortText, _defaultTab, _selected, _sortAPI];
}

@end
