//
//  GTIOGiveAnOpinionTableViewDataSource.m
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/23/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/Three20/Three20.h>

#import "GTIOGiveAnOpinionTableViewDataSource.h"

#import "GTIOOutfit.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOOutfitTableViewCell.h"

@implementation GTIOGiveAnOpinionTableViewDataSource
@synthesize outfits = _outfits;

- (TTTableItem*)tableItemForObject:(id)object {
	if ([object isKindOfClass:[GTIOOutfit class]]) {
		return [GTIOOutfitTableViewItem itemWithOutfit:object];
	} else {
		return [TTTableTextItem itemWithText:[object description]];
	}
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOOutfitTableViewItem class]]) {
		return [GTIOOutfitTableViewCell class];	
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
	
}

- (NSString*)titleForEmpty {
	return @"No Outfits Found";
}

@end
