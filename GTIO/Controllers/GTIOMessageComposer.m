//
//  GTIOMessageComposer.m
//  GTIO
//
//  Created by Scott Penrose on 7/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMessageComposer.h"

@interface GTIOMessageComposer () <MFMessageComposeViewControllerDelegate>

@end

@implementation GTIOMessageComposer

@synthesize didFinishHandler = _didFinishHandler;

- (id)init
{
    self = [super init];
    if (self) {
        self.messageComposeDelegate = self;
    }
    return self;
}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (self.didFinishHandler) {
        self.didFinishHandler(controller, result);
    }
}

@end
