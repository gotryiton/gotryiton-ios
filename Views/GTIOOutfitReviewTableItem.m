//
//  GTIOOutfitReviewTableItem.m
//  GoTryItOn
//
//  Created by Daniel Hammond on 1/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOOutfitReviewTableItem.h"


@implementation GTIOOutfitReviewTableItem

@synthesize review = _review;

+ (id)itemWithReview:(GTIOReview*)review {
	GTIOOutfitReviewTableItem* item = [[[self alloc] init] autorelease];
	[item setReview:review];
	return item;
}


@end
