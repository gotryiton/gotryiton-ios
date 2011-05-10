//
//  GTIOBlurringToolbarView.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/23/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOBlurringToolbarView.h"

@implementation GTIOBlurringToolbarView

@synthesize keepButton = _keepButton;
@synthesize removeButton = _removeButton;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		UIImageView* backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blur-bg.png"]] autorelease];
		[self addSubview:backgroundView];
		
		_keepButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_keepButton setImage:[UIImage imageNamed:@"blur-keep.png"] forState:UIControlStateNormal];		
		[_keepButton sizeToFit];
		_keepButton.frame = CGRectOffset(_keepButton.frame, self.width - ((_keepButton.frame.size.width + 7)*2), 8);
		[self addSubview:_keepButton];
		
		_removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_removeButton setImage:[UIImage imageNamed:@"blur-remove.png"] forState:UIControlStateNormal];
		[_removeButton sizeToFit];
		_removeButton.frame = CGRectOffset(_removeButton.frame, self.width - (_removeButton.frame.size.width + 7), 8);
		[self addSubview:_removeButton];
	}
	
	return self;
}

@end
