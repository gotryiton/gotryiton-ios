//
//  GTIOOutfitTableViewItem.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/22/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOOutfit.h"

@interface GTIOOutfitTableViewItem : TTTableLinkedItem {
	GTIOOutfit* _outfit;
	NSInteger _index;
}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) GTIOOutfit* outfit;

+ (id)itemWithOutfit:(GTIOOutfit*)outfit;
+ (id)itemWithOutfit:(GTIOOutfit*)outfit index:(NSInteger)index;

@end
