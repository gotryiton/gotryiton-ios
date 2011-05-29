//
//  GTIODraggableImageView.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/25/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIODraggableImageView.h"

@implementation GTIODraggableImageView

@synthesize delegate = _delegate;
@synthesize constrainingRect = _constrainingRect;

/// Initialize with an image
- (id)initWithImage:(UIImage*)image {
	if (self = [super initWithImage:image]) {
		_oldPoint = CGPointMake(-1, -1);
		_oldDistance = -1;
		self.clipsToBounds = YES;
		self.layer.borderWidth = 3;
		self.layer.borderColor = TTSTYLEVAR(pinkColor).CGColor;
		_touches = [NSMutableArray new];
	}
	return self;
}

- (void)dealloc {
	_delegate = nil;
	[_touches release];
	[super dealloc];
}

- (void)updateImage {
	if ([_delegate respondsToSelector:@selector(imageForDraggableImageView:)]) {
		self.image = [_delegate imageForDraggableImageView:self];
		[self setNeedsDisplay];
	}	
}

- (void)updateImageWhenCounterHitsZero {
	_counter--;
	if (0 == _counter) {
		[self updateImage];
	}
}

- (void)setDelegate:(id)delegate {
	_delegate = delegate;
	[self updateImage];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[_touches addObjectsFromArray:[touches allObjects]];
	if ([_touches count] == 2) {
		UITouch* firstTouch = [_touches objectAtIndex:0];
		UITouch* secondTouch = [_touches objectAtIndex:1];
		CGPoint point1 = [firstTouch locationInView:firstTouch.view];
		CGPoint point2 = [secondTouch locationInView:secondTouch.view];
		
		float a = point1.x - point2.x;
		float b = point1.y - point2.y;
		
		_oldDistance = sqrt(a*a + b*b);
	} else if ([_touches count] == 1) {
		UITouch* touch = (UITouch*)[_touches objectAtIndex:0];
		_oldPoint = [touch locationInView:touch.view];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([_touches count] == 1) {
		UITouch* newTouch = [_touches objectAtIndex:0];
		CGPoint newPoint = [newTouch locationInView:newTouch.view];
		
		float dx = newPoint.x - _oldPoint.x;
		float dy = newPoint.y - _oldPoint.y;
		_oldPoint = newPoint;
		if (ABS(dx) + ABS(dy) > 50) {
			// Huge drag, ignore. May be the artifact of another touch.
			return;
		}
		
		CGRect newFrame = CGRectOffset(self.frame, dx, dy);
		
		newFrame.origin.x = MAX(newFrame.origin.x, -(newFrame.size.width / 2));
		newFrame.origin.y = MAX(newFrame.origin.y, -(newFrame.size.height / 2));
		newFrame.origin.y = MIN(newFrame.origin.y, _constrainingRect.size.height - (newFrame.size.height / 2));
		newFrame.origin.x = MIN(newFrame.origin.x, _constrainingRect.size.width - (newFrame.size.width / 2));
		
		self.frame = newFrame;
	} else if ([_touches count] == 2) {
		// DRAG
		UITouch* firstTouch = [_touches objectAtIndex:0];
		UITouch* secondTouch = [_touches objectAtIndex:1];
		CGPoint point1 = [firstTouch locationInView:firstTouch.view];
		CGPoint point2 = [secondTouch locationInView:secondTouch.view];
		
		float a = point1.x - point2.x;
		float b = point1.y - point2.y;
		
		float newDistance = sqrt(a*a + b*b);
		
		float deltaDistance = newDistance - _oldDistance;
		
		float maxDiameter = 150.0;
		float minDiameter = 15.0;
		deltaDistance = (deltaDistance - ABS(MIN(maxDiameter - (self.frame.size.height + deltaDistance), 0)));
		if ((self.frame.size.height + deltaDistance) < minDiameter) {
			deltaDistance = minDiameter - self.frame.size.height;
		}
		
		if (self.frame.size.width + deltaDistance <= _constrainingRect.size.width &&
			self.frame.size.height + deltaDistance <= _constrainingRect.size.height) {
			CGRect newFrame = CGRectMake(self.frame.origin.x - (deltaDistance/2), 
										 self.frame.origin.y - (deltaDistance/2), 
										 MIN(self.frame.size.width + deltaDistance, _constrainingRect.size.width), 
										 MIN(self.frame.size.height + deltaDistance, _constrainingRect.size.height));
			newFrame.origin.x = MAX(newFrame.origin.x, _constrainingRect.origin.x);
			newFrame.origin.y = MAX(newFrame.origin.y, _constrainingRect.origin.y);
			
			self.frame = newFrame;
			
			self.layer.cornerRadius = newFrame.size.width / 2;
		}
		_oldDistance = newDistance;
	}
	
	_counter++;
	[self performSelector:@selector(updateImageWhenCounterHitsZero) withObject:nil afterDelay:0.0];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[_touches removeObjectsInArray:[touches allObjects]];
	if ([_touches count] <= 1) {
		_oldDistance = -1;
	}
	if ([touches count] == 0) {
		_oldPoint = CGPointMake(-1, -1);
	}
	[self updateImage];
}

@end
