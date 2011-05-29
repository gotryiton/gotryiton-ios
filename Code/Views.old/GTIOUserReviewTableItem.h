//
//  GTIOUserReviewTableItem.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/27/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOUserReviewTableItem is a TTTableItem used in the [GTIOUserReviewsTableViewController](GTIOUserReviewsTableViewController) 
#import <Foundation/Foundation.h>
#import "GTIOOutfit.h"

@interface GTIOUserReviewTableItem : TTTableLinkedItem {
	GTIOOutfit* _outfit;
	NSInteger _index;
}
/// index of outfit
@property (nonatomic, assign) NSInteger index;
/// outfit object 
@property (nonatomic, retain) GTIOOutfit* outfit;

/// returns an item with object
+ (id)itemWithOutfit:(GTIOOutfit*)outfit;
/// returns an item with object and index
+ (id)itemWithOutfit:(GTIOOutfit*)outfit index:(NSInteger)index;

@end
