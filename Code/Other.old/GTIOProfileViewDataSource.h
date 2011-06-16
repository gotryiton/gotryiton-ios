//
//  GTIOProfileViewDataSource.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/14/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOProfileViewDataSource is the data source for [GTIOProfileViewController](GTIOProfileViewController)
#import <Three20/Three20.h>

@interface GTIOProfileViewDataSource : TTListDataSource {
	
}

@end

@interface GTIOPinkTableTextItem : TTTableTextItem
@end

@interface GTIOStylistBadgesTableViewItem : TTTableItem {
    NSArray* _stylists;
}
@property (nonatomic, retain) NSArray* stylists;

+ (id)itemWithStylists:(NSArray*)stylists;

@end