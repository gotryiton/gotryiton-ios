//
//  GTIOBannerAd.m
//  GTIO
//
//  Created by Jeremy Ellison on 6/14/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOBannerAd.h"


@implementation GTIOBannerAd

@synthesize width = _width, height = _height, clickUrl = _clickUrl, bannerImageUrlSmall = _bannerImageUrlSmall, bannerImageUrlLarge = _bannerImageUrlLarge;

- (void)dealloc {
    [_width release];
    [_height release];
    [_clickUrl release];
    [_bannerImageUrlLarge release];
    [_bannerImageUrlSmall release];
    [super dealloc];
}

@end
