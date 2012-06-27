//
//  GTIORouter.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIORouter.h"
#import "GTIOSignInViewController.h"
#import "GTIOFindMyFriendsViewController.h"

@interface GTIORouter()

@property (nonatomic, strong) NSDictionary *routingMap;

@end

@implementation GTIORouter

@synthesize routingMap = _routingMap;

- (id)init
{
    self = [super init];
    if (self) {
        GTIOSignInViewController *signInViewController = [[GTIOSignInViewController alloc] initWithNibName:nil bundle:nil];
        GTIOFindMyFriendsViewController *findMyFriendsViewController = [[GTIOFindMyFriendsViewController alloc] initWithNibName:nil bundle:nil];
        
        _routingMap = [NSDictionary dictionaryWithObjectsAndKeys:
                       signInViewController, @"gtio://sign-out", 
                       findMyFriendsViewController, @"gtio://find-friends",
                       nil];
    }
    return self;
}

+ (GTIORouter *)sharedRouter
{
    static GTIORouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init];
    });
    return router;
}

- (UIViewController *)routeTo:(NSString *)path
{
    UIViewController *viewControllerToReturn = (UIViewController *)[self.routingMap objectForKey:path];
    return viewControllerToReturn;
}

@end
