//
//  TTTableControlItemCell_Additions.m
//  Milo iPhone App
//
//  Created by Jeremy Ellison on 7/20/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "TTTableCell_Additions.h"
#import <Three20UI/Three20UI+Additions.h>

@interface TTTableControlCell ()
+ (BOOL)shouldSizeControlToFit:(UIControl*)control;
@end

static const CGFloat kControlPadding = 8;

@implementation TTTableControlCell (Additions)

+ (BOOL)shouldRespectControlPadding:(UIView*)view {
	// This fixes the alignment of text controlls in grouped tables.
	return NO;
}

+ (BOOL)shouldConsiderControlIntrinsicSize:(UIView*)view {
	if ([view isKindOfClass:[UISwitch class]] ||
		[view isKindOfClass:NSClassFromString(@"TWTPickerControl")] ||
		[view isKindOfClass:NSClassFromString(@"CustomUISwitch")]) {
		return YES;
	}
	return NO;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	if ([TTTableControlCell shouldSizeControlToFit:_control]) {
		_control.frame = CGRectInset(self.contentView.bounds, 2, kTableCellSpacing / 2);
		self.textLabel.height = 30;
		_control.frame = CGRectMake(_control.frame.origin.x, _control.frame.origin.y + 30, _control.frame.size.width, _control.frame.size.height - 30);
	} else {
		CGFloat minX = kControlPadding;
		CGFloat contentWidth = self.contentView.width - kControlPadding;
		if (![TTTableControlCell shouldRespectControlPadding:_control]) {
			contentWidth -= kControlPadding;
		}
		if (self.textLabel.text.length) {
			CGSize textSize = [self.textLabel sizeThatFits:self.contentView.bounds.size];
			contentWidth -= textSize.width + kTableCellSpacing;
			minX += textSize.width + kTableCellSpacing;
		}
		
		if (!_control.height) {
			[_control sizeToFit];
		}
		
		if ([TTTableControlCell shouldConsiderControlIntrinsicSize:_control]) {
			minX += contentWidth - _control.width;
		}
		
		// XXXjoe For some reason I need to re-add the control as a subview or else
		// the re-use of the cell will cause the control to fail to paint itself on occasion
		[self.contentView addSubview:_control];
		
		if ([_control isKindOfClass:NSClassFromString(@"TWTPickerControl")]) {
			// Sizing these specially prevents them from jumping around.
			_control.frame = CGRectMake(self.contentView.width - _control.width - kTableCellSpacing, floor(self.contentView.height/2 - _control.height/2), _control.width, _control.height);
		} else {
			_control.frame = CGRectMake(minX, floor(self.contentView.height/2 - _control.height/2),
										contentWidth, _control.height);
		}
	}
	if ([_control isKindOfClass:NSClassFromString(@"TTTextEditor")]) {
		_control.frame = CGRectOffset(_control.frame, 0, -20);
	}
	
	self.textLabel.textColor = [UIColor grayColor];
	self.textLabel.font = [UIFont boldSystemFontOfSize:14];
}

@end
