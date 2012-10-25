//
//  GTIOEnvironment.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOEnvironment.h"

#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>

/** Go Try It On Build Environments
 *
 *  These settings determine what server environment the client
 *  is communicating with
 */

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_DEVELOPMENT
    NSString * const kGTIOEnvironmentName = @"Development";
    NSString * const kGTIOBaseURLString = @"http://gtio-dev.gotryiton.com";
    NSString * const kGTIOJanRainEngageApplicationID = @"***REMOVED***";
    NSString * const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString * const kGTIOFacebookAppID = @"125885160757300";
    NSUInteger const kGTIONetworkLogLevel = RKLogLevelTrace;
    NSUInteger const kGTIOLogLevel = RKLogLevelDebug;
    NSString * const kGTIOHTTPAuthUsername = @"tt";
    NSString * const kGTIOHTTPAuthPassword = @"toast";
    BOOL const kGTIOUAirshipAppStoreOrAdHocBuild = NO;
    NSString * const kGTIOUAirshipDevelopmentAppKey = @"***REMOVED***";
    NSString * const kGTIOUAirshipDevelopmentAppSecret = @"***REMOVED***";
    NSString * const kGTIOFlurryAnalyticsKey = @"***REMOVED***";
    NSString * const kGTIOYozioAnalyticsKey = @"***REMOVED***";
    NSString * const kGTIOYozioAnalyticsURL = @"http://yoz.io/e?app_key=%@&device_name=%@";
    NSInteger const kGTIOSecondsInactiveBeforeRefresh = 1 * 60; // num minutes * num seconds/min
    NSInteger const kGTIOUniqueNameModalDialogMaxViews = 1;
#endif

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_STAGING
    NSString * const kGTIOEnvironmentName = @"Staging";
    NSString * const kGTIOBaseURLString = @"http://staging.gotryiton.com";
    NSString * const kGTIOJanRainEngageApplicationID = @"***REMOVED***";
    NSString * const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString * const kGTIOFacebookAppID = @"125885160757300";
    NSUInteger const kGTIONetworkLogLevel = RKLogLevelTrace;
    NSUInteger const kGTIOLogLevel = RKLogLevelDebug;
    NSString* const kGTIOHTTPAuthUsername = @"tt";
    NSString* const kGTIOHTTPAuthPassword = @"toast";
    BOOL const kGTIOUAirshipAppStoreOrAdHocBuild = NO;
    NSString * const kGTIOUAirshipDevelopmentAppKey = @"***REMOVED***";
    NSString * const kGTIOUAirshipDevelopmentAppSecret = @"***REMOVED***";
    NSString * const kGTIOFlurryAnalyticsKey = @"***REMOVED***";
    NSString * const kGTIOYozioAnalyticsKey = @"***REMOVED***";
    NSString * const kGTIOYozioAnalyticsURL = @"http://yoz.io/e?app_key=%@&device_name=%@";
    NSInteger const kGTIOSecondsInactiveBeforeRefresh = 5 * 60; // num minutes * num seconds/min
    NSInteger const kGTIOUniqueNameModalDialogMaxViews = 1;
#endif

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_PRODUCTION
    NSString * const kGTIOEnvironmentName = @"Production";
    NSString * const kGTIOBaseURLString = @"http://api.gotryiton.com";
    NSString * const kGTIOJanRainEngageApplicationID = @"iligdiaplfgbmhcpebgf";
    NSString * const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString * const kGTIOFacebookAppID = @"126454074038555";
    NSUInteger const kGTIONetworkLogLevel = RKLogLevelError;
    NSUInteger const kGTIOLogLevel = RKLogLevelError;
    NSString * const kGTIOHTTPAuthUsername = nil;
    NSString * const kGTIOHTTPAuthPassword = nil;
    BOOL const kGTIOUAirshipAppStoreOrAdHocBuild = YES;
    NSString * const kGTIOUAirshipDevelopmentAppKey = @"";
    NSString * const kGTIOUAirshipDevelopmentAppSecret = @"";
    NSString * const kGTIOFlurryAnalyticsKey = @"***REMOVED***";
    NSString * const kGTIOYozioAnalyticsKey = @"***REMOVED***";
    NSString * const kGTIOYozioAnalyticsURL = @"http://yoz.io/e?app_key=%@&device_name=%@";
    NSInteger const kGTIOSecondsInactiveBeforeRefresh = 30 * 60; // num minutes * num seconds/min
    NSInteger const kGTIOUniqueNameModalDialogMaxViews = 1;
#endif

NSString * const kGTIOAcceptHeader = @"application/v4.1-json";
NSString * const kGTIOAuthenticationHeaderKey = @"Authentication";
NSString * const kGTIOTrackingHeaderKey = @"Tracking-Id";

/* janrain providers */
NSString * const kGTIOJanRainProviderAol = @"aol";
NSString * const kGTIOJanRainProviderGoogle = @"google";
NSString * const kGTIOJanRainProviderTwitter = @"twitter";
NSString * const kGTIOJanRainProviderYahoo = @"yahoo";

