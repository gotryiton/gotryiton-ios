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

@implementation GTIOErrorController

+ (void)displayAlertViewForError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
    
    NSArray *objects = [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey];
    NSString *errorTitle = @"error";
    NSString *errorMessage = @"";
    
    if ([objects count] > 0) {
        for (id obj in objects) {
            if ([obj isKindOfClass:[GTIOError class]]) {
                [self showAlertForError:obj];
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

+ (void)showAlertForError:(GTIOError *)error
{
    if (error.alert) {
        NSString *errorTitle = @"error";
        if ([error.alert.title length] > 0) {
            errorTitle = error.alert.title;
        }
        NSString *errorMessage = error.alert.text;
        
        [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
