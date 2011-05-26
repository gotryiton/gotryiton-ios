//
//  GTIOSortTab.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/16/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOSortTab.h"


@implementation GTIOSortTab

@synthesize sortText = _sortText;
@synthesize defaultTab = _defaultTab;
@synthesize selected = _selected;
@synthesize sortAPI = _sortAPI;
@synthesize subtitle = _subtitle;
@synthesize badgeNumber = _badgeNumber;
@synthesize title = _title;

- (void)dealloc {
    [_sortText release];
    [_defaultTab release];
    [_selected release];
    [_sortAPI release];
    [_subtitle release];
    [_badgeNumber release];
    [_title release];
    [super dealloc];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<GTIOSortTab sortText: %@ title: %@ defaultTab: %@ selected: %@ api: %@ subtitle: %@ badgeNumber: %@", _sortText, _title, _defaultTab, _selected, _sortAPI, _subtitle, _badgeNumber];
}

@end
