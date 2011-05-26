//
//  GTIOCategory.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/13/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOCategory.h"


@implementation GTIOCategory

@synthesize name = _name;
@synthesize apiEndpoint = _apiEndpoint;
@synthesize iconSmallURL = _iconSmallURL;
@synthesize iconLargeURL = _iconLargeURL;

- (void)dealloc {
    [_name release];
    [_apiEndpoint release];
    [_iconSmallURL release];
    [_iconLargeURL release];
    [super dealloc];
}

@end
