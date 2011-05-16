//
//  GTIOTitleViewSpec.m
//  GTIO
//
//  Created by Daniel Hammond on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISpec.h"
#import "UIExpectation.h"
#import "GTIOTitleView.h"

@interface GTIOTitleViewSpec : NSObject <UISpec> {
	
}

@end

@implementation GTIOTitleViewSpec

- (void)itInitWithTitle {
	GTIOTitleView* titleView = [GTIOTitleView title:@"test"];
	[expectThat(titleView.text) should:be(@"asdf")];
}

@end
