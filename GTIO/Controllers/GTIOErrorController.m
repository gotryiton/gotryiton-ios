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
#import "GTIOAlert.h"

static NSString * const kGTIODefaultErrorTitle = @"error";
static NSString * const kGTIODefaultMessage = @"couldn't connect to Go Try It On";

@implementation GTIOErrorController

+ (void)handleError:(NSError *)error showRetryInView:(UIView *)view retryHandler:(GTIORetryHUDRetryHandler)retryHandler
{
    NSLog(@"Error: %@", [error localizedDescription]);
    
    NSArray *objects = [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey];
    NSString *errorTitle = kGTIODefaultErrorTitle;
    NSString *errorMessage = @"";
    
    if ([objects count] > 0) {
        for (id obj in objects) {
            if ([obj isKindOfClass:[GTIOError class]]) {
                [self handleGTIOError:obj showRetryInView:view retryHandler:retryHandler];
                return;
            }
        }
    } else if ([error.domain isEqualToString:@"org.restkit.RestKit.ErrorDomain"]) {
        errorMessage = [self messageForRestKitErrorCode:error.code];
    } else if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
        errorMessage = [self messageForNSURLErrorErrorCode:error.code];
    } else {
        errorMessage = @"An unknown error has occurred";
        NSLog(@"An unhandled error as occured: %@.", error);
    }
    
    [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

+ (NSString*)messageForRestKitErrorCode:(NSInteger)errorCode
{
    switch (errorCode) {
        case 2: return @"Could not connect to the server";
        case 1001: return @"Request could not be completed at this time";
        default: return @"An unknown error has occurred";
    }
}

+ (NSString*)messageForNSURLErrorErrorCode:(NSInteger)errorCode
{
    // CFNetwork Error Code Reference @ https://developer.apple.com/library/ios/#documentation/Networking/Reference/CFNetworkErrors/Reference/reference.html
    switch (errorCode) {
        case kCFURLErrorTimedOut: return @"Could not connect to the server";
        case kCFURLErrorCannotFindHost: return @"Could not connect to the server";
        case kCFURLErrorCannotConnectToHost: return @"Could not connect to the server";
        default: return @"An unknown error has occurred";
    }
}

+ (void)handleGTIOError:(GTIOError *)error showRetryInView:(UIView *)view retryHandler:(GTIORetryHUDRetryHandler)retryHandler
{
    if (error.alert) {
        if ([error.alert.retry boolValue]) {
            // Show Retry
            NSString *message = kGTIODefaultMessage;
            if ([error.alert.message length] > 0) {
                message = error.alert.message;
            }
            
            [GTIORetryHUD showHUDAddedTo:view text:message retryHandler:^(GTIORetryHUD *HUD) {
                if (retryHandler) {
                    retryHandler(HUD);
                }
                [GTIORetryHUD hideHUDForView:view];
            }];
        } else {
            // Show Alert
            NSString *errorTitle = kGTIODefaultErrorTitle;
            if ([error.alert.title length] > 0) {
                errorTitle = error.alert.title;
            }
            NSString *errorMessage = error.alert.message;
            
            [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

@end
