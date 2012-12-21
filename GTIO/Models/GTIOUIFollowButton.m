//
//  GTIOFollowingButton.m
//  GTIO
//
//  Created by Simon Holroyd on 12/5/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUIFollowButton.h"


@interface GTIOUIFollowButton()

@property (nonatomic, strong) UIImage *follow_button_off;
@property (nonatomic, strong) UIImage *follow_button_on;

@property (nonatomic, strong) UIImage *following_button_off;
@property (nonatomic, strong) UIImage *following_button_on;

@property (nonatomic, strong) UIImage *requested_button_off;
@property (nonatomic, strong) UIImage *requested_button_on;

@end

@implementation GTIOUIFollowButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _follow_button_off = [UIImage imageNamed:@"follow-OFF.png"];
        _follow_button_on = [UIImage imageNamed:@"follow-OFF.png"];

        _following_button_on = [UIImage imageNamed:@"following-OFF.png"];
        _following_button_off = [UIImage imageNamed:@"following-OFF.png"];

        _requested_button_on = [UIImage imageNamed:@"requested-OFF.png"];
        _requested_button_off = [UIImage imageNamed:@"requested-OFF.png"];

        
        [self.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self addTarget:self action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setFollowState:GTIOUIFollowButtonStateFollow];

    }
    return self;
}


+ (id)initFollowButton
{
    GTIOUIFollowButton *button = [GTIOUIFollowButton buttonWithType:UIButtonTypeCustom];
    return button;
}

- (void)setFollowState:(GTIOUIFollowButtonState)state
{
    [self setFrame:(CGRect){ 0, 0, self.follow_button_off.size }];
    [self.titleLabel setFrame:(CGRect){ 0, 0, self.follow_button_off.size }];
    switch (state){
        case GTIOUIFollowButtonStateFollow:
            [self setBackgroundImage:self.follow_button_off forState:UIControlStateNormal];
            [self setBackgroundImage:self.follow_button_on forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor gtio_grayTextColor515152] forState:UIControlStateNormal];
            [self setTitle:@"follow" forState:UIControlStateNormal];
            [self setTitleLabelText:@"follow"];
        break;
        case GTIOUIFollowButtonStateFollowing:
            [self setBackgroundImage:self.following_button_off forState:UIControlStateNormal];
            [self setBackgroundImage:self.following_button_on forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor gtio_grayTextColor515152] forState:UIControlStateNormal];
            [self setTitle:@"following" forState:UIControlStateNormal];
            [self setTitleLabelText:@"following"];
        break;
        case GTIOUIFollowButtonStateRequested:
            [self setBackgroundImage:self.requested_button_off forState:UIControlStateNormal];
            [self setBackgroundImage:self.requested_button_on forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor gtio_grayTextColor515152] forState:UIControlStateNormal];
            [self setTitle:@"requested" forState:UIControlStateNormal];
            [self setTitleLabelText:@"requested"];
        break;
    }

}

@end
