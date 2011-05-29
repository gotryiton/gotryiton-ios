//
//  GTIOSortTab.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/16/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOSortTab is an object representing a sorting option on a browse tableview

#import <Foundation/Foundation.h>


@interface GTIOSortTab : NSObject {
    NSString* _sortText;
    NSNumber* _defaultTab;
    NSNumber* _selected;
    NSString* _sortAPI;
    NSString* _subtitle;
    NSNumber* _badgeNumber;
    NSString* _title;
}
/// Text of the Tab
@property (nonatomic, retain) NSString* sortText;
/// default tab ?
@property (nonatomic, retain) NSNumber* defaultTab;
/// is selected?
@property (nonatomic, retain) NSNumber* selected;
/// API Endpoint for the tab
@property (nonatomic, retain) NSString* sortAPI;
/// Tab Subtitle
@property (nonatomic, retain) NSString* subtitle;
/// Badge Number to display on the tab
@property (nonatomic, retain) NSNumber* badgeNumber;
/// Title of the tab
@property (nonatomic, retain) NSString* title;

@end
