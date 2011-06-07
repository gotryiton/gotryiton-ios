//
//  GTIOBarButtonItemSpec.m
//  GTIO
//
//  Created by Daniel Hammond on 5/16/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOBarButtonItem.h"
#import "UISpec.h"
#import "UIExpectation.h"

@interface GTIOBarButtonItemSpec : NSObject <UISpec> {}
@end

@implementation GTIOBarButtonItemSpec

- (void)itShouldInitWithTitleTargetAction {
	NSException* exception = nil;
	GTIOBarButtonItem* button = nil;
	@try {
		button = [[GTIOBarButtonItem alloc] initWithTitle:@"title" target:self action:@selector(act)];
	}
	@catch (NSException *e) {
		exception = e;
	}
	@finally {
		[expectThat(exception) should:be(nil)];
	}
}

- (void)itShouldInitWithTitleTargetActionBack {
	NSException* exception = nil;
	GTIOBarButtonItem* button = nil;
	@try {
		button = [[GTIOBarButtonItem alloc] initWithTitle:@"title" target:self action:@selector(act) backButton:YES];
	}
	@catch (NSException *e) {
		exception = e;
	}
	@finally {
		[expectThat(exception) should:be(nil)];
	}
}

- (void)itShouldInitWithImageTargetAction {
	NSException* exception = nil;
	GTIOBarButtonItem* button = nil;
	@try {
		button = [[GTIOBarButtonItem alloc] initWithImage:[[UIImage alloc] init] target:self action:@selector(act)];
	}
	@catch (NSException *e) {
		exception = e;
	}
	@finally {
		[expectThat(exception) should:be(nil)];
	}
}

- (void)itShouldCreateHomeButton {
	NSException* exception = nil;
	GTIOBarButtonItem* button = nil;
	@try {
		button = [GTIOBarButtonItem homeBackBarButtonWithTarget:nil action:nil];
	}
	@catch (NSException *e) {
		exception = e;
	}
	@finally {
		[expectThat(exception) should:be(nil)];
	}
}

@end
