//
//  GTIOOutfitVerdictTableItem.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/18/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOOutfitVerdictTableItem is a TTTableLinkedItem used in ? ; candidate for deletion
#import <Foundation/Foundation.h>
#import "GTIOOutfit.h"

@interface GTIOOutfitVerdictTableItem : TTTableLinkedItem {
	GTIOOutfit* _outfit;
	NSInteger _index;
}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) GTIOOutfit* outfit;

+ (id)itemWithOutfit:(GTIOOutfit*)outfit;
+ (id)itemWithOutfit:(GTIOOutfit*)outfit index:(NSInteger)index;

@end

