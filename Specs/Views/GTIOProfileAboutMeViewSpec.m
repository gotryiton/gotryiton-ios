//
//  GTIOProfileAboutMeViewSpec.m
//  GTIO
//
//  Created by Daniel Hammond on 5/16/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISpec.h"
#import "UIExpectation.h"
#import "GTIOProfileAboutMeView.h"

@interface GTIOProfileAboutMeViewSpec : NSObject <UISpec> {}
@end

@implementation GTIOProfileAboutMeViewSpec

- (void)itShouldCalculateSizeCorrectly {
	GTIOProfileAboutMeView* aboutMeView = [[GTIOProfileAboutMeView new] autorelease];
	CGSize max = CGSizeMake(320,1000);
	CGSize smallTextSize = CGSizeMake(320,34);
	CGSize largerTextSize = CGSizeMake(320,50);
	[aboutMeView setText:@"Short Test String"];
	[expectThat([aboutMeView sizeThatFits:max]) should:be(smallTextSize)];
	[aboutMeView setText:@"Much longer test string that will wrap most likely"];
	[expectThat([aboutMeView sizeThatFits:max]) should:be(largerTextSize)];	
}

- (void)itShouldDraw {
	NSException* exception = nil;
	GTIOProfileAboutMeView* aboutMeView = [[GTIOProfileAboutMeView new] autorelease];
	[aboutMeView setText:@"text"];
	@try {
		CGSize size = [aboutMeView sizeThatFits:CGSizeMake(320,1000)];
		[aboutMeView drawRect:CGRectMake(0,0,size.width,size.height)];
	}
	@catch (NSException *e) {
		exception = e;
	}
	@finally {
		[expectThat(exception) should:be(nil)];
	}

}

@end
