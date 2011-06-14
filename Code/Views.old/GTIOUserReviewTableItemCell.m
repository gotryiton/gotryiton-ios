//
//  GTIOUserReviewTableItemCell.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/27/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOUserReviewTableItemCell.h"


@implementation GTIOUserReviewTableItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		_locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_locationLabel.font = kGTIOFontHelveticaNeueOfSize(10);
		_locationLabel.textColor = kGTIOColor9A9A9A;
		_locationLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:_locationLabel];
        
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_nameLabel.font = kGTIOFetteFontOfSize(15);
		_nameLabel.textColor = kGTIOColor646464;
		_nameLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:_nameLabel];
        
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _scoreLabel.font = kGTIOFontBoldHelveticaNeueOfSize(15);
        _scoreLabel.textColor = kGTIOColorBrightPink;
        _scoreLabel.backgroundColor = [UIColor clearColor];
        [[self contentView] addSubview:_scoreLabel];
        
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-my-reviews.png"]];
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_reviewItem);
    TT_RELEASE_SAFELY(_scoreLabel);
    TT_RELEASE_SAFELY(_nameLabel);
    TT_RELEASE_SAFELY(_locationLabel);
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
    [_nameLabel sizeToFit];
	_nameLabel.frame = CGRectMake(98, 78, MIN(_nameLabel.bounds.size.width, 100), _nameLabel.bounds.size.height);
    
    [_locationLabel sizeToFit];
	_locationLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 5, 77, MIN(_locationLabel.bounds.size.width, 160-_nameLabel.bounds.size.width), 18);
    
    [_scoreLabel sizeToFit];
    _scoreLabel.frame = CGRectMake(self.contentView.bounds.size.width - _scoreLabel.bounds.size.width - 16, 75, _scoreLabel.bounds.size.width, _scoreLabel.bounds.size.height);
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
    // TODO
    
    _scoreLabel.text = [NSString stringWithFormat:@"+%d", [item.outfit.userReviewAgreeVotes intValue]];
	
	NSString* text = item.outfit.userReview;
	if ([text length] > 35) {
		text = [NSString stringWithFormat:@"%@...",
				[text substringToIndex:32]];
	}
	self.quote = [NSString stringWithFormat:@"%@",  _reviewItem.outfit.userReview];
}

@end

