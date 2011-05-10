//
//  GTIOTableImageControlCell.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/7/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOTableImageControlCell.h"
#import "GTIOTableImageControlItem.h"

@implementation GTIOTableImageControlCell

- (void)layoutSubviews {
	[super layoutSubviews];
	
	if (![_control isKindOfClass:[UISwitch class]] &&
		![_control isKindOfClass:NSClassFromString(@"CustomUISwitch")]) {
		self.textLabel.frame = CGRectOffset(self.textLabel.frame, -10, 0);
		
		_control.frame = CGRectMake(_control.frame.origin.x + self.imageView.width - 10, _control.frame.origin.y,
									_control.frame.size.width - self.imageView.size.width + 10, _control.frame.size.height);

	}
	
	GTIOTableImageControlItem* item = (GTIOTableImageControlItem*)_item;
	if (item.shouldInsetImage) {
		self.imageView.frame = CGRectInset(self.imageView.frame, 10, 10);
	}
}

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		GTIOTableImageControlItem* item = object;
		self.imageView.image = item.image;
	}
}

@end
