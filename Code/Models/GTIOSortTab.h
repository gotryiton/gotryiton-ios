//
//  GTIOSortTab.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/16/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOSortTab : NSObject {
    NSString* _sortText;
    NSNumber* _defaultTab;
    NSNumber* _selected;
    NSString* _sortAPI;
}
@property (nonatomic, retain) NSString* sortText;
@property (nonatomic, retain) NSNumber* defaultTab;
@property (nonatomic, retain) NSNumber* selected;
@property (nonatomic, retain) NSString* sortAPI;

@end
