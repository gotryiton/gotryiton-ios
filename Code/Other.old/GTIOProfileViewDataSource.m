//
//  GTIOProfileViewDataSource.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/14/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOProfileViewDataSource.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitTableViewCell.h"
#import "GTIOOutfitTableViewItem.h"
#import "GTIOTableStatsItem.h"
#import "GTIOOutfitVerdictTableItem.h"
#import "GTIOOutfitVerdictTableItemCell.h"
/// GTIOTableTextCell is subclass of [TTTableTextItemCell](TTTableTextItemCell) that draws a 1px border on its bottom and sets a specific font
@interface GTIOTableTextCell : TTTableTextItemCell {
	UIView* _separator;
    UIView* _separator2;
}

@end

@implementation GTIOTableTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		_separator2 = [[UIView alloc] initWithFrame:CGRectZero];
		_separator2.backgroundColor = kGTIOColorCCCCCC;
		[self addSubview:_separator2];
        
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
		_separator.backgroundColor = kGTIOColorCCCCCC;
		[self addSubview:_separator];
	}
	return self;
}

- (void)dealloc {
    [_separator release];
	[_separator2 release];
	[super dealloc];
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	return 45;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    _separator.frame = CGRectMake(0,0, 320, 1);
	_separator2.frame = CGRectMake(0, self.bounds.size.height, 320, 1);
}

- (void)setObject:(id)obj {
	[super setObject:obj];
	self.textLabel.font = kGTIOFontHelveticaNeueOfSize(20);
}

@end

@implementation GTIOPinkTableTextItem
@end

@interface GTIOPinkTableTextItemCell : GTIOTableTextCell
@end
@implementation GTIOPinkTableTextItemCell

- (void)setObject:(id)obj {
	[super setObject:obj];
	self.textLabel.textColor = kGTIOColorBrightPink;
}

@end


/// GTIOProfileViewDataSource is the data source for [GTIOProfileViewController](GTIOProfileViewController)
@implementation GTIOProfileViewDataSource

- (TTTableItem*)tableItemForObject:(id)object {
	if ([object isKindOfClass:[GTIOOutfit class]]) {
		return [GTIOOutfitTableViewItem itemWithOutfit:object];
	} else {
		return [TTTableTextItem itemWithText:[object description]];
	}
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object { 
	if ([object isKindOfClass:[GTIOOutfitVerdictTableItem class]]) {
		return [GTIOOutfitVerdictTableItemCell class];
	} else if ([object isKindOfClass:[GTIOPinkTableTextItem class]]) {
        return [GTIOPinkTableTextItemCell class];
    } else if ([object isKindOfClass:[GTIOOutfitTableViewItem class]]) {
		return [GTIOOutfitTableViewCell class];	
	} else if ([object isKindOfClass:[GTIOTableStatsItem class]]) {
		return [GTIOTableStatsCell class];
	} else if ([object isKindOfClass:[GTIOIndividualStatItem class]]) {
		return [GTIOIndividualStatCell class];
	} else if ([object isKindOfClass:[TTTableTextItem class]]) {
		return [GTIOTableTextCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
	
}

@end
