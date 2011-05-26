//
//  GTIOOutfitVerdictTableItem.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/18/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOOutfitVerdictTableItem.h"


@implementation GTIOOutfitVerdictTableItem

@synthesize index = _index;
@synthesize outfit = _outfit;

+ (id)itemWithOutfit:(GTIOOutfit*)outfit {
	GTIOOutfitVerdictTableItem* item = [[[self alloc] init] autorelease];
	[item setOutfit:outfit];
	item.index = -1;
	item.URL = [NSString stringWithFormat:@"gtio://looks/%@", outfit.sid];
	return item;
}

+ (id)itemWithOutfit:(GTIOOutfit*)outfit index:(NSInteger)index {
	GTIOOutfitVerdictTableItem* item = [self itemWithOutfit:outfit];
	item.index = index;
	return item;
}


- (void)dealloc {
	TT_RELEASE_SAFELY(_outfit);
	[super dealloc];
}

@end