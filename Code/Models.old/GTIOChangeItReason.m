//
//  GTIOChangeItReason.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOChangeItReason.h"


@implementation GTIOChangeItReason

@synthesize reasonID = _reasonID;
@synthesize display = _display;
@synthesize text = _text;

- (void)dealloc {
	[_text release];
	[_reasonID release];
	[_display release];

	[super dealloc];
}

+ (NSDictionary*)elementToPropertyMappings {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"reasonID", @"id",
			@"display", @"display",
			@"text", @"text",
			nil];
}

- (NSString*)description {
	return [NSString stringWithFormat:@"<GTIOChangeItReason: id: %d text: '%@' display: %d>", _reasonID, _text, _display];
}

@end
