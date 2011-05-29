//
//  GTIOUserReviewTableItemCell.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/27/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOUserReviewTableItemCell is the TTTableViewCell for [GTIOUserReviewTableItem](GTIOUserReviewTableItem)
#import "GTIOTableItemCellWithQuote.h"
#import "GTIOUserReviewTableItem.h"

@interface GTIOUserReviewTableItemCell : GTIOTableItemCellWithQuote {
	UILabel* _nameLabel;
	UILabel* _locationLabel;
    UILabel* _scoreLabel;
	GTIOUserReviewTableItem* _reviewItem;
}


@end
