//
//  GTIOPostALookOptionsView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostALookOptionsView.h"
#import "GTIOSwitch.h"

@interface GTIOPostALookOptionsView()

@end

@implementation GTIOPostALookOptionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"toggle-containers.png"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:(CGRect){ 0, 0, backgroundImage.size }];
        [backgroundView setImage:backgroundImage];
        [self addSubview:backgroundView];
        
        GTIOSwitch *votingSwitch = [[GTIOSwitch alloc] initWithFrame:(CGRect){ 12, 55, 36, 17 }];
        [votingSwitch setTrack:[UIImage imageNamed:@"general.slider.green.rail.png"]];
        [votingSwitch setTrackFrame:[UIImage imageNamed:@"general.slider.green.bg.png"]];
        [votingSwitch setTrackFrameMask:[UIImage imageNamed:@"general.slider.green.mask.png"]];
        [votingSwitch setKnob:[UIImage imageNamed:@"general.slider.green.handle.png"]];
        [votingSwitch setKnobXOffset:-1.5];
        [votingSwitch setChangeHandler:^(BOOL on) {
            // stuff
        }];
        [self addSubview:votingSwitch];
        
        GTIOSwitch *facebookSwitch = [[GTIOSwitch alloc] initWithFrame:(CGRect){ 12, 113, 36, 17 }];
        [facebookSwitch setTrack:[UIImage imageNamed:@"general.slider.green.rail.png"]];
        [facebookSwitch setTrackFrame:[UIImage imageNamed:@"general.slider.green.bg.png"]];
        [facebookSwitch setTrackFrameMask:[UIImage imageNamed:@"general.slider.green.mask.png"]];
        [facebookSwitch setKnob:[UIImage imageNamed:@"general.slider.green.handle.png"]];
        [facebookSwitch setKnobXOffset:-1.5];
        [facebookSwitch setChangeHandler:^(BOOL on) {
            // stuff
        }];
        [self addSubview:facebookSwitch];
    }
    return self;
}

@end
