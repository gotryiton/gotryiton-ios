//
//  GTIOTweetComposer.m
//  GTIO
//
//  Created by Scott Penrose on 8/1/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTweetComposer.h"

@implementation GTIOTweetComposer

- (id)initWithText:(NSString *)text URL:(NSURL *)URL completionHandler:(TWTweetComposeViewControllerCompletionHandler)completionHandler
{
    self = [super init];
    if (self) {
        [self setInitialText:text];
        if (URL) {
            [self addURL:URL];
        }
        [self setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            if (result == TWTweetComposeViewControllerResultDone)
            {
                // TODO: add a tracking request here!
            }

            if (completionHandler) {
                completionHandler(result);
            }
        }];
    }
    return self;
}



@end
