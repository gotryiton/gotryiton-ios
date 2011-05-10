//
//  GTIOAppStatusAlertButton.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOAppStatusAlertButton.h"


@implementation GTIOAppStatusAlertButton

@synthesize title = _title;
@synthesize url = _url;

- (void)dealloc {
	[_title release];
	_title = nil;
	[_url release];
	_url = nil;

	[super dealloc];
}

+ (NSDictionary*)elementToPropertyMappings {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"title", @"title",
			@"url", @"url",
			nil];
}

@end