// Notification Constants
NSString * const kGTIOLooksUpdated = @"kGTIOLooksUpdated";
NSString * const kGTIOPostFeedOpenLinkNotification = @"kGTIOPostFeedOpenLinkNotification";
NSString * const kGTIONotificationCountNofitication = @"kGTIONotificationCountNofitication";
NSString * const kGTIOChangeSelectedTabNotification = @"kGTIOChangeSelectedTabNotification";
NSString * const kGTIOAddTabBarToWindowNotification = @"kGTIOAddTabBarToWindowNotification";
NSString * const kGTIOExploreLooksChangeResourcePathNotification = @"kGTIOExploreLooksChangeResourcePathNotification";
NSString * const kGTIOStylesChangeCollectionIDNotification = @"kGTIOStylesChangeCollectionIDNotification";
NSString * const kGTIOTabBarViewsResize = @"kGTIOTabBarViewsResize";
NSString * const kGTIOShowProfileUserNotification = @"kGTIOShowProfileUserNotification";
NSString * const kGTIOAppReturningFromInactiveStateNotification = @"kGTIOAppReturningFromInactiveStateNotification";
NSString * const kGTIOFeedControllerShouldRefresh = @"kGTIOFeedControllerShouldRefresh";
NSString * const kGTIOExploreLooksControllerShouldRefresh = @"kGTIOExploreLooksControllerShouldRefresh";
NSString * const kGTIOStyleControllerShouldRefresh = @"kGTIOLooksControllerShouldRefresh";
NSString * const kGTIOMeControllerShouldRefresh = @"kGTIOMeControllerShouldRefresh";
NSString * const kGTIOAllControllersShouldRefresh = @"kGTIOAllControllersShouldRefresh";
NSString * const kGTIOAllControllersShouldDoForcedRefresh = @"kGTIOAllControllersShouldDoForcedRefresh";
NSString * const kGTIOAllControllersShouldRefreshAfterLogout = @"kGTIOAllControllersShouldRefreshAfterLogout";
NSString * const kGTIOShouldShowUniqueNameModalView = @"kGTIOShouldShowUniqueNameModalView";
NSString * const kGTIOFeedControllerShouldScrollToTopNotification = @"kGTIOFeedControllerShouldScrollToTopNotification";
NSString * const kGTIOExploreControllerShouldScrollToTopNotification = @"kGTIOExploreControllerShouldScrollToTopNotification";
NSString * const kGTIOStyleControllerShouldScrollToTopNotification = @"kGTIOStyleControllerShouldScrollToTopNotification";
NSString * const kGTIOMeControllerShouldScrollToTopNotification = @"kGTIOMeControllerShouldScrollToTopNotification";
NSString * const kGTIOHideExploreLooksIntroOverlay = @"kGTIOHideExploreLooksIntroOverlay";
NSString * const kGTIONotificationUnreadCountUserInfo = @"kGTIONotificationUnreadCountUserInfo";

// Notification UserInfo
NSString * const kGTIOChangeSelectedTabToUserInfo = @"kGTIOChangeSelectedTabToUserInfo";
NSString * const kGTIOResourcePathKey = @"kGTIOResourcePathKey";
NSString * const kGTIOProfileUserIDUserInfo = @"kGTIOProfileUserIDUserInfo";
NSString * const kGTIOCollectionIDUserInfoKey = @"kGTIOCollectionIDUserInfoKey";

// Tracking constants
NSString * const kGTIOUserNavigatedToFeedTab = @"navigation to feed";
NSString * const kGTIOUserNavigatedToExploreTab = @"navigation to explore";
NSString * const kGTIOUserNavigatedToStyleTab = @"navigation to style";
NSString * const kGTIOUserNavigatedToMeTab = @"navigation to me";
NSString * const kGTIOUserNavigatedToCameraTab = @"navigation to camera";
NSString * const kGTIONotificationViewTrackingId = @"notification view";


// Unique Name modal flag
NSString * const kGTIOUniqueNameModalDialogFlag = @"kGTIOUniqueNameModalDialogFlag";

// UrbanAirship
NSString * const kGTIOUAirshipProductionAppKey = @"***REMOVED***";
NSString * const kGTIOUAirshipProductionAppSecret = @"***REMOVED***";

// Push Notification Device Token
NSString * const kGTIOPushNotificationDeviceTokenUserDefaults = @"kGTIOPushNotificationDeviceTokenUserDefaults";
 
NSString * const kGTIOURL = @"kGTIOURL";

NSString * const kGTIOUserInfoButtonNameFollowing = @"following";
NSString * const kGTIOUserInfoButtonNameFollowers = @"followers";
NSString * const kGTIOUserInfoButtonNameStars = @"stars";
NSString * const kGTIOUserInfoButtonNameWebsite = @"website-button";
NSString * const kGTIOUserInfoButtonNameFollow = @"follow-button";
NSString * const kGTIOUserInfoButtonNameBannerAd = @"banner-ad";
NSString * const kGTIOUserInfoButtonNameAcceptRelationship = @"accept-relationship-button";
NSString * const kGTIOPostSideReviewsButton = @"post-side-reviews-button";
NSString * const kGTIOPostSideShopButton = @"post-side-shop-button";
NSString * const kGTIOPostDotOptionButton = @"post-dot-option-button";
NSString * const kGTIOSuggestedFriendsButtonName = @"suggested-friends-button";
NSString * const kGTIOInviteFriendsButtonName = @"invite-friends-button";
NSString * const kGTIOFindFriendsButtonName = @"find-friends-button";
NSString * const kGTIOReviewAgreeButton = @"review-agree-button";
NSString * const kGTIOReviewFlagButton = @"review-flag-button";
NSString * const kGTIOReviewRemoveButton = @"review-delete-button";
NSString * const kGTIOProductWhoHeartedButton = @"product-who-hearted-button";
NSString * const kGTIOProductHeartButton = @"product-heart-button";
NSString * const kGTIOProductShoppingListButton = @"product-shopping-list-button";

NSTimeInterval const kGTIOWebViewTimeout = 10.0f;

int const kGTIOEmptyPostAlertTag = 0;
int const kGTIOEmptyDescriptionAlertTag = 1;

#pragma mark - JSON Params Serialization Helper

id GTIOJSONParams(id obj) {
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:obj error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    return [RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON];
}
