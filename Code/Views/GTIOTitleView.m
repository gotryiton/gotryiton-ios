//
//  GTIOTitleView.m
//  GTIO
//
//  Created by Daniel Hammond on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOTitleView.h"


@implementation GTIOTitleView

+ (GTIOTitleView*)title:(NSString*)title {
	self = [[super new] autorelease];
	[self setText:title];
	[self setBackgroundColor:[UIColor clearColor]];
	[self setTextAlignment:UITextAlignmentCenter];
	[self setTextColor:[UIColor whiteColor]];
	UIFont* font = [UIFont fontWithName:@"Fette Engschrift" size:25];
	[self setFrame:CGRectMake(0,0,[title sizeWithFont:font].width,30)];
	[self setFont:font];
	[self setShadowOffset:CGSizeMake(0, -1)];
	[self setShadowColor:[UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1.0]];
	return self;
}

@end
