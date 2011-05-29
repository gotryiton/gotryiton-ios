//
//  GTIOBlurringOverlayView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/26/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// Draggable blur overlay used by [GTIOBlurrableImageView](GTIOBlurrableImageView) provides a property that holds a view it will forward all touches to

#import <UIKit/UIKit.h>

@interface GTIOBlurringOverlayView : UIView {
	UIView* _forwardTouchesToView;
}

/// Optional view to forward touches to
@property (nonatomic, assign) UIView* forwardTouchesToView;

@end
