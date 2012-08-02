//
//  GTIOErrorController.h
//  GTIO
//
//  Created by Scott Penrose on 7/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIORetryHUD.h"

#import "GTIOAlert.h"

@interface GTIOErrorController : NSObject

+ (void)handleError:(NSError *)error showRetryInView:(UIView *)view forceRetry:(BOOL)forceRetry retryHandler:(GTIORetryHUDRetryHandler)retryHandler;

+ (void)handleAlert:(GTIOAlert *)alert showRetryInView:(UIView *)view retryHandler:(GTIORetryHUDRetryHandler)retryHandler;

@end
