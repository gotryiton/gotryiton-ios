//
//  GTIOMeTableViewCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMeTableViewCell.h"

@interface GTIOMeTableViewCell()

@property (nonatomic, strong) UIImageView *heart;
@property (nonatomic, strong) GTIOSwitch *toggleSwitch;
@property (nonatomic, strong) UIImageView *chevron;

@end

@implementation GTIOMeTableViewCell

@synthesize heart = _heart, hasHeart = _hasHeart, hasToggle = _hasToggle, toggleSwitch = _toggleSwitch, hasChevron = _hasChevron, chevron = _chevron, toggleHandler = _toggleHandler;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:16.0]];
        [self.textLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
        
        _heart = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_heart setImage:[UIImage imageNamed:@"profile.icon.heart.png"]];
        [self.contentView addSubview:_heart];
        _hasHeart = NO;
        
        _chevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general.chevron.png"]];
        _hasChevron = NO;
    
        _toggleSwitch = [[GTIOSwitch alloc] initWithFrame:(CGRect){ 0, 0, 36, 17 }];
        [_toggleSwitch setTrack:[UIImage imageNamed:@"general.slider.green.rail.png"]];
        [_toggleSwitch setTrackFrame:[UIImage imageNamed:@"general.slider.green.bg.png"]];
        [_toggleSwitch setTrackFrameMask:[UIImage imageNamed:@"general.slider.green.mask.png"]];
        [_toggleSwitch setKnob:[UIImage imageNamed:@"general.slider.green.handle.png"]];
        [_toggleSwitch setKnobXOffset:-1.5];
        [_toggleSwitch setOn:NO];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.hasHeart) {
        [self.heart setFrame:(CGRect){ 36, 16, 15, 12 }];
    } else {
        [self.heart setFrame:CGRectZero];
    }
}

- (void)setToggleHandler:(GTIOSwitchChangeHandler)toggleHandler
{
    _toggleHandler = toggleHandler;
    [self.toggleSwitch setChangeHandler:_toggleHandler];
}

- (void)setHasChevron:(BOOL)hasChevron
{
    _hasChevron = hasChevron;
    [self refreshAccessoryView];
}

- (void)setHasToggle:(BOOL)hasToggle
{
    _hasToggle = hasToggle;
    [self refreshAccessoryView];
}

- (void)refreshAccessoryView
{
    if (self.hasToggle) {
        [self setAccessoryView:self.toggleSwitch];
    } else if (self.hasChevron) {
        [self setAccessoryView:self.chevron];
    } else {
        [self setAccessoryView:nil];
    }
}

@end
