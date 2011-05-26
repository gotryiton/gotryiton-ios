//
//  GTIOOutfitVerdictTableItemCell.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/18/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOOutfitVerdictTableItemCell.h"
#import <Three20/Three20.h>


@implementation GTIOOutfitVerdictTableItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		_verdictTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_verdictTextLabel.font = kGTIOFontBoldHelveticaNeueOfSize(12);
		_verdictTextLabel.text = @"VERDICT";
		_verdictTextLabel.textColor = kGTIOColor9A9A9A;
		_verdictTextLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:_verdictTextLabel];
		_verdictLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_verdictLabel.font = kGTIOFontHelveticaNeueOfSize(12);
		_verdictLabel.textColor = kGTIOColorED139A;
		_verdictLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:_verdictLabel];
		self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-default.png"]];
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_verdictTextLabel);
	TT_RELEASE_SAFELY(_verdictLabel);
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
    [_verdictLabel sizeToFit];
    _verdictLabel.frame = CGRectOffset(_verdictLabel.bounds, self.width - _verdictLabel.width - 13, self.height - 28);
    [_verdictTextLabel sizeToFit];
    _verdictTextLabel.frame = CGRectOffset(_verdictLabel.bounds, self.width - _verdictLabel.width - 5 - _verdictTextLabel.width - 13, self.height - 28);
}

- (NSString*)thumbnailUrlPath {
	return [[_verdictItem outfit] iphoneThumbnailUrl];
}

- (BOOL)isMultipleOutfitCell {
	return [[[_verdictItem outfit] isMultipleOption] boolValue];
}

- (int)cellIndex {
	return [_verdictItem index];
}

- (void)setObject:(id)obj {
	GTIOOutfitVerdictTableItem* item = (GTIOOutfitVerdictTableItem*)obj;
	_verdictItem = [item retain];
	_verdictLabel.text = [item.outfit.results.verdict uppercaseString];
	
	[super setObject:obj];
	
	NSString* text = item.outfit.descriptionString;
	if ([text length] > 35) {
		text = [NSString stringWithFormat:@"%@...",
				[text substringToIndex:32]];
	}
	self.quote = [NSString stringWithFormat:@"%@",  _verdictItem.outfit.descriptionString];
}

@end