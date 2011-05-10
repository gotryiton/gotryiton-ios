//
//  GTIOOutfitReviewTableCell.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 1/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOOutfitReviewTableItem.h"

@interface GTIOOutfitReviewTableCell : TTTableViewCell {
	GTIOOutfitReviewTableItem* _reviewTableItem;
	UIImageView* _bgImageView;
	TTStyledTextLabel* _reviewTextLabel;
	UILabel* _authorLabel;
	UILabel* _agreeVotesLabel;
	UIButton* _deleteButton;
	UIButton* _agreeButton;
	UIButton* _flagButton;
    UIImageView* _authorCalloutImage;
    UIButton* _authorButton;
    
    NSMutableArray* _badgeImageViews;
}

@end
