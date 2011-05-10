//
//  GTIOBlurrableImageView.h
//  GoTryItOn
//
//  Created by Blake Watters on 8/20/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOBlurringOverlayView.h"
#import "GTIODraggableImageView.h"
#import "GTIOBlurringToolbarView.h"

@protocol GTIOBlurrableImageViewDelegate;

@interface GTIOBlurrableImageView : UIImageView <GTIODraggableImageViewDelegate> {
	NSObject<GTIOBlurrableImageViewDelegate>* _delegate;
	BOOL _blurringEnabled;	
	
	UIView* _overlayParentView;
	GTIODraggableImageView* _draggableImageView;
	GTIOBlurringOverlayView* _blurringOverlayView;
	GTIOBlurringToolbarView* _blurringToolbarView;
}

/**
 * The delegate for the blurrable image view
 */
@property (nonatomic, assign) NSObject<GTIOBlurrableImageViewDelegate>* delegate;

/**
 * When YES, a blurring toolbar overlay will be added to the view
 *
 * @default NO
 */
@property (nonatomic, assign) BOOL blurringEnabled;

/**
 * Provides an accessor for setting the parent view for the overlay. This
 * allows the overlay to position itself above a scroll view container
 */
@property (nonatomic, assign) UIView* overlayParentView;

/**
 * Commit the blurring operation and update the image. The blurring
 * overlay will be removed and blurringEnabled will be set to NO.
 */
- (void)commitBlur;

/**
 * Abandon the blurring operation and leave the image as is. The blurring
 * overlay will be removed and blurringEnabled will be set to NO.
 */
- (void)abandonBlur;

@end

@protocol GTIOBlurrableImageViewDelegate
@optional

/**
 * Sent to the delegate when the blur operation has been committed
 */
- (void)blurrableImageViewDidCommitBlur:(GTIOBlurrableImageView*)blurrableImageView;

/**
 * Sent to the delegate when the blur operation has been abandoned
 */
- (void)blurrableImageViewDidAbandonBlur:(GTIOBlurrableImageView*)blurrableImageView;

/**
 * Gives the delegate a chance to adjust the blurrable target rect before the 
 * blur operation is committed
 */
- (CGRect)rectForCommitBlurWithRect:(CGRect)rect;

@end
