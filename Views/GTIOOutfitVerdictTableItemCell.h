//
//  GTIOOutfitVerdictTableItemCell.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOOutfitVerdictTableItem.h"
#import "GTIOTableItemCellWithQuote.h"

@interface GTIOOutfitVerdictTableItemCell : GTIOTableItemCellWithQuote {
	UILabel* _verdictTextLabel;
	UILabel* _verdictLabel;
	GTIOOutfitVerdictTableItem* _verdictItem;
}

@end

