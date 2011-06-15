//
//  GTIOExtraProfileRow.m
//  GTIO
//
//  Created by Jeremy Ellison on 6/15/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOExtraProfileRow.h"


@implementation GTIOExtraProfileRow

@synthesize text = _text, api = _api;

- (void)dealloc {
    [_text release];
    [_api release];
    [super dealloc];
}

@end
