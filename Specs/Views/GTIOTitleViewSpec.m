//
//  GTIOTitleViewSpec.m
//  GTIO
//
//  Created by Daniel Hammond on 5/16/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISpec.h"
#import "UIExpectation.h"
#import "GTIOTitleView.h"

@interface GTIOTitleViewSpec : NSObject <UISpec> {}
@end

@implementation GTIOTitleViewSpec

- (void)itShouldInitWithTitle {
	NSException* exception = nil;
	GTIOTitleView* titleView = nil;
	@try {
		titleView = [GTIOTitleView title:@"test"];
	}
	@catch (NSException *e) {
		exception = e;
	}
	@finally {
		[expectThat(exception) should:be(nil)];
	}
	[expectThat(titleView.text) should:be(@"test")];
}

@end
