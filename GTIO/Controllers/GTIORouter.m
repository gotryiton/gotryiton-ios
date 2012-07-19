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
#import "GTIOMyPostsViewController.h"
#import "GTIOReviewsViewController.h"
#import "GTIOFeedViewController.h"
#import "GTIOInternalWebViewController.h"
#import "GTIOWebViewController.h"
#import "GTIOExploreLooksViewController.h"
#import "GTIOProductViewController.h"

NSString * const kGTIOURLScheme = @"gtio";
NSString * const kGTIOHttpURLScheme = @"http";

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
static NSString * const kGTIOURLHostMyPosts = @"my-posts";
static NSString * const kGTIOURLHostPosts = @"posts";
static NSString * const kGTIOURLHostPost = @"post";
static NSString * const kGTIOURLHostPostedBy = @"posted-by";
static NSString * const kGTIOURLHostReviewsForPost = @"reviews-for-post";
static NSString * const kGTIOURLHostInternalWebView = @"internal-webview";
static NSString * const kGTIOURLHostDefaultWebView = @"default-webview";
static NSString * const kGTIOURLHostProduct = @"product";

static NSString * const kGTIOURLSubPathFollowing = @"following";
static NSString * const KGTIOURLSubPathFollowers = @"followers";
static NSString * const kGTIOURLSubPathStarsByUser = @"stars-by-user";
static NSString * const kGTIOURLSubPathStars = @"stars";
static NSString * const kGTIOURLSubPathBrand = @"brand";
static NSString * const kGTIOURLSubPathHashtag = @"hashtag";

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
    UIViewController *viewController = nil;
    
    if ([[URL scheme] isEqualToString:kGTIOHttpURLScheme]) {
        viewController = [[GTIOWebViewController alloc] initWithNibName:nil bundle:nil];
        [((GTIOWebViewController *)viewController) setURL:URL];
    } else if (![[URL scheme] isEqualToString:kGTIOURLScheme]) {
        return nil;
    }
    
    NSString *urlHost = [URL host];
    NSArray *pathComponents = [URL pathComponents];
    
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
                viewController = [[GTIOMyPostsViewController alloc] initWithGTIOPostType:GTIOPostTypeStar forUserID:[pathComponents objectAtIndex:1]];
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
    } else if ([urlHost isEqualToString:kGTIOURLHostMyPosts]) {
        viewController = [[GTIOMyPostsViewController alloc] initWithGTIOPostType:GTIOPostTypeNone forUserID:nil];
    } else if ([urlHost isEqualToString:kGTIOURLHostMyStars]) {
        viewController = [[GTIOMyPostsViewController alloc] initWithGTIOPostType:GTIOPostTypeStar forUserID:nil];
    } else if ([urlHost isEqualToString:kGTIOURLHostPosts]) {
        if ([pathComponents count] >= 3) {
            if ([[pathComponents objectAtIndex:1] isEqualToString:kGTIOURLSubPathStarsByUser]) {
                viewController = [[GTIOMyPostsViewController alloc] initWithGTIOPostType:GTIOPostTypeStar forUserID:[pathComponents objectAtIndex:2]];
            } else if ([[pathComponents objectAtIndex:1] isEqualToString:kGTIOURLSubPathBrand] || 
                       [[pathComponents objectAtIndex:1] isEqualToString:kGTIOURLSubPathHashtag]) {
                viewController = [[GTIOExploreLooksViewController alloc] initWithNibName:nil bundle:nil];
                [((GTIOExploreLooksViewController *)viewController) setResourcePath:[NSString stringWithFormat:@"%@%@", urlHost, [URL path]]];
            }
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostReviewsForPost]) {
        if ([pathComponents count] >= 2) {
            viewController = [[GTIOReviewsViewController alloc] initWithPostID:[pathComponents objectAtIndex:1]];
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostPost]) {
        if ([pathComponents count] >= 2) {
            viewController = [[GTIOFeedViewController alloc] initWithPostID:[pathComponents objectAtIndex:1]];
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostInternalWebView]) {
        if ([pathComponents count] >= 4) {
            viewController = [[GTIOInternalWebViewController alloc] initWithNibName:nil bundle:nil];
            [((GTIOInternalWebViewController *)viewController) setURL:[self embeddedURLAtEndURL:URL]];
            [((GTIOInternalWebViewController *)viewController) setNavigationTitle:[pathComponents objectAtIndex:3]];
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostDefaultWebView]) {
        if ([pathComponents count] >= 3 ) {
            viewController = [[GTIOWebViewController alloc] initWithNibName:nil bundle:nil];
            [((GTIOWebViewController *)viewController) setURL:[self embeddedURLAtEndURL:URL]];
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostProduct]) {
        if ([pathComponents count] >= 2) {
            viewController = [[GTIOProductViewController alloc] initWithProductID:[pathComponents objectAtIndex:1]];
        }
    }
    
    return viewController;
}

#pragma mark - Helpers

- (NSURL *)embeddedURLAtEndURL:(NSURL *)URL
{
    return [NSURL URLWithString:[[[[URL absoluteString] componentsSeparatedByString:@"/"] lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
