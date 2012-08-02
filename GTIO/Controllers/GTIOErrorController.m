//
//  GTIOErrorController.m
//  GTIO
//
//  Created by Scott Penrose on 7/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOErrorController.h"

#import <RestKit/RestKit.h>

#import "GTIOError.h"

static NSString * const kGTIODefaultErrorTitle = @"error";
static NSString * const kGTIODefaultMessage = @"couldn't connect to Go Try It On";

@implementation GTIOErrorController

+ (void)handleError:(NSError *)error showRetryInView:(UIView *)view forceRetry:(BOOL)forceRetry retryHandler:(GTIORetryHUDRetryHandler)retryHandler
{
    NSLog(@"Error: %@", [error localizedDescription]);
    
    NSArray *objects = [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey];
    NSString *errorTitle = kGTIODefaultErrorTitle;
    NSString *errorMessage = @"";
    
    if ([objects count] > 0) {
        for (id obj in objects) {
            if ([obj isKindOfClass:[GTIOError class]]) {
                [self handleAlert:((GTIOError *)obj).alert showRetryInView:view retryHandler:retryHandler];
                return;
            }
        }
    } else if ([error.domain isEqualToString:@"org.restkit.RestKit.ErrorDomain"]) {
        errorMessage = [self messageForRestKitErrorCode:error.code];
    } else if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
        errorMessage = [self messageForNSURLErrorErrorCode:error.code];
    } else {
        errorMessage = @"an unknown error has occurred.";
        NSLog(@"An unhandled error as occured: %@.", error);
    }

    if (forceRetry){
        GTIOAlert *alert = [[GTIOAlert alloc] init];
        alert.message = errorMessage;
        alert.dimScreen = [NSNumber numberWithInt:1];
        alert.retry = [NSNumber numberWithInt:1];
        [self handleAlert:alert showRetryInView:view retryHandler:retryHandler];
        return;
    }
    
    [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

+ (void)handleAlert:(GTIOAlert *)alert showRetryInView:(UIView *)view retryHandler:(GTIORetryHUDRetryHandler)retryHandler
{
    if (alert) {
        if ([alert.retry boolValue]) {
            // Show Retry
            NSString *message = kGTIODefaultMessage;
            if ([alert.message length] > 0) {
                message = alert.message;
            }
            
            [GTIORetryHUD showHUDAddedTo:view text:message dimScreen:[alert.dimScreen boolValue] retryHandler:^(GTIORetryHUD *HUD) {
                if (retryHandler) {
                    retryHandler(HUD);
                }
                [GTIORetryHUD hideHUDForView:view];
            }];
        } else {
            // Show Alert
            NSString *errorTitle = kGTIODefaultErrorTitle;
            if ([alert.title length] > 0) {
                errorTitle = alert.title;
            }
            NSString *errorMessage = alert.message;
            
            [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

#pragma mark - Helpers

+ (NSString*)messageForRestKitErrorCode:(NSInteger)errorCode
{
    switch (errorCode) {
        case 2: return @"could not connect to the server."; 
        case 1001: return @"the request could not be completed.";
        default: return @"an unknown error has occurred.";
    }
}

+ (NSString*)messageForNSURLErrorErrorCode:(NSInteger)errorCode
{
    // CFNetwork Error Code Reference @ https://developer.apple.com/library/ios/#documentation/Networking/Reference/CFNetworkErrors/Reference/reference.html
    switch (errorCode) {
        case kCFURLErrorTimedOut: return @"could not connect to the server.";
        case kCFURLErrorCannotFindHost: return @"could not connect to the server.";
        case kCFURLErrorCannotConnectToHost: return @"could not connect to the server.";
        default: return @"an unknown error has occurred.";
    }
}

@end
