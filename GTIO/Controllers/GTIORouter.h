//
//  GTIORouter.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kGTIOURLScheme;
extern NSString * const kGTIOHttpURLScheme;

@interface GTIORouter : NSObject

@property (nonatomic, strong) NSURL *fullScreenImageURL;

+ (GTIORouter *)sharedRouter;

- (UIViewController *)viewControllerForURLString:(NSString*)URLString;
- (UIViewController *)viewControllerForURL:(NSURL *)URL;


@end
