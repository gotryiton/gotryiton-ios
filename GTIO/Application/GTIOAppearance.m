//
//  GTIOAppearance.m
//  GTIO
//
//  Created by Scott Penrose on 5/10/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOAppearance.h"
#import "GTIOAlmostDoneViewController.h"
#import "GTIOEditProfilePictureViewController.h"

@implementation GTIOAppearance

+ (void)setupAppearance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // UITabBar
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"UI-Tab-BG.png"]];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"ui.empty.pixel.png"]];
    });
}

@end
