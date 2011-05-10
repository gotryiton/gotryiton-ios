//
//  GTIOBlurrableImageView.m
//  GoTryItOn
//
//  Created by Blake Watters on 8/20/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOBlurrableImageView.h"
#import "UIImage+Manipulation.h"

@interface GTIOBlurrableImageView (Private)

- (void)addOverlay;
- (void)removeOverlay;

@end

@implementation GTIOBlurrableImageView

@synthesize blurringEnabled = _blurringEnabled;
@synthesize overlayParentView = _overlayParentView;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_blurringEnabled = NO;		
		_overlayParentView = nil;
	}
	
	return self;
}

- (void)dealloc {
	_overlayParentView = nil;
	_delegate = nil;
	TT_RELEASE_SAFELY(_draggableImageView);
	TT_RELEASE_SAFELY(_blurringOverlayView);
	
	[super dealloc];
}

- (void)setBlurringEnabled:(BOOL)blurringEnabled {
	_blurringEnabled = blurringEnabled;
	
	if (self.blurringEnabled) {
		[self addOverlay];
	} else {
		[self removeOverlay];
	}
}

- (void)addOverlay {	
	// Create the draggable image view for showing blurring preview
	CGFloat blurOverlayInitialRadius = 42;
	_draggableImageView = [[GTIODraggableImageView alloc] initWithImage:[UIImage imageNamed:@"BlurBrush.png"]];
	_draggableImageView.alpha = 0.5;
	_draggableImageView.frame = CGRectMake(0, 0, blurOverlayInitialRadius*2, blurOverlayInitialRadius*2);
	_draggableImageView.layer.cornerRadius = blurOverlayInitialRadius;
	
	_draggableImageView.center = CGPointMake(self.superview.center.x, self.superview.center.y * 2.0 / 3.0);	
	_draggableImageView.constrainingRect = self.superview.bounds;
	_draggableImageView.delegate = self;
	_draggableImageView.multipleTouchEnabled = YES;	
	_draggableImageView.userInteractionEnabled = NO; // only let overlay view forward touches.
	
	// Create the overlay that is used to forward touches to the draggable
	_blurringOverlayView = [[GTIOBlurringOverlayView alloc] initWithFrame:self.superview.frame];
	_blurringOverlayView.forwardTouchesToView = _draggableImageView;
	_blurringOverlayView.userInteractionEnabled = YES;
	_blurringOverlayView.multipleTouchEnabled = YES;
	_blurringOverlayView.clipsToBounds = YES;
	
	if (_overlayParentView) {
		[_overlayParentView addSubview:_blurringOverlayView];
	} else {
		[self addSubview:_blurringOverlayView];
	}	
	
	[_blurringOverlayView addSubview:_draggableImageView];
	
	// Keep/Remove buttons
	float width = 250;
	float height = 42;
	CGRect toolbarRect = CGRectMake((floor(_blurringOverlayView.bounds.size.width - width)/2), 
									_blurringOverlayView.bounds.size.height - height, 
									width, height+10);
	_blurringToolbarView = [[GTIOBlurringToolbarView alloc] initWithFrame:toolbarRect];
	[_blurringToolbarView.keepButton addTarget:self action:@selector(commitBlur) forControlEvents:UIControlEventTouchUpInside];
	[_blurringToolbarView.removeButton addTarget:self action:@selector(abandonBlur) forControlEvents:UIControlEventTouchUpInside];
	[_blurringOverlayView addSubview:_blurringToolbarView];
	[_blurringToolbarView release];
}

- (void)removeOverlay {
	[_draggableImageView removeFromSuperview];
	_draggableImageView = nil;
	[_blurringOverlayView removeFromSuperview];
	_blurringOverlayView = nil;
}

#pragma mark Actions

- (void)commitBlur {	
	TTOpenURL(@"gtio://analytics/trackUserDidApplyBlurMask");
	
	CGRect blurRect = _draggableImageView.frame;
	// Allow the delegate to adjust the blur rect
	if ([_delegate respondsToSelector:@selector(rectForCommitBlurWithRect:)]) {
		blurRect = [_delegate rectForCommitBlurWithRect:blurRect];
	}
	
	// Update the image with the blur applied
	self.image = [self.image imageWithBlurredRegionAtRect:blurRect withRadius:(blurRect.size.height/2)];
	self.blurringEnabled = NO;
	
	if ([_delegate respondsToSelector:@selector(blurrableImageViewDidCommitBlur:)]) {
		[_delegate blurrableImageViewDidCommitBlur:self];
	}
}

- (void)abandonBlur {
	// Abandon the blurring and revert to the previous image. Will remove the toolbar
	self.blurringEnabled = NO;
	
	if ([_delegate respondsToSelector:@selector(blurrableImageViewDidAbandonBlur:)]) {
		[_delegate blurrableImageViewDidAbandonBlur:self];
	}
}

@end
