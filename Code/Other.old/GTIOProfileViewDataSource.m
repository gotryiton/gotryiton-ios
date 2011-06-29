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
#import "GTIOProfile.h"
#import <TWTURLButton.h>
#import "GTIOBadge.h"

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
    self.backgroundColor = [UIColor whiteColor];
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

@interface GTIOStylistBadge : UIView {
    TWTURLButton* _button;
    TTImageView* _profileImageView;
    UIImageView* _profileImageOverlay;
    UILabel* _nameLabel;
    UILabel* _locationLabel;
    NSMutableArray* _badgeImageViews;
    UIImageView* _connectionIcon;
}

+ (id)badgeForStylist:(GTIOProfile*)profile;
- (id)initWithStylist:(GTIOProfile*)profile;

@end

@implementation GTIOStylistBadge

+ (id)badgeForStylist:(GTIOProfile*)profile {
    return [[[GTIOStylistBadge alloc] initWithStylist:profile] autorelease];
}

- (id)initWithStylist:(GTIOProfile*)profile {
    if ((self = [self init])) {
        _button = [[TWTURLButton alloc] initWithFrame:CGRectZero];
        [_button setImage:[UIImage imageNamed:@"profile-stylist-card.png"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"profile-stylist-card.png"] forState:UIControlStateHighlighted];
        _button.clickUrl = [NSString stringWithFormat:@"gtio://profile/%@", profile.uid];
        [self addSubview:_button];
        
        _profileImageView = [[TTImageView alloc] initWithFrame:CGRectZero];
        _profileImageView.urlPath = profile.profileIconURL;
        [self addSubview:_profileImageView];
        
        _profileImageOverlay = [[UIImageView alloc] initWithFrame:CGRectZero];
        _profileImageOverlay.image = [UIImage imageNamed:@"icon-overlay-110.png"];
        [self addSubview:_profileImageOverlay];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = kGTIOColorBrightPink;
        _nameLabel.font = kGTIOFetteFontOfSize(18);
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.minimumFontSize = 14;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLabel];
        _nameLabel.text = profile.displayName;
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationLabel.textColor = RGBCOLOR(130,130,130);
        _locationLabel.font = kGTIOFontHelveticaNeueOfSize(9);
        _locationLabel.adjustsFontSizeToFitWidth = YES;
        _locationLabel.minimumFontSize = 8;
        _locationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_locationLabel];
        _locationLabel.text = profile.location;
        
        _connectionIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _connectionIcon.image = [profile.stylistRelationship imageForConnection];
        [self addSubview:_connectionIcon];
        
        for (UIView* view in _badgeImageViews) {
            [view removeFromSuperview];
        }
        [_badgeImageViews release];
        _badgeImageViews = [NSMutableArray new];
        for (GTIOBadge* badge in profile.badges) {
            TTImageView* badgeView = [[[TTImageView alloc] initWithFrame:CGRectZero] autorelease];
            badgeView.urlPath = badge.imgURL;
            [self addSubview:badgeView];
            [_badgeImageViews addObject:badgeView];
        }
    }
    return self;
}

- (void)dealloc {
    [_button release];
    [_profileImageView release];
    [_profileImageOverlay release];
    [_nameLabel release];
    [_locationLabel release];
    [_badgeImageViews release];
    [_connectionIcon release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _button.frame = self.bounds;
    _profileImageOverlay.frame = CGRectMake(4,4,44,44);
    _profileImageView.frame = CGRectInset(_profileImageOverlay.frame,3,3);
    
    int numBadges = [_badgeImageViews count];
    _nameLabel.frame = CGRectMake(55,15,60,15);
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(55,15,MIN(_nameLabel.bounds.size.width, 60-(15*numBadges)),15);
    float badgeX = CGRectGetMaxX(_nameLabel.frame) + 3;
    for (UIView* badgeView in _badgeImageViews) {
        badgeView.frame = CGRectMake(badgeX, 15, 12, 12);
        badgeX += 15;
    }
    
    
    _connectionIcon.frame = CGRectMake(self.bounds.size.width - 20,3,17,16);
    _locationLabel.frame = CGRectMake(55,30,80,10);
}

@end

@implementation GTIOStylistBadgesTableViewItem

@synthesize stylists = _stylists;

+ (id)itemWithStylists:(NSArray*)stylists {
    GTIOStylistBadgesTableViewItem* item = [[[self alloc] init] autorelease];
    item.stylists = stylists;
    return item;
}

@end

@interface GTIOStylistBadgesTableViewItemCell : TTTableViewCell {
    NSMutableArray* _stylistBadges;
}
@end

@implementation GTIOStylistBadgesTableViewItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(GTIOStylistBadgesTableViewItem*)object {
	return 40 + (ceil([object.stylists count]/2.0f) * 60);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.text = @"stylists";
    self.textLabel.frame = CGRectMake(10,1,300,39);
    self.textLabel.font = kGTIOFontHelveticaNeueOfSize(20);
    self.textLabel.textColor = TTSTYLEVAR(textColor);
    
    float y = 40;
    for (int i = 0; i < [_stylistBadges count]; i++) {
        UIView* badge = [_stylistBadges objectAtIndex:i];
        
        int evenOrOdd = i%2;
        float x = (evenOrOdd * 156) + 8;
        
        badge.frame = CGRectMake(x, y, 148, 52);
        if (evenOrOdd == 1) {
            y += 60;
        }
    }
    
}

- (void)setObject:(id)obj {
    [super setObject:obj];
    GTIOStylistBadgesTableViewItem* item = (GTIOStylistBadgesTableViewItem*)obj;
    // stylists = item.stylists
    
    for (UIView* view in _stylistBadges) {
        [view removeFromSuperview];
    }
    [_stylistBadges release];
    _stylistBadges = [NSMutableArray new];
    
    for (GTIOProfile* profile in item.stylists) {
        GTIOStylistBadge* badge = [GTIOStylistBadge badgeForStylist:profile];
        [self.contentView addSubview:badge];
        [_stylistBadges addObject:badge];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
	if ([object isKindOfClass:[GTIOStylistBadgesTableViewItem class]]) {
        return [GTIOStylistBadgesTableViewItemCell class];  
    } else if ([object isKindOfClass:[GTIOOutfitVerdictTableItem class]]) {
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
