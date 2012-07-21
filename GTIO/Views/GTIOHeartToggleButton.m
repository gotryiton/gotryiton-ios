//
//  GTIOHeartToggleButton.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/18/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOHeartToggleButton.h"

@interface GTIOHeartToggleButton()

@property (nonatomic, strong) UIImage *heartToggleOffInactive;
@property (nonatomic, strong) UIImage *heartToggleOffActive;
@property (nonatomic, strong) UIImage *heartToggleOnInactive;
@property (nonatomic, strong) UIImage *heartToggleOnActive;

@end

@implementation GTIOHeartToggleButton

@synthesize heartToggleOnActive = _heartToggleOnActive, heartToggleOffActive = _heartToggleOffActive, heartToggleOnInactive = _heartToggleOnInactive, heartToggleOffInactive = _heartToggleOffInactive;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _heartToggleOffInactive = [UIImage imageNamed:@"heart-toggle-off-inactive.png"];
        _heartToggleOffActive = [UIImage imageNamed:@"heart-toggle-off-active.png"];
        _heartToggleOnInactive = [UIImage imageNamed:@"heart-toggle-on-inactive.png"];
        _heartToggleOnActive = [UIImage imageNamed:@"heart-toggle-on-active.png"];
        
        [self setSelected:NO];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        [self setImage:_heartToggleOnInactive forState:UIControlStateNormal];
        [self setImage:_heartToggleOnActive forState:UIControlStateHighlighted];
    } else {
        [self setImage:_heartToggleOffInactive forState:UIControlStateNormal];
        [self setImage:_heartToggleOffActive forState:UIControlStateHighlighted];        
    }
}

@end
