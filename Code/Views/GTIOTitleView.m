//
//  GTIOTitleView.m
//  GTIO
//
//  Created by Daniel Hammond on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOTitleView.h"


@implementation GTIOTitleView

+(GTIOTitleView*)title:(NSString*)title {
	GTIOTitleView* titleView = [[[UILabel alloc] init] autorelease];
    if (titleView) {
        [titleView setText:title];
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setTextAlignment:UITextAlignmentCenter];
        [titleView setTextColor:[UIColor whiteColor]];
        [titleView setFrame:CGRectMake(0,0,[title sizeWithFont:kGTIOFetteFontOfSize(25)].width,30)];
        [titleView setFont:kGTIOFetteFontOfSize(25)];
        [titleView setShadowOffset:CGSizeMake(0, -1)];
        [titleView setShadowColor:kGTIOColor888888];
    }
	return titleView;
}

@end
