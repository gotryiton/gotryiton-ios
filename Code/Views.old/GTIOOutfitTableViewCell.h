//
//  GTIOOutfitTableViewCell.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/22/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOOutfitTableViewCell is a subclass of [GTIOTableItemCellWithQuote](GTIOTableItemCellWithQuote) used in [GTIOBrowseTableViewController](GTIOBrowseTableViewController) 
/// for [GTIOOutfit](GTIOOutfit) objects
#import <Foundation/Foundation.h>
#import "GTIOOutfitTableViewItem.h"
#import "GTIOTableItemCellWithQuote.h"

@interface GTIOOutfitTableViewCell : GTIOTableItemCellWithQuote {
	GTIOOutfitTableViewItem* _outfitTableItem;
	UILabel* _nameLabel;
	UILabel* _locationLabel;
	UILabel* _eventLabel;
    NSMutableArray* _badgeImageViews;
}

@end
