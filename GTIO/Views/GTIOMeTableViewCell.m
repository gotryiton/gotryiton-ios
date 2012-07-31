//
//  GTIOMeTableViewCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMeTableViewCell.h"
#import "UIColor+GTIOAdditions.h"

@interface GTIOMeTableViewCell()

@property (nonatomic, strong) UIImageView *heart;
@property (nonatomic, strong) GTIOSwitch *toggleSwitch;
@property (nonatomic, strong) UIImageView *chevron;

@end

@implementation GTIOMeTableViewCell

@synthesize heart = _heart, hasHeart = _hasHeart, hasToggle = _hasToggle, toggleSwitch = _toggleSwitch, hasChevron = _hasChevron, chevron = _chevron, indexPath = _indexPath, toggleDelegate = _toggleDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
               
        [self.textLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:16.0]];
        [self.textLabel setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        
        _heart = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_heart setImage:[UIImage imageNamed:@"profile.icon.heart.png"]];
        [self.contentView addSubview:_heart];
        
        _chevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general.chevron.png"]];
    
        UIImage * toggleBackground = [UIImage imageNamed:@"management.slider.bg.png"];
        _toggleSwitch = [[GTIOSwitch alloc] initWithFrame:(CGRect){ 0, 0, toggleBackground.size }];
        [_toggleSwitch setTrack:[UIImage imageNamed:@"management.slider.rail.png"]];
        [_toggleSwitch setTrackFrame:toggleBackground];
        [_toggleSwitch setTrackFrameMask:[UIImage imageNamed:@"management.slider.mask.png"]];
        [_toggleSwitch setKnob:[UIImage imageNamed:@"management.slider.handle.png"]];
        [_toggleSwitch setKnobXOffset:-2];
        [_toggleSwitch setKnobYOffset:1];
        [_toggleSwitch setOn:NO];

        __block typeof(self) blockSelf = self;
        [_toggleSwitch setChangeHandler:^(BOOL on) {
            if (blockSelf.indexPath) {
                if ([blockSelf.toggleDelegate respondsToSelector:@selector(updateSwitchAtIndexPath:)]) {
                    [blockSelf.toggleDelegate updateSwitchAtIndexPath:self.indexPath];
                }
            }
        }];        
        
    }
    return self;
}

- (void)prepareForReuse
{
    self.hasToggle = NO;
    self.hasHeart = NO;
    self.hasChevron = NO;
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

- (void)toggleSwitchChanged:(id)sender
{
    if (self.indexPath) {
        if ([self.toggleDelegate respondsToSelector:@selector(updateSwitchAtIndexPath:)]) {
            [self.toggleDelegate updateSwitchAtIndexPath:self.indexPath];
        }
    }
}

- (void)setToggleState:(BOOL)on
{
    [self.toggleSwitch setOn:on sendActions:NO];
}

- (void)setHasChevron:(BOOL)hasChevron
{
    _hasChevron = hasChevron;
    [self refreshAccessoryView];
}

- (void)setHasToggle:(BOOL)hasToggle
{
    _hasToggle = hasToggle;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
