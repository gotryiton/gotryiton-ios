//
//  GTIOListSection.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOListSection.h"


@implementation GTIOListSection

@synthesize title = _title;
@synthesize stylists = _stylists;
@synthesize outfits = _outfits;

- (void)dealloc {
    [_title release];
    [_stylists release];
    [_outfits release];
    [super dealloc];
}

@end
