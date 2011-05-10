//
//  GTIOUserReviewTableItemCell.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOUserReviewTableItemCell.h"


@implementation GTIOUserReviewTableItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		_locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_locationLabel.font = kGTIOFontHelveticaNeueOfSize(13);
		_locationLabel.textColor = kGTIOColor9A9A9A;
		_locationLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:_locationLabel];
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_nameLabel.font = kGTIOFetteFontOfSize(20);
		_nameLabel.textColor = kGTIOColor636363;
		_nameLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:_nameLabel];
		self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-my-reviews.png"]];
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_reviewItem);
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	_nameLabel.frame = CGRectMake(95, 55, 150, 28);
	_locationLabel.frame = CGRectMake(95, 75, 200, 18);
	[_locationLabel setClipsToBounds:NO];
	[self layoutQuote];
}

- (NSString*)thumbnailUrlPath {
	return [[_reviewItem outfit] iphoneThumbnailUrl];
}

- (BOOL)isMultipleOutfitCell {
	return [[[_reviewItem outfit] isMultipleOption] boolValue];
}

- (int)cellIndex {
	return [_reviewItem index];
}

- (void)setObject:(id)obj {
	GTIOUserReviewTableItem* item = (GTIOUserReviewTableItem*)obj;
	_reviewItem = [item retain];
	
	[super setObject:obj];
	
	_nameLabel.text = [item.outfit.name uppercaseString];
	_locationLabel.text = item.outfit.location;
	
	NSString* text = item.outfit.userReview;
	if ([text length] > 35) {
		text = [NSString stringWithFormat:@"%@...",
				[text substringToIndex:32]];
	}
	self.quote = [NSString stringWithFormat:@"%@",  _reviewItem.outfit.userReview];
}

@end

