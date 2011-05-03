//
//  GTIOOutfitReviewTableItem.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 1/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOReview.h"

@interface GTIOOutfitReviewTableItem : TTTableItem {
	GTIOReview* _review;
}

@property (nonatomic, retain) GTIOReview* review;

+ (id)itemWithReview:(GTIOReview*)review;

@end
