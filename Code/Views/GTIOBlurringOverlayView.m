//
//  GTIOOverlayView.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/26/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOBlurringOverlayView.h"

@implementation GTIOBlurringOverlayView

@synthesize forwardTouchesToView = _forwardTouchesToView;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_forwardTouchesToView) {
		[_forwardTouchesToView touchesBegan:touches withEvent:event];
	} else {
		[super touchesBegan:touches withEvent:event];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_forwardTouchesToView) {
		[_forwardTouchesToView touchesMoved:touches withEvent:event];
	} else {
		[super touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_forwardTouchesToView) {
		[_forwardTouchesToView touchesEnded:touches withEvent:event];
	} else {
		[super touchesEnded:touches withEvent:event];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_forwardTouchesToView) {
		[_forwardTouchesToView touchesCancelled:touches withEvent:event];
	} else {
		[super touchesCancelled:touches withEvent:event];
	}
}

@end
