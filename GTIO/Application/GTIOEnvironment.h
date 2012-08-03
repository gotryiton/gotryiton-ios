//
//  GTIOEnvironment.h
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

/** Go Try It On Build Environments
 *
 *  Environment can be set as a build setting by defining a GCC Preprocessor Macro
 *  value within the Xcode Configuration. Defaults to production when not
 *  defined.
 */
#define GTIO_ENVIRONMENT_DEVELOPMENT 1
#define GTIO_ENVIRONMENT_STAGING 2
#define GTIO_ENVIRONMENT_PRODUCTION 3

// The environment we are running within (i.e. staging/production)
extern NSString * const kGTIOEnvironmentName;
extern NSString * const kGTIOBaseURLString;

// JanRain  (used for authentication via Engage)
extern NSString * const kGTIOJanRainEngageApplicationID;
extern NSString * const kGTIOJanRainProviderAol;
extern NSString * const kGTIOJanRainProviderGoogle;
extern NSString * const kGTIOJanRainProviderTwitter;
extern NSString * const kGTIOJanRainProviderYahoo;

// Facebook
extern NSString * const kGTIOFacebookAppID;

// Flurry
extern NSString * const kGTIOFlurryAnalyticsKey;

// Logging
extern NSUInteger const kGTIONetworkLogLevel;
extern NSUInteger const kGTIOLogLevel;

// RestKit Auth
extern NSString * const kGTIOHTTPAuthUsername;
extern NSString * const kGTIOHTTPAuthPassword;

// RestKit 
extern NSString * const kGTIOAcceptHeader;
extern NSString * const kGTIOAuthenticationHeaderKey;
extern NSString * const kGTIOTrackingHeaderKey;

// Notification Constants
extern NSString * const kGTIOLooksUpdated;
extern NSString * const kGTIOPostFeedOpenLinkNotification;
extern NSString * const kGTIODismissEllipsisPopOverViewNotification;
extern NSString * const kGTIONotificationCountNofitication;
extern NSString * const kGTIOChangeSelectedTabNotification;
extern NSString * const kGTIOAddTabBarToWindowNotification;
extern NSString * const kGTIOExploreLooksChangeResourcePathNotification;
extern NSString * const kGTIOTabBarViewsResize;
extern NSString * const kGTIOShowProfileUserNotification;

// Notification UserInfo
extern NSString * const kGTIOChangeSelectedTabToUserInfo;
extern NSString * const kGTIOResourcePathKey;
extern NSString * const kGTIOProfileUserIDUserInfo;

// UrbanAirship Constants
extern BOOL const kGTIOUAirshipAppStoreOrAdHocBuild;
extern NSString * const kGTIOUAirshipDevelopmentAppKey;
extern NSString * const kGTIOUAirshipDevelopmentAppSecret;
extern NSString * const kGTIOUAirshipProductionAppKey;
extern NSString * const kGTIOUAirshipProductionAppSecret;

// Push Notification Device Token
extern NSString * const kGTIOPushNotificationDeviceTokenUserDefaults;

// Notification Dictionary Constants
extern NSString * const kGTIOURL;

// Alert Constants
extern int const kGTIOEmptyPostAlertTag;
extern int const kGTIOEmptyDescriptionAlertTag;

// Button Name Constants
extern NSString * const kGTIOUserInfoButtonNameFollowing;
extern NSString * const kGTIOUserInfoButtonNameFollowers;
extern NSString * const kGTIOUserInfoButtonNameStars;
extern NSString * const kGTIOUserInfoButtonNameWebsite;
extern NSString * const kGTIOUserInfoButtonNameFollow;
extern NSString * const kGTIOUserInfoButtonNameBannerAd;
extern NSString * const kGTIOUserInfoButtonNameAcceptRelationship;
extern NSString * const kGTIOPostSideReviewsButton;
extern NSString * const kGTIOPostSideShopButton;
extern NSString * const kGTIOPostDotOptionButton;
extern NSString * const kGTIOSuggestedFriendsButtonName;
extern NSString * const kGTIOInviteFriendsButtonName;
extern NSString * const kGTIOFindFriendsButtonName;
extern NSString * const kGTIOReviewAgreeButton;
extern NSString * const kGTIOReviewFlagButton;
extern NSString * const kGTIOReviewRemoveButton;
extern NSString * const kGTIOProductWhoHeartedButton;
extern NSString * const kGTIOProductHeartButton;
extern NSString * const kGTIOProductShoppingListButton;

// Web Views
extern NSTimeInterval const kGTIOWebViewTimeout;

/** Dismiss handler
 */
typedef void(^GTIODismissHandler)(UIViewController *viewController);

// JSON Param Serialization Helper
id GTIOJSONParams(id obj);

// Generic Completion Handler
typedef void(^GTIOCompletionHandler)(NSArray *loadedObjects, NSError *error);
