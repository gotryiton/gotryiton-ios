//
//  GTIOOutfitTableViewCell.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/22/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOOutfitTableViewItem.h"
#import "GTIOTableItemCellWithQuote.h"

@interface GTIOOutfitTableViewCell : GTIOTableItemCellWithQuote {
	GTIOOutfitTableViewItem* _outfitTableItem;
	UILabel* _nameLabel;
	UILabel* _locationLabel;
	UILabel* _forLabel;
	UILabel* _eventLabel;
}

@end
