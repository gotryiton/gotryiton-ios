//
//  GTIORouter.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIORouter.h"

#import "GTIOSignInViewController.h"
#import "GTIOProfileViewController.h"
#import "GTIOFriendsViewController.h"

static NSString * const kGTIOURLScheme = @"gtio";

static NSString * const kGTIOURLHostProfile = @"profile";
static NSString * const kGTIOURLHostSignOut = @"sign-out";
static NSString * const kGTIOURLHostWhoHeartedPost = @"who-hearted-post";
static NSString * const kGTIOURLHostFindFriends = @"find-friends";

@implementation GTIORouter

+ (GTIORouter *)sharedRouter
{
    static GTIORouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init];
    });
    return router;
}

- (UIViewController *)viewControllerForURLString:(NSString*)URLString
{
    NSURL *URL = [NSURL URLWithString:URLString];
    return [self viewControllerForURL:URL];
}

- (UIViewController *)viewControllerForURL:(NSURL *)URL
{
    if (![[URL scheme] isEqualToString:kGTIOURLScheme]) {
        return nil;
    }
    
    NSString *urlHost = [URL host];
    NSArray *pathComponents = [URL pathComponents];
    UIViewController *viewController = nil;
    
    if ([urlHost isEqualToString:kGTIOURLHostProfile]) {
        if ([pathComponents count] >= 2) {
            viewController = [[GTIOProfileViewController alloc] initWithNibName:nil bundle:nil];
            [((GTIOProfileViewController *)viewController) setUserID:[pathComponents objectAtIndex:1]];
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostSignOut]) {
        viewController = [[GTIOSignInViewController alloc] initWithNibName:nil bundle:nil];
    } else if ([urlHost isEqualToString:kGTIOURLHostWhoHeartedPost]) {
        // TODO: handle this
        NSLog(@"Still need to handle opening who hearted post");
    } else if ([urlHost isEqualToString:kGTIOURLHostFindFriends]) {
        viewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFindMyFriends];
    }
    
    return viewController;
}

@end
