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
#import "GTIOProductNativeListViewController.h"
#import "GTIOShoppingListViewController.h"
#import "GTIOWhoHeartedThisViewController.h"
#import "GTIOInviteFriendsViewController.h"

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
static NSString * const kGTIOURLHostCollection = @"collection";
static NSString * const kGTIOURLHostShoppingList = @"my-shopping-list";
static NSString * const kGTIOURLHostWhoHeartedProduct = @"who-hearted-product";

static NSString * const kGTIOURLSubPathFollowing = @"following";
static NSString * const KGTIOURLSubPathFollowers = @"followers";
static NSString * const kGTIOURLSubPathStarsByUser = @"stars-by-user";
static NSString * const kGTIOURLSubPathStars = @"stars";
static NSString * const kGTIOURLSubPathBrand = @"brand";
static NSString * const kGTIOURLSubPathHashtag = @"hashtag";

@interface GTIORouter()

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation GTIORouter

@synthesize numberFormatter = _numberFormatter;

- (id)init
{
    self = [super init];
    if (self) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
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
    NSArray *unencodedPathComponents = [self unencodedPathComponents:URL];
    
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
        viewController = [[GTIOInviteFriendsViewController alloc] initWithNibName:nil bundle:nil];
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
        if ([unencodedPathComponents count] >= 3) {
            viewController = [[GTIOInternalWebViewController alloc] initWithNibName:nil bundle:nil];
            [((GTIOInternalWebViewController *)viewController) setURL:[NSURL URLWithString:[unencodedPathComponents objectAtIndex:2]]];
            [((GTIOInternalWebViewController *)viewController) setNavigationTitle:[unencodedPathComponents objectAtIndex:1]];
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostDefaultWebView]) {
        if ([unencodedPathComponents count] >= 2) {
            viewController = [[GTIOWebViewController alloc] initWithNibName:nil bundle:nil];
            [((GTIOWebViewController *)viewController) setURL:[NSURL URLWithString:[unencodedPathComponents objectAtIndex:1]]];
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostProduct]) {
        if ([pathComponents count] >= 2) {
            viewController = [[GTIOProductViewController alloc] initWithProductID:[pathComponents objectAtIndex:1]];
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostCollection]) {
        if ([pathComponents count] >= 2) {
            viewController = [[GTIOProductNativeListViewController alloc] initWithNibName:nil bundle:nil];
            NSNumber *collectionID = (NSNumber *)[self.numberFormatter numberFromString:[pathComponents objectAtIndex:1]];
            [((GTIOProductNativeListViewController *)viewController) setCollectionID:collectionID];
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostShoppingList]) {
        viewController = [[GTIOShoppingListViewController alloc] initWithNibName:nil bundle:nil];
    } else if ([urlHost isEqualToString:kGTIOURLHostWhoHeartedProduct]) {
        if ([pathComponents count] >= 2 ) {
            viewController = [[GTIOWhoHeartedThisViewController alloc] initWithGTIOWhoHeartedThisViewControllerType:GTIOWhoHeartedThisViewControllerTypePost];
            NSNumber *productID = (NSNumber *)[self.numberFormatter numberFromString:[pathComponents objectAtIndex:1]];
            productID = [NSNumber numberWithInt:1443];
            [(GTIOWhoHeartedThisViewController *)viewController setItemID:productID];
        }
    } else if ([urlHost isEqualToString:kGTIOURLHostWhoHeartedPost]) {
        if ([pathComponents count] >= 2 ) {
            viewController = [[GTIOWhoHeartedThisViewController alloc] initWithGTIOWhoHeartedThisViewControllerType:GTIOWhoHeartedThisViewControllerTypePost];
            NSNumber *postID = (NSNumber *)[self.numberFormatter numberFromString:[pathComponents objectAtIndex:1]];
            [(GTIOWhoHeartedThisViewController *)viewController setItemID:postID];
        }
    }
    
    return viewController;
}

#pragma mark - Helpers

- (NSArray *)unencodedPathComponents:(NSURL *)URL
{
    NSRange range = [[URL absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://%@", [URL scheme], [URL host]] options:NSAnchoredSearch];
    NSString *path = [[URL absoluteString] stringByReplacingCharactersInRange:range withString:@""];
    NSArray *pathComponents = [path componentsSeparatedByString:@"/"];
    NSMutableArray *unencodedPathComponents = [NSMutableArray array];
    for (NSString *pathComponent in pathComponents) {
        [unencodedPathComponents addObject:[pathComponent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return unencodedPathComponents;
}

@end
