//
//  GTIOOutfitTableViewItem.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/22/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOOutfitTableViewCell is a subclass of [TTTableLinkedItem](TTTableLinkedItem) used in [GTIOBrowseTableViewController](GTIOBrowseTableViewController) 
/// for [GTIOOutfit](GTIOOutfit) objects

#import "GTIOOutfit.h"

@interface GTIOOutfitTableViewItem : TTTableLinkedItem {
	GTIOOutfit* _outfit;
	NSInteger _index;
}
/// index of item
@property (nonatomic, assign) NSInteger index;
/// outfit object
@property (nonatomic, retain) GTIOOutfit* outfit;

/// initialize item with outfit
+ (id)itemWithOutfit:(GTIOOutfit*)outfit;
/// initialize item with outfit and index
+ (id)itemWithOutfit:(GTIOOutfit*)outfit index:(NSInteger)index;

@end
