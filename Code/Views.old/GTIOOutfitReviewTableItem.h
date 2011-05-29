//
//  GTIOOutfitReviewTableItem.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 1/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOOutfitReviewTableItem is a subclass of TTTableItem for [GTIOOutfitReviewsController](GTIOOutfitReviewsController)

#import "GTIOReview.h"

@interface GTIOOutfitReviewTableItem : TTTableItem {
	GTIOReview* _review;
}
/// review
@property (nonatomic, retain) GTIOReview* review;

+ (id)itemWithReview:(GTIOReview*)review;

@end
