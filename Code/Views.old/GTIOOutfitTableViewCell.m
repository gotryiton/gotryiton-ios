//
//  GTIOOutfitTableViewCell.m
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/22/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOOutfitTableViewCell.h"
#import "GTIOBadge.h"

@implementation GTIOOutfitTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_nameLabel.font = kGTIOFetteFontOfSize(22);
		_nameLabel.textColor = [UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.0];
		_nameLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_nameLabel];
		
		_locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_locationLabel.font = kGTIOFontHelveticaNeueOfSize(16);
		_locationLabel.textColor = [UIColor colorWithRed:0.604 green:0.604 blue:0.604 alpha:1.0];
		_locationLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_locationLabel];
		
        // TODO: badges?
		
		_eventLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_eventLabel.textColor = kGTIOColorBrightPink;
		_eventLabel.font = kGTIOFontHelveticaNeueOfSize(14);
		_eventLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_eventLabel];
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_outfitTableItem);
	TT_RELEASE_SAFELY(_nameLabel);
	TT_RELEASE_SAFELY(_locationLabel);
	TT_RELEASE_SAFELY(_eventLabel);
    TT_RELEASE_SAFELY(_badgeImageViews);
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[_nameLabel sizeToFit];
	_nameLabel.frame = CGRectMake(100, 21, 195, _nameLabel.bounds.size.height);
	
	[_locationLabel sizeToFit];
	if (TTOSVersion() >= 3.2) {
		_locationLabel.frame = CGRectMake(100, 38, 210, _locationLabel.bounds.size.height);
	} else {
		_locationLabel.frame = CGRectMake(100, 41, 210, _locationLabel.bounds.size.height);
	}
	[_eventLabel sizeToFit];
	_eventLabel.frame = CGRectOffset(_eventLabel.bounds, self.width - _eventLabel.width - 14, self.height - 28);
    
    [_nameLabel sizeToFit];
    int i = 0;
    for (UIView* view in _badgeImageViews) {
        view.frame = CGRectMake(100+_nameLabel.width+5+i*(16+5), 2+_locationLabel.height, 16, 16);
        i++;
    }
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
	_eventLabel.text = [NSString stringWithFormat:@"for %@", [_outfitTableItem.outfit event]];
    
    for (UIView* view in _badgeImageViews) {
        [view removeFromSuperview];
    }
    [_badgeImageViews release];
    _badgeImageViews = [NSMutableArray new];
    for (GTIOBadge* badge in _outfitTableItem.outfit.badges) {
        TTImageView* imageView = [[TTImageView alloc] initWithFrame:CGRectMake(0,0,16,16)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.urlPath = badge.imgURL;
        [self addSubview:imageView];
        [_badgeImageViews addObject:imageView];
    }
    
	
	[self setNeedsDisplay];
}

@end
