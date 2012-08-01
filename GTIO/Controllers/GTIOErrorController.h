//
//  GTIOErrorController.h
//  GTIO
//
//  Created by Scott Penrose on 7/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIORetryHUD.h"

@interface GTIOErrorController : NSObject

+ (void)handleError:(NSError *)error showRetryInView:(UIView *)view retryHandler:(GTIORetryHUDRetryHandler)retryHandler;

@end
