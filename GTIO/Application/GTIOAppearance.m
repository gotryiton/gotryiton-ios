//
//  GTIOAppearance.m
//  GTIO
//
//  Created by Scott Penrose on 5/10/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOAppearance.h"

@implementation GTIOAppearance

- (id)init
{
    self = [super init];
    if (self) {
        
        // UITabBar
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"UI-Tab-BG.png"]];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"ui.empty.pixel.png"]];
        
    }
    return self;
}

@end
