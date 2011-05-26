//
//  GTIOGlobalVariableStore.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOGlobalVariableStore.h"


@implementation GTIOGlobalVariableStore

@synthesize changeItReasons = _changeItReasons;

static GTIOGlobalVariableStore* sharedStore = nil;

+ (GTIOGlobalVariableStore*)sharedStore {
	if (nil == sharedStore) {
		sharedStore = [GTIOGlobalVariableStore new];
	}
	return sharedStore;
}

- (void)dealloc {
	[_changeItReasons release];
	_changeItReasons = nil;

	[super dealloc];
}

@end
