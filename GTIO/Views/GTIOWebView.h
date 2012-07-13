//
//  GTIOWebView.h
//  GTIO
//
//  Created by Scott Penrose on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOWebView : UIWebView

- (void)loadGTIORequestWithURLString:(NSString *)URLString;
- (void)loadGTIORequestWithURL:(NSURL *)URL;

@end
