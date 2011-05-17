//
//  GTIOOutfitTableViewItem.m
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/22/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOOutfitTableViewItem.h"


@implementation GTIOOutfitTableViewItem

@synthesize index = _index;
@synthesize outfit = _outfit;

+ (id)itemWithOutfit:(GTIOOutfit*)outfit {
	GTIOOutfitTableViewItem* item = [[[self alloc] init] autorelease];
	[item setOutfit:outfit];
	item.index = -1;
	
    // TODO: looks screen doesn't seem to work at all right now.
	//item.URL = [NSString stringWithFormat:@"gtio://looks/%@", outfit.sid];
	item.URL = [NSString stringWithFormat:@"gtio://profile/%@", outfit.uid];
	
	return item;
}

+ (id)itemWithOutfit:(GTIOOutfit*)outfit index:(NSInteger)index {
	GTIOOutfitTableViewItem* item = [self itemWithOutfit:outfit];
	item.index = index;
	return item;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_outfit);

	[super dealloc];
}

@end