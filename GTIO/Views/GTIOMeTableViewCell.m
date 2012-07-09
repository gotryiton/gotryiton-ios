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
@property (nonatomic, strong) UISwitch *toggleSwitch;
@property (nonatomic, strong) UIImageView *chevron;

@end

@implementation GTIOMeTableViewCell

@synthesize heart = _heart, hasHeart = _hasHeart, hasToggle = _hasToggle, toggleSwitch = _toggleSwitch, hasChevron = _hasChevron, chevron = _chevron, indexPath = _indexPath, toggleDelegate = _toggleDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.textLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:16.0]];
        [self.textLabel setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        
        _heart = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_heart setImage:[UIImage imageNamed:@"profile.icon.heart.png"]];
        [self.contentView addSubview:_heart];
        
        _chevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general.chevron.png"]];
    
        _toggleSwitch = [[UISwitch alloc] initWithFrame:(CGRect){ 0, 0, 36, 17 }];
        [_toggleSwitch addTarget:self action:@selector(toggleSwitchChanged:) forControlEvents:UIControlEventValueChanged];
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
    [self.toggleSwitch setOn:on];
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
