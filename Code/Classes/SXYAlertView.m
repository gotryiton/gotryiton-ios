//
//  SXYAlertView.m
//  GTIO
//
//  Created by Jeremy Ellison on 2/9/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import "SXYAlertView.h"

@implementation SXYAlertView

@synthesize action;

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message action:(SXYAlertAction)block cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... {
    SXYAlertView* alert = [[SXYAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    va_list args;
    va_start(args, otherButtonTitles);
    NSString* arg;
    while ((arg = va_arg(args, NSString*))) {
        [alert addButtonWithTitle:arg];
    }
    va_end(args);
    alert.delegate = alert;
    alert.action = Block_copy(block);
    [alert show];
    [alert release];
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.action(buttonIndex);
    Block_release(self.action);
    self.action = NULL;
}

@end
