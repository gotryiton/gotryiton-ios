//
//  GTIOPostALookOptionsView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostALookOptionsView.h"
#import "GTIOConfig.h"
#import "GTIOConfigManager.h"
#import "GTIOUser.h"

@implementation GTIOPostALookOptionsView

@synthesize votingSwitch = _votingSwitch, facebookSwitch = _facebookSwitch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        GTIOConfig *currentConfig = [[GTIOConfigManager sharedManager] config];
        GTIOUser *currentUser = [GTIOUser currentUser];
        
        UIImage *backgroundImage = [UIImage imageNamed:@"toggle-containers.png"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:(CGRect){ 0, 0, backgroundImage.size }];
        [backgroundView setImage:backgroundImage];
        [self addSubview:backgroundView];
        
        self.votingSwitch = [[GTIOSwitch alloc] initWithFrame:(CGRect){ 12, 55, 36, 17 }];
        [self.votingSwitch setTrack:[UIImage imageNamed:@"general.slider.green.rail.png"]];
        [self.votingSwitch setTrackFrame:[UIImage imageNamed:@"general.slider.green.bg.png"]];
        [self.votingSwitch setTrackFrameMask:[UIImage imageNamed:@"general.slider.green.mask.png"]];
        [self.votingSwitch setKnob:[UIImage imageNamed:@"general.slider.green.handle.png"]];
        [self.votingSwitch setKnobXOffset:-1.5];
        [self.votingSwitch setChangeHandler:^(BOOL on) {
            // stuff
        }];
        [self.votingSwitch setOn:[currentConfig.votingDefaultOn boolValue]];
        [self addSubview:self.votingSwitch];
        
        UIButton *votingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [votingButton setFrame:(CGRect){ 3, 33, backgroundView.frame.size.width - 6, 47 }];
        [votingButton addTarget:self.votingSwitch action:@selector(handleExteriorTapGesture) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:votingButton];
        [self bringSubviewToFront:self.votingSwitch];
        
        self.facebookSwitch = [[GTIOSwitch alloc] initWithFrame:(CGRect){ 12, 113, 36, 17 }];
        [self.facebookSwitch setTrack:[UIImage imageNamed:@"general.slider.green.rail.png"]];
        [self.facebookSwitch setTrackFrame:[UIImage imageNamed:@"general.slider.green.bg.png"]];
        [self.facebookSwitch setTrackFrameMask:[UIImage imageNamed:@"general.slider.green.mask.png"]];
        [self.facebookSwitch setKnob:[UIImage imageNamed:@"general.slider.green.handle.png"]];
        [self.facebookSwitch setKnobXOffset:-1.5];
        [self.facebookSwitch setOn:[currentConfig.facebookShareDefaultOn boolValue]];
        [self.facebookSwitch setChangeHandler:^(BOOL on) {
            if (on && !currentUser.isFacebookConnected) {
                [currentUser connectToFacebookWithLoginHandler:^(GTIOUser *user, NSError *error) {
                    if (!user.isFacebookConnected) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"We were unable to connect you with facebook." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [self.facebookSwitch setOn:NO];
                    }
                }];
            }
        }];        
        [self addSubview:self.facebookSwitch];
        
        UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [facebookButton setFrame:(CGRect){ 3, 90, backgroundView.frame.size.width - 6, 48 }];
        [facebookButton addTarget:self.facebookSwitch action:@selector(handleExteriorTapGesture) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:facebookButton];
        [self bringSubviewToFront:self.facebookSwitch];
    }
    return self;
}

@end
