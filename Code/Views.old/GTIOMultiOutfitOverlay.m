//
//  GTIOMultiOutfitOverlay.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/26/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOMultiOutfitOverlay.h"

@interface GTIOMultiOutfitOverlay (Private)

- (CGRect)expandedFrameForPhotoAtIndex:(NSInteger)index includeBorder:(BOOL)includeBorder;
- (CGRect)colapsedFrameForPhotoAtIndex:(NSInteger)index includeBorder:(BOOL)includeBorder;

@end


@implementation GTIOMultiOutfitOverlay

@synthesize outfit = _outfit;
@synthesize expandedFrame = _expandedFrame;
@synthesize collapsedFrame = _collapsedFrame;
@synthesize lookIndex = _lookIndex;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.clipsToBounds = YES;
		_expandedFrame = frame;
		_collapsedFrame = CGRectZero;
		
		_selectionView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_selectionView.backgroundColor = [UIColor clearColor];
		_selectionView.image = [UIImage imageNamed:@"selection-border.png"];
		[self addSubview:_selectionView];
		
		_look1 = [[TTImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:_look1];
		_look2 = [[TTImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:_look2];
		_look3 = [[TTImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:_look3];
		_look4 = [[TTImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:_look4];
        
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textColor = [UIColor whiteColor];
		_textLabel.numberOfLines = 2;
		_textLabel.textAlignment = UITextAlignmentCenter;
		_textLabel.font = kGTIOFontHelveticaRBCOfSize(18);
		[self addSubview:_textLabel];
	}
	return self;
}

- (void)dealloc {
	[_selectionView release];
	_selectionView = nil;
	[_outfit release];
	_outfit = nil;
	
	[_textLabel release];
	_textLabel = nil;
	
	[_look1 release];
	_look1 = nil;
	
	[_look2 release];
	_look2 = nil;
	
	[_look3 release];
	_look3 = nil;
	
	[_look4 release];
	_look4 = nil;
    
    [_zoomOutTimer invalidate];
    [_zoomOutTimer release];
    _zoomOutTimer = nil;

	[super dealloc];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	if (CGRectEqualToRect(frame, _expandedFrame)) {
		_selectionView.frame = [self expandedFrameForPhotoAtIndex:_lookIndex includeBorder:YES];
		_look1.frame = [self expandedFrameForPhotoAtIndex:0 includeBorder:NO];
		_look2.frame = [self expandedFrameForPhotoAtIndex:1 includeBorder:NO];
		_look3.frame = [self expandedFrameForPhotoAtIndex:2 includeBorder:NO];
		_look4.frame = [self expandedFrameForPhotoAtIndex:3 includeBorder:NO];
		float bottomAlignment = _selectionView.frame.origin.y;
		_textLabel.frame = CGRectMake(0, bottomAlignment - 50, self.width, 50);
		self.backgroundColor = RGBACOLOR(0,0,0,0.3);
	} else if (CGRectEqualToRect(frame, _collapsedFrame)) {
		_textLabel.frame = CGRectZero;
		_selectionView.frame = [self colapsedFrameForPhotoAtIndex:_lookIndex includeBorder:YES];
		_look1.frame = [self colapsedFrameForPhotoAtIndex:0 includeBorder:NO];
		_look2.frame = [self colapsedFrameForPhotoAtIndex:1 includeBorder:NO];
		_look3.frame = [self colapsedFrameForPhotoAtIndex:2 includeBorder:NO];
		_look4.frame = [self colapsedFrameForPhotoAtIndex:3 includeBorder:NO];
		self.backgroundColor = [UIColor clearColor];
	}
}

- (CGRect)colapsedFrameForPhotoAtIndex:(NSInteger)index includeBorder:(BOOL)includeBorder {
	if (index >= [_outfit.photos count] || [_outfit.photos count] == 0) {
		return CGRectZero;
	}
	float leftPadding = 5;
	float padding = 3;
	float widthPerFrame = 20;
	
	CGRect borderRect = CGRectMake(leftPadding + (widthPerFrame * index) + (padding * index),
								   5,
								   widthPerFrame,
								   widthPerFrame*1.3);
	if (includeBorder) {
		return borderRect;
	}
	return CGRectInset(borderRect, 1, 1);
}

- (CGRect)expandedFrameForPhotoAtIndex:(NSInteger)index includeBorder:(BOOL)includeBorder {
	if (index >= [_outfit.photos count] || [_outfit.photos count] == 0) {
		return CGRectZero;
	}
	float paddingOnEitherSide = 50;
	float padding = 10;
	float widthPerFrame = (320 - (2*paddingOnEitherSide) - padding*[_outfit.photos count]) / [_outfit.photos count];
	
	float heightPerFrame = widthPerFrame*1.3;
	float topPosition = floor((self.height - heightPerFrame) / 2);
	
	CGRect borderRect = CGRectMake(paddingOnEitherSide + (widthPerFrame * index) + (padding * index),
					    topPosition,
					    widthPerFrame,
					    heightPerFrame);
	if (includeBorder) {
		return borderRect;
	}
	return CGRectInset(borderRect, 3, 3);
}

- (void)setOutfitWithoutResettingOverlay:(GTIOOutfit *)outfit {
	[outfit retain];
	[_outfit release];
	_outfit = outfit;
	
	_textLabel.text = [NSString stringWithFormat:@"%@ needs to decide\nbetween these outfits!", outfit.firstName];
}

- (void)setOutfit:(GTIOOutfit *)outfit {
	[self setOutfitWithoutResettingOverlay:outfit];
	
	_lookIndex = 0;
	_look1.urlPath = [[[_outfit photos] objectAtIndex:0] valueForKey:@"multiThumb"];
	if ([_outfit.photos count] > 1) {
		_look2.urlPath = [[[_outfit photos] objectAtIndex:1] valueForKey:@"multiThumb"];
		if ([_outfit.photos count] > 2) {
			_look3.urlPath = [[[_outfit photos] objectAtIndex:2] valueForKey:@"multiThumb"];
			if ([_outfit.photos count] > 3) {
				_look4.urlPath = [[[_outfit photos] objectAtIndex:3] valueForKey:@"multiThumb"];
			}
		}
	}
}

- (int)expandOrContractWithTouch:(UITouch*)touch {
	if (CGRectEqualToRect(self.frame, _expandedFrame)) {
		if ([_look1 pointInside:[touch locationInView:_look1] withEvent:nil]) {
			[self setLookPart2:0 animated:YES];
			return 0;
		} else if ([_look2 pointInside:[touch locationInView:_look2] withEvent:nil]) {
			[self setLookPart2:1 animated:YES];
			return 1;
		} else if ([_look3 pointInside:[touch locationInView:_look3] withEvent:nil]) {
			[self setLookPart2:2 animated:YES];
			return 2;
		} else if ([_look4 pointInside:[touch locationInView:_look4] withEvent:nil]) {
			[self setLookPart2:3 animated:YES];
			return 3;
		} else {
			
			[self performSelector:@selector(setLookPart3)];
		}
	} else {
		[self performSelector:@selector(fadeInExpand)];
	}
	return -1;
}

- (void)fadeInExpand {
	[UIView beginAnimations:@"FadeOutSmallAnimation" context:nil];
	self.alpha = 0;
	
	[UIView commitAnimations];
	self.frame = _expandedFrame;
	[UIView beginAnimations:@"FadeInLargeAnimation" context:nil];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)setLook:(NSInteger)lookIndex animated:(BOOL)animated {
	_nextLookIndex = lookIndex;
	if (animated) {
		
		[UIView beginAnimations:@"SetLookAnimation" context:nil];
		
		CGRect newFrame = [self colapsedFrameForPhotoAtIndex:lookIndex includeBorder:YES];
		_selectionView.frame = newFrame;
		_lookIndex = lookIndex; 
		
		[UIView commitAnimations];
	} else {
		self.frame = _expandedFrame;
		[self setLookPart2:lookIndex animated:NO];
	}
}

- (void)setLookPart2:(NSInteger)lookIndex animated:(BOOL)animated {
	if (animated) {
		[UIView beginAnimations:@"SetLookPart2Animation" context:nil];
		[UIView setAnimationDuration:0.2];
	}
	CGRect newFrame = [self expandedFrameForPhotoAtIndex:lookIndex includeBorder:YES];
	_selectionView.frame = newFrame;
	_lookIndex = lookIndex; 
	
	if (animated) {
		[UIView commitAnimations];
		// Note: I Would normally use an animation callback here, but sometimes the frame doesn't change
		// and the animation returns immediately. this makes for wonky animations.
        
		[self performSelector:@selector(setLookPart3) withObject:nil afterDelay:0.3];
	}
}

- (void)setLookExpanded:(NSInteger)lookIndex {
    [UIView beginAnimations:@"SetLookPart2Animation" context:nil];
    [UIView setAnimationDuration:0.2];
    
    CGRect newFrame = [self expandedFrameForPhotoAtIndex:lookIndex includeBorder:YES];
    _selectionView.frame = newFrame;
    _lookIndex = lookIndex; 

    [UIView commitAnimations];
}

- (void)setLookAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self setLookPart2:_nextLookIndex animated:YES];
}

