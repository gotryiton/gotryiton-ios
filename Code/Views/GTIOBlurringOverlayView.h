//
//  GTIOBlurringOverlayView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/26/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOBlurringOverlayView : UIView {
	UIView* _forwardTouchesToView;
}

@property (nonatomic, assign) UIView* forwardTouchesToView;

@end
