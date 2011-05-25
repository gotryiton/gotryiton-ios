//
//  GTIOStaticOutfitListModel.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/25/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOStaticOutfitListModel.h"


@implementation GTIOStaticOutfitListModel

@synthesize objects = _outfits;

- (id)initWithOutfits:(NSArray*)outfits {
    if ((self = [super init])) {
        _outfits = [outfits retain];
    }
    return self;
}

+ (id)modelWithOutfits:(NSArray*)outfits {
    return [[[self alloc] initWithOutfits:outfits] autorelease];
}

- (void)dealloc {
    [_outfits release];
    [super dealloc];
}

@end