- (void)setLookPart3 {
	[UIView beginAnimations:@"SetLookPart3Animation" context:nil];
	self.alpha = 0;
	[UIView setAnimationDidStopSelector:@selector(fadeOutAnimationDidStop:finished:context:)];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
}

- (void)fadeOutAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	self.frame = _collapsedFrame;
	[UIView beginAnimations:nil context:nil];
	self.alpha = 1;
	[UIView commitAnimations];
}

- (void)zoomOut {
	[UIView beginAnimations:@"FadeOutLarge" context:nil];
	self.backgroundColor = RGBACOLOR(0,0,0,0.0);
	[UIView commitAnimations];
	[UIView beginAnimations:@"CollapseAnimation" context:nil];
	self.frame = _collapsedFrame;
	[UIView commitAnimations];
}

/// zooms out view after a delay
- (void)zoomOutAfterDelay:(NSInteger)delay {
	//[self performSelector:@selector(zoomOut) withObject:nil afterDelay:delay];
    if (_zoomOutTimer) {
        [_zoomOutTimer invalidate];
        [_zoomOutTimer release];
        _zoomOutTimer = nil;
    }
    _zoomOutTimer = [[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(zoomOutTimerFired:) userInfo:nil repeats:NO] retain];
}

- (void)zoomOutTimerFired:(NSTimer*)timer {
    [_zoomOutTimer release];
    _zoomOutTimer = nil;
    [self zoomOut];
}

- (void)draggedWithLeftOffset:(double)offset {
	if (CGRectEqualToRect(self.frame, _expandedFrame)) {
		// Don't clobber the frame if the overlay is expanded.
		return;
	}
	int widthFrom1ThumbToTheNext = 23;
	double totalWidth = 320 + 40;
	
	float lValue = offset/totalWidth*widthFrom1ThumbToTheNext;
	CGRect original = [self colapsedFrameForPhotoAtIndex:_lookIndex includeBorder:YES];
	CGRect new = CGRectOffset(original, -lValue, 0);
	[UIView beginAnimations:@"SlideBorderAnimation" context:nil];
	_selectionView.frame = new;
	[UIView commitAnimations];
}

@end
