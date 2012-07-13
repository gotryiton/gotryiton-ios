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

@synthesize facebookSwitch = _facebookSwitch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        GTIOConfig *currentConfig = [[GTIOConfigManager sharedManager] config];
        GTIOUser *currentUser = [GTIOUser currentUser];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toggle-fb-container.png"]];
        [self addSubview:backgroundView];
        
        self.facebookSwitch = [[GTIOSwitch alloc] initWithFrame:(CGRect){ 12, 24.5, 36, 17 }];
        [self.facebookSwitch setTrack:[UIImage imageNamed:@"general.slider.green.rail.png"]];
        [self.facebookSwitch setTrackFrame:[UIImage imageNamed:@"general.slider.green.bg.png"]];
        [self.facebookSwitch setTrackFrameMask:[UIImage imageNamed:@"general.slider.green.mask.png"]];
        [self.facebookSwitch setKnob:[UIImage imageNamed:@"general.slider.green.handle.png"]];
        [self.facebookSwitch setKnobXOffset:-2];
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
        [facebookButton setFrame:(CGRect){ 3, 3, backgroundView.frame.size.width - 6, backgroundView.frame.size.height - 6 }];
        [facebookButton addTarget:self.facebookSwitch action:@selector(handleExteriorTapGesture) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:facebookButton];
        [self bringSubviewToFront:self.facebookSwitch];
        
        [self setFrame:(CGRect){ self.frame.origin, backgroundView.frame.size }];
    }
    return self;
}

@end
