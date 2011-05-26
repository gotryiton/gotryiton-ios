//
//  GTIOUserReviewTableItem.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/27/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOOutfit.h"

@interface GTIOUserReviewTableItem : TTTableLinkedItem {
	GTIOOutfit* _outfit;
	NSInteger _index;
}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) GTIOOutfit* outfit;


+ (id)itemWithOutfit:(GTIOOutfit*)outfit;
+ (id)itemWithOutfit:(GTIOOutfit*)outfit index:(NSInteger)index;

@end
