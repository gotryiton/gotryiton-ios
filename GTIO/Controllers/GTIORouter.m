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
#import "GTIOMyHeartsViewController.h"

static NSString * const kGTIOURLScheme = @"gtio";

static NSString * const kGTIOURLHostProfile = @"profile";
static NSString * const kGTIOURLHostSignOut = @"sign-out";
static NSString * const kGTIOURLHostWhoHeartedPost = @"who-hearted-post";
static NSString * const kGTIOURLHostFindFriends = @"find-friends";
static NSString * const kGTIOURLHostUser = @"user";
static NSString * const kGTIOURLHostMyFollowing = @"my-following";
static NSString * const kGTIOURLHostMyFollowers = @"my-followers";
static NSString * const kGTIOURLHostMyStars = @"my-stars";
static NSString * const kGTIOURLHostSuggestedFriends = @"suggested-friends";
static NSString * const kGTIOURLHostInviteFriends = @"invite-friends";
static NSString * const kGTIOURLHostSearchFriends = @"search-friends";
static NSString * const kGTIOURLHostMyHearts = @"my-hearts";

static NSString * const kGTIOURLSubPathFollowing = @"following";
static NSString * const KGTIOURLSubPathFollowers = @"followers";
static NSString * const kGTIOURLSubPathStars = @"stars";

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
    } else if ([urlHost isEqualToString:kGTIOURLHostUser]) {
        if ([pathComponents count] >= 3) {
            if ([[pathComponents objectAtIndex:2] isEqualToString:kGTIOURLSubPathFollowing]) {
                viewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFollowing];
                [((GTIOFriendsViewController *)viewController) setUserID:[pathComponents objectAtIndex:1]];
            }
            if ([[pathComponents objectAtIndex:2] isEqualToString:KGTIOURLSubPathFollowers]) {
                viewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFollowers];
                [((GTIOFriendsViewController *)viewController) setUserID:[pathComponents objectAtIndex:1]];
            }
            if ([[pathComponents objectAtIndex:2] isEqualToString:kGTIOURLSubPathStars]) {
                // Stars view controller
            }
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostMyFollowers]) {
        viewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFollowers];
        [((GTIOFriendsViewController *)viewController) setUserID:[GTIOUser currentUser].userID];
    } else if ([urlHost isEqualToString:kGTIOURLHostMyFollowing]) {
        viewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFollowers];
        [((GTIOFriendsViewController *)viewController) setUserID:[pathComponents objectAtIndex:1]];
    } else if ([urlHost isEqualToString:kGTIOURLHostMyStars]) {
        // Stars view controller
    } else if ([urlHost isEqualToString:kGTIOURLHostSearchFriends]) {
        viewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFindFriends];
        [((GTIOFriendsViewController *)viewController) setUserID:[GTIOUser currentUser].userID];
    } else if ([urlHost isEqualToString:kGTIOURLHostInviteFriends]) {
        // Invite friends view controller
    } else if ([urlHost isEqualToString:kGTIOURLHostSuggestedFriends]) {
        viewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeSuggested];
        [((GTIOFriendsViewController *)viewController) setUserID:[GTIOUser currentUser].userID];
    } else if ([urlHost isEqualToString:kGTIOURLHostMyHearts]) {
        viewController = [[GTIOMyHeartsViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    return viewController;
}

@end
