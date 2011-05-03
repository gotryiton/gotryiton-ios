//
//  GTIOOutfitTableViewCell.m
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/22/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOOutfitTableViewCell.h"

//static CGFloat kHPadding = 10 - 2;
//static CGFloat kVPadding = 12.5 - 1;

@implementation GTIOOutfitTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_nameLabel.font = kGTIOFetteFontOfSize(20);
		_nameLabel.textColor = [UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.0];
		_nameLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_nameLabel];
		
		_locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_locationLabel.font = kGTIOFontHelveticaNeueOfSize(13);
		_locationLabel.textColor = [UIColor colorWithRed:0.604 green:0.604 blue:0.604 alpha:1.0];
		_locationLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_locationLabel];
		
		_forLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_forLabel.text = @"FOR";
		_forLabel.textColor = [UIColor colorWithRed:0.604 green:0.604 blue:0.604 alpha:1.0];
		_forLabel.font = kGTIOFontBoldHelveticaNeueOfSize(12);
		_forLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_forLabel];
		
		_eventLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_eventLabel.textColor = [UIColor colorWithRed:0.929 green:0.075 blue:0.62 alpha:1.0];
		_eventLabel.font = kGTIOFontHelveticaNeueOfSize(13);
		_eventLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_eventLabel];
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_outfitTableItem);
	TT_RELEASE_SAFELY(_nameLabel);
	TT_RELEASE_SAFELY(_locationLabel);
	TT_RELEASE_SAFELY(_forLabel);
	TT_RELEASE_SAFELY(_eventLabel);
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[_nameLabel sizeToFit];
	_nameLabel.frame = CGRectMake(95, 11, 195, _nameLabel.bounds.size.height);
	
	[_locationLabel sizeToFit];
	if (TTOSVersion() >= 3.2) {
		_locationLabel.frame = CGRectMake(95, 28, 210, _locationLabel.bounds.size.height);
	} else {
		_locationLabel.frame = CGRectMake(95, 31, 210, _locationLabel.bounds.size.height);
	}
	[_forLabel sizeToFit];
	_forLabel.frame = CGRectOffset(_forLabel.bounds, self.width - _forLabel.width - 14, self.height - 41);
	[_eventLabel sizeToFit];
	_eventLabel.frame = CGRectOffset(_eventLabel.bounds, self.width - _eventLabel.width - 14, self.height - 28);
}

- (NSString*)thumbnailUrlPath {
	return [[_outfitTableItem outfit] iphoneThumbnailUrl];
}

- (BOOL)isMultipleOutfitCell {
	return [[[_outfitTableItem outfit] isMultipleOption] boolValue];
}

- (int)cellIndex {
	return [_outfitTableItem index];
}

- (void)setObject:(id)object {
	[_outfitTableItem release];
	_outfitTableItem = [object retain];
	[super setObject:object];
	
	self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-default.png"]];
	_nameLabel.text = [[[_outfitTableItem outfit] name] uppercaseString];
	_locationLabel.text = [_outfitTableItem.outfit location];
	_eventLabel.text = [_outfitTableItem.outfit event];
	
	[self setNeedsDisplay];
}

@end
