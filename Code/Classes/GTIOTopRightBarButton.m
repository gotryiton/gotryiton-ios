//
//  GTIOTopRightBarButton.m
//  GTIO
//
//  Created by Jeremy Ellison on 6/15/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOTopRightBarButton.h"


@implementation GTIOTopRightBarButton

@synthesize text = _text, url = _url;

- (void)dealloc {
    [_text release];
    [_url release];
    [super dealloc];
}

@end
