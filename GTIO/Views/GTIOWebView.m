//
//  GTIOWebView.m
//  GTIO
//
//  Created by Scott Penrose on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOWebView.h"

#import "NSData+Base64.h"

#import "GTIOAuth.h"

@implementation GTIOWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Remove shadow when you pull down webview
        for (UIView* subView in [self subviews])
        {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView* shadowView in [subView subviews])
                {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        [shadowView setHidden:YES];
                    }
                }
            }
        }
    }
    return self;
}

- (void)loadGTIORequestWithURLString:(NSString *)URLString
{
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadGTIORequestWithURL:URL];
}

- (void)loadGTIORequestWithURL:(NSURL *)URL
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:kGTIOWebViewTimeout];
    [request setValue:[[GTIOAuth alloc] init].token forHTTPHeaderField:kGTIOAuthenticationHeaderKey];
    
#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_STAGING || GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_DEVELOPMENT
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", kGTIOHTTPAuthUsername, kGTIOHTTPAuthPassword];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [NSData gtio_dataWithBase64EncodedString:authStr]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
#endif
    
    [self loadRequest:request];
}

@end
