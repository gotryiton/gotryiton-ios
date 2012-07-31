//
//  GTIORetryHUD.h
//  GTIO
//
//  Created by Scott Penrose on 7/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//
//  Based off MBProgressHUD
//

#import <UIKit/UIKit.h>

@class GTIORetryHUD;

typedef enum {
	/** Opacity animation */
	GTIORetryHUDAnimationFade,
	/** Opacity + scale animation */
	GTIORetryHUDAnimationZoom
} GTIORetryHUDAnimation;

typedef void(^GTIORetryHUDRetryHandler)(GTIORetryHUD *retryHUD);

@interface GTIORetryHUD : UIView

@property (nonatomic, copy) GTIORetryHUDRetryHandler retryHandler;
@property (nonatomic, copy) NSString *text;

/**
 * The animation type that should be used when the HUD is shown and hidden.
 *
 * @see GTIORetryHUDAnimation
 */
@property (assign) GTIORetryHUDAnimation animationType;

+ (GTIORetryHUD *)showHUDAddedTo:(UIView *)view text:(NSString *)text retryHandler:(GTIORetryHUDRetryHandler)retryHandler;
+ (BOOL)hideHUDForView:(UIView *)view;

@end
