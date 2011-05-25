//
//  GTIOUserReviewTableItem.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOUserReviewTableItem.h"


@implementation GTIOUserReviewTableItem

@synthesize index = _index;
@synthesize outfit = _outfit;

+ (id)itemWithOutfit:(GTIOOutfit*)outfit {
	GTIOUserReviewTableItem* item = [[[self alloc] init] autorelease];
	[item setOutfit:outfit];
	item.index = -1;
	//item.URL = [NSString stringWithFormat:@"gtio://looks/%@", outfit.sid];
	return item;
}

+ (id)itemWithOutfit:(GTIOOutfit*)outfit index:(NSInteger)index {
	GTIOUserReviewTableItem* item = [self itemWithOutfit:outfit];
	item.index = index;
	return item;
}


- (void)dealloc {
	TT_RELEASE_SAFELY(_outfit);
	[super dealloc];
}

@end
