//
//  GTIOHeaderView.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOHeaderView.h"


@implementation GTIOHeaderView

+ (id)viewWithText:(NSString*)text {
	GTIOHeaderView* view = [[[GTIOHeaderView alloc] initWithFrame:CGRectZero] autorelease];
	view.text = text;
	view.textColor = [UIColor whiteColor];
	view.font = kGTIOFetteFontOfSize(24);
	view.backgroundColor = [UIColor clearColor];
	[view sizeToFit];
	return view;
}

- (void)drawTextInRect:(CGRect)rect {
	[super drawTextInRect:CGRectOffset(rect, 0, 2)];
}

@end
