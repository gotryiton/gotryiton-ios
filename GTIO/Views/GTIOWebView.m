//
//  GTIOWebView.m
//  GTIO
//
//  Created by Scott Penrose on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOWebView.h"

#import "GTIOAuth.h"
#import "BPXLUUIDHandler.h"

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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kGTIOWebViewTimeout];
    [request setValue:[[GTIOAuth alloc] init].token forHTTPHeaderField:kGTIOAuthenticationHeaderKey];
    [request setValue:[BPXLUUIDHandler UUID] forHTTPHeaderField:kGTIOTrackingHeaderKey];
    
#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_STAGING || GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_DEVELOPMENT
    // Use CFNetwork dummy request to create the basic HTTP authorization
    CFHTTPMessageRef dummyRequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault, (CFStringRef)@"POST", (__bridge_retained CFURLRef)URL, kCFHTTPVersion1_1);
    if (dummyRequest) {
        CFHTTPMessageAddAuthentication(dummyRequest, nil, (__bridge CFStringRef)kGTIOHTTPAuthUsername, (__bridge CFStringRef)kGTIOHTTPAuthPassword, kCFHTTPAuthenticationSchemeBasic, FALSE);
        CFStringRef authorizationString = CFHTTPMessageCopyHeaderFieldValue(dummyRequest, CFSTR("Authorization"));
        if (authorizationString) {
            [request setValue:(__bridge NSString *)authorizationString forHTTPHeaderField:@"Authorization"];
            CFRelease(authorizationString);
        }
        CFRelease(dummyRequest);
    }
#endif
    
    [self loadRequest:request];
}

@end
