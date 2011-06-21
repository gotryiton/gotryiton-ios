//
//  GTIOStylistsQuickLook.m
//  GTIO
//
//  Created by Jeremy Ellison on 6/20/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOStylistsQuickLook.h"


@implementation GTIOStylistsQuickLook

@synthesize thumbs = _thumbs, text = _text;

- (void)dealloc {
    [_thumbs release];
    [_text release];
    [super dealloc];
}

@end
