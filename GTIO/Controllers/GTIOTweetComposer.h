//
//  GTIOTweetComposer.h
//  GTIO
//
//  Created by Scott Penrose on 8/1/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Twitter/Twitter.h>

@interface GTIOTweetComposer : TWTweetComposeViewController

- (id)initWithText:(NSString *)text URL:(NSURL *)URL completionHandler:(TWTweetComposeViewControllerCompletionHandler)completionHandler;

@end
