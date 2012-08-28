//
//  GTIOMappingProvider.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOMappingProvider.h"

#import "GTIOIntroScreen.h"
#import "GTIOConfig.h"
#import "GTIOVisit.h"
#import "GTIOTrack.h"
#import "GTIOUser.h"
#import "GTIOAuth.h"
#import "GTIOIcon.h"
#import "GTIOBadge.h"
#import "GTIOPhoto.h"
#import "GTIOPost.h"
#import "GTIOButtonAction.h"
#import "GTIOMyManagementScreen.h"
#import "GTIOAutoCompleter.h"
#import "GTIOPagination.h"
#import "GTIOButton.h"
#import "GTIOUserProfile.h"
#import "GTIOProfileCallout.h"
#import "GTIOFollowRequestAcceptBar.h"
#import "GTIOPostList.h"
#import "GTIOSuggestedFriendsIcon.h"
#import "GTIOFriendsManagementScreen.h"
#import "GTIOSearchBox.h"
#import "GTIOFollowingScreen.h"
#import "GTIOFollowersScreen.h"
#import "GTIOFindMyFriendsScreen.h"
#import "GTIOReview.h"
#import "GTIONotification.h"
#import "GTIOTab.h"
#import "GTIOProduct.h"
#import "GTIOHeart.h"
#import "GTIOHeartList.h"
#import "GTIOProductOption.h"
#import "GTIOCollection.h"
#import "GTIOBannerImage.h"
#import "GTIOTag.h"
#import "GTIORecentTag.h"
#import "GTIOTrendingTag.h"
#import "GTIOError.h"
#import "GTIOAlert.h"
#import "GTIOInvitation.h"

@implementation GTIOMappingProvider

- (id)init
{
    self = [super init];
    if (self) {
        
        RKObjectMapping *trackMapping = [RKObjectMapping mappingForClass:[GTIOTrack class]];
        RKObjectMapping *introScreenMapping = [RKObjectMapping mappingForClass:[GTIOIntroScreen class]];
        RKObjectMapping *configMapping = [RKObjectMapping mappingForClass:[GTIOConfig class]];
        RKObjectMapping *visitMapping = [RKObjectMapping mappingForClass:[GTIOVisit class]];
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[GTIOUser class]];
        RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[GTIOAuth class]];
        RKObjectMapping *userIconMapping = [RKObjectMapping mappingForClass:[GTIOIcon class]];
        RKObjectMapping *userPhotoMapping = [RKObjectMapping mappingForClass:[GTIOPhoto class]];
        RKObjectMapping *postMapping = [RKObjectMapping mappingForClass:[GTIOPost class]];
        RKObjectMapping *heartMapping = [RKObjectMapping mappingForClass:[GTIOHeart class]];
        RKObjectMapping *badgeMapping = [RKObjectMapping mappingForClass:[GTIOBadge class]];
        RKObjectMapping *buttonMapping = [RKObjectMapping mappingForClass:[GTIOButton class]];
        RKObjectMapping *buttonActionMapping = [RKObjectMapping mappingForClass:[GTIOButtonAction class]];
        RKObjectMapping *myManagementScreenMapping = [RKObjectMapping mappingForClass:[GTIOMyManagementScreen class]];
        RKObjectMapping *autocompleterMapping = [RKObjectMapping mappingForClass:[GTIOAutoCompleter class]];
        RKObjectMapping *userProfileMapping = [RKObjectMapping mappingForClass:[GTIOUserProfile class]];
        RKObjectMapping *profileCalloutMapping = [RKObjectMapping mappingForClass:[GTIOProfileCallout class]];
        RKObjectMapping *followRequestAcceptBarMapping = [RKObjectMapping mappingForClass:[GTIOFollowRequestAcceptBar class]];
        RKObjectMapping *postListMapping = [RKObjectMapping mappingForClass:[GTIOPostList class]];
        RKObjectMapping *heartListMapping = [RKObjectMapping mappingForClass:[GTIOHeartList class]];
        RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[GTIOPagination class]];
        RKObjectMapping *suggestedFriendIconMapping = [RKObjectMapping mappingForClass:[GTIOSuggestedFriendsIcon class]];
        RKObjectMapping *friendsManagementScreenMapping = [RKObjectMapping mappingForClass:[GTIOFriendsManagementScreen class]];
        RKObjectMapping *searchBoxMapping = [RKObjectMapping mappingForClass:[GTIOSearchBox class]];
        RKObjectMapping *followingScreenMapping = [RKObjectMapping mappingForClass:[GTIOFollowingScreen class]];
        RKObjectMapping *followersScreenMapping = [RKObjectMapping mappingForClass:[GTIOFollowersScreen class]];
        RKObjectMapping *findMyFriendsScreenMapping = [RKObjectMapping mappingForClass:[GTIOFindMyFriendsScreen class]];
        RKObjectMapping *reviewMapping = [RKObjectMapping mappingForClass:[GTIOReview class]];
        RKObjectMapping *notificationMapping = [RKObjectMapping mappingForClass:[GTIONotification class]];
        RKObjectMapping *tabMapping = [RKObjectMapping mappingForClass:[GTIOTab class]];
        RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[GTIOProduct class]];
        RKObjectMapping *productOptionMapping = [RKObjectMapping mappingForClass:[GTIOProductOption class]];
        RKObjectMapping *collectionMapping = [RKObjectMapping mappingForClass:[GTIOCollection class]];
        RKObjectMapping *bannerImageMapping = [RKObjectMapping mappingForClass:[GTIOBannerImage class]];
        RKObjectMapping *tagMapping = [RKObjectMapping mappingForClass:[GTIOTag class]];
        RKObjectMapping *recentTagMapping = [RKObjectMapping mappingForClass:[GTIORecentTag class]];
        RKObjectMapping *trendingTagMapping = [RKObjectMapping mappingForClass:[GTIOTrendingTag class]];
        RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[GTIOError class]];
        RKObjectMapping *alertMapping = [RKObjectMapping mappingForClass:[GTIOAlert class]];
        RKObjectMapping *invitationMapping = [RKObjectMapping mappingForClass:[GTIOInvitation class]];
        
        /** Products
         */
        
        // GTIOProduct
        [productMapping mapKeyPath:@"id" toAttribute:@"productID"];
        [productMapping mapKeyPath:@"name" toAttribute:@"productName"];
        [productMapping mapKeyPath:@"buy_url" toAttribute:@"buyURL"];
        [productMapping mapKeyPath:@"pretty_price" toAttribute:@"prettyPrice"];
        [productMapping mapKeyPath:@"action" toRelationship:@"action" withMapping:buttonActionMapping];
        [productMapping mapKeyPath:@"photo" toRelationship:@"photo" withMapping:userPhotoMapping];
        [productMapping mapKeyPath:@"brand" toAttribute:@"brand"];
        [productMapping mapKeyPath:@"buttons" toRelationship:@"buttons" withMapping:buttonMapping];
        [self setMapping:productMapping forKeyPath:@"product"];
        [self setMapping:productMapping forKeyPath:@"products"];
        
        // GTIOProductOption
        [productOptionMapping mapKeyPath:@"id" toAttribute:@"productOptionID"];
        [productOptionMapping mapKeyPath:@"photo" toRelationship:@"photo" withMapping:userPhotoMapping];
        [productOptionMapping mapKeyPath:@"action" toRelationship:@"action" withMapping:buttonActionMapping];
        [self setMapping:productOptionMapping forKeyPath:@"product_options"];
        
        // GTIOBannerImage
        [bannerImageMapping mapKeyPath:@"image" toAttribute:@"imageURL"];
        [bannerImageMapping mapKeyPath:@"width" toAttribute:@"width"];
        [bannerImageMapping mapKeyPath:@"height" toAttribute:@"height"];
        [bannerImageMapping mapKeyPath:@"action" toRelationship:@"action" withMapping:buttonActionMapping];
        
        // GTIOCollection
        [collectionMapping mapKeyPath:@"id" toAttribute:@"collectionID"];
        [collectionMapping mapKeyPath:@"name" toAttribute:@"name"];
        [collectionMapping mapKeyPath:@"banner_image" toRelationship:@"bannerImage" withMapping:bannerImageMapping];
        [collectionMapping mapKeyPath:@"custom_nav_image" toAttribute:@"customNavigationImageURL"];
        [collectionMapping mapKeyPath:@"options" toRelationship:@"dotOptions" withMapping:buttonMapping];
        [self setMapping:collectionMapping forKeyPath:@"collection"];
        
        /** Config
         */
        
        // GTIOIntroScreen
        [introScreenMapping mapKeyPath:@"id" toAttribute:@"introScreenID"];
        [introScreenMapping mapKeyPath:@"image_url" toAttribute:@"imageURL"];
        [introScreenMapping mapKeyPath:@"track" toRelationship:@"track" withMapping:trackMapping];
        
        // GTIOConfig
        [configMapping mapKeyPath:@"facebook_permissions_requested" toAttribute:@"facebookPermissions"];
        [configMapping mapKeyPath:@"facebook_share_default_on" toAttribute:@"facebookShareDefaultOn"];
        [configMapping mapKeyPath:@"voting_default_on" toAttribute:@"votingDefaultOn"];
        [configMapping mapKeyPath:@"photoshoot_first_timer" toAttribute:@"photoShootFirstTimer"];
        [configMapping mapKeyPath:@"photoshoot_second_timer" toAttribute:@"photoShootSecondTimer"];
        [configMapping mapKeyPath:@"photoshoot_third_timer" toAttribute:@"photoShootThirdTimer"];
        [configMapping mapKeyPath:@"intro_images" toRelationship:@"introScreens" withMapping:introScreenMapping];
        [self setMapping:configMapping forKeyPath:@"config"];
        
        /** Visit
         */
        
        // GTIOVisit
        [visitMapping mapKeyPath:@"ios_version" toAttribute:@"iOSVersion"];
        [visitMapping mapKeyPath:@"ios_device" toAttribute:@"iOSDevice"];
        [visitMapping mapKeyPath:@"build_version" toAttribute:@"buildVersion"];
        [visitMapping mapAttributes:@"latitude", @"longitude", nil];
        [self setMapping:visitMapping forKeyPath:@"visit"];
        
        RKObjectMapping *visitSerializationMapping = [visitMapping inverseMapping];
        [visitSerializationMapping setRootKeyPath:@"visit"];
        [self setSerializationMapping:visitSerializationMapping forClass:[GTIOVisit class]];
        
        /** Track
         */
        
        [trackMapping mapKeyPath:@"id" toAttribute:@"trackID"];
        [trackMapping mapKeyPath:@"page_number" toAttribute:@"pageNumber"];
        [trackMapping mapKeyPath:@"visit" toRelationship:@"visit" withMapping:visitMapping serialize:YES];
        [self setMapping:trackMapping forKeyPath:@"track"];
        
        RKObjectMapping *trackSerializationMapping = [trackMapping inverseMapping];
        [trackSerializationMapping setRootKeyPath:@"track"];
        [self setSerializationMapping:trackSerializationMapping forClass:[GTIOTrack class]];
        
        /** User
         */
        
        // GTIOUser
        [userMapping mapKeyPath:@"id" toAttribute:@"userID"];
        [userMapping mapKeyPath:@"born_in" toAttribute:@"birthYear"];
        [userMapping mapKeyPath:@"about" toAttribute:@"aboutMe"];
        [userMapping mapKeyPath:@"is_new_user" toAttribute:@"isNewUser"];
        [userMapping mapKeyPath:@"has_complete_profile" toAttribute:@"hasCompleteProfile"];
        [userMapping mapKeyPath:@"is_facebook_connected" toAttribute:@"isFacebookConnected"];
        [userMapping mapKeyPath:@"description" toAttribute:@"userDescription"];
        [userMapping mapAttributes:@"name", @"icon", @"location", @"city", @"state", @"gender", @"service", @"email", @"url", nil];
        [userMapping mapKeyPath:@"badge" toRelationship:@"badge" withMapping:badgeMapping];
        [userMapping mapKeyPath:@"button" toRelationship:@"button" withMapping:buttonMapping];
        [userMapping mapKeyPath:@"action" toRelationship:@"action" withMapping:buttonActionMapping];
        [self setMapping:userMapping forKeyPath:@"user"];
        [self setMapping:userMapping forKeyPath:@"users"];
        
        // User Icons
        [userIconMapping mapAttributes:@"name", @"url", @"width", @"height", nil];
        [self setMapping:userIconMapping forKeyPath:@"icons"];
        
        [badgeMapping mapAttributes:@"path", nil];
        [self setMapping:badgeMapping forKeyPath:@"badge"];
        
        // User Photo
        [userPhotoMapping mapKeyPath:@"id" toAttribute:@"photoID"];
        [userPhotoMapping mapKeyPath:@"user_id" toAttribute:@"userID"];
        [userPhotoMapping mapKeyPath:@"main_image" toAttribute:@"mainImageURL"];
        [userPhotoMapping mapKeyPath:@"small_thumbnail" toAttribute:@"smallThumbnailURL"];
        [userPhotoMapping mapKeyPath:@"square_thumbnail" toAttribute:@"squareThumbnailURL"];
        [userPhotoMapping mapKeyPath:@"star" toAttribute:@"isStarred"];
        [userPhotoMapping mapKeyPath:@"small_square_thumbnail" toAttribute:@"smallSquareThumbnailURL"];
        [userPhotoMapping mapAttributes:@"url", @"width", @"height", nil];
        [self setMapping:userPhotoMapping forKeyPath:@"photo"];
        
        // Profile callouts
        [profileCalloutMapping mapAttributes:@"icon", @"text", nil];
        
        // Post list
        [postListMapping mapKeyPath:@"posts" toRelationship:@"posts" withMapping:postMapping];
        [postListMapping mapKeyPath:@"pagination" toRelationship:@"pagination" withMapping:paginationMapping];

        // Hearts list
        [heartListMapping mapKeyPath:@"hearts" toRelationship:@"hearts" withMapping:heartMapping];
        [heartListMapping mapKeyPath:@"pagination" toRelationship:@"pagination" withMapping:paginationMapping];
        
        // GTIOHeart
        [heartMapping mapKeyPath:@"id" toAttribute:@"heartID"];
        [heartMapping mapKeyPath:@"post" toRelationship:@"post" withMapping:postMapping];
        [heartMapping mapKeyPath:@"product" toRelationship:@"product" withMapping:productMapping];
        
        // User Profile
        [userProfileMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [userProfileMapping mapKeyPath:@"ui-profile.buttons" toRelationship:@"userInfoButtons" withMapping:buttonMapping];
        [userProfileMapping mapKeyPath:@"ui-profile.profile_callouts" toRelationship:@"profileCallOuts" withMapping:profileCalloutMapping];
        [userProfileMapping mapKeyPath:@"ui-profile.settings.buttons" toRelationship:@"settingsButtons" withMapping:buttonMapping];
        [userProfileMapping mapKeyPath:@"ui-profile.accept_bar" toRelationship:@"acceptBar" withMapping:followRequestAcceptBarMapping];
        [userProfileMapping mapKeyPath:@"ui-profile.profile_locked" toAttribute:@"profileLocked"];
        [userProfileMapping mapKeyPath:@"posts_list" toRelationship:@"postsList" withMapping:postListMapping];
        [userProfileMapping mapKeyPath:@"hearts_list" toRelationship:@"heartsList" withMapping:heartListMapping];
        [self setMapping:userProfileMapping forKeyPath:@"userProfile"];
        
        // Follow request accept bar
        [followRequestAcceptBarMapping mapKeyPath:@"text" toAttribute:@"text"];
        [followRequestAcceptBarMapping mapKeyPath:@"buttons" toRelationship:@"buttons" withMapping:buttonMapping];
        
        /** Buttons
         */
        [suggestedFriendIconMapping mapKeyPath:@"icon" toAttribute:@"iconPath"];
        [buttonMapping mapKeyPath:@"icons" toRelationship:@"icons" withMapping:suggestedFriendIconMapping];
        [buttonActionMapping mapAttributes:@"destination", @"endpoint", @"spinner", nil];
        [buttonActionMapping mapKeyPath:@"twitter_url" toAttribute:@"twitterURL"];
        [buttonActionMapping mapKeyPath:@"twitter_text" toAttribute:@"twitterText"];
        [buttonMapping mapKeyPath:@"image" toAttribute:@"imageURL"];
        [buttonMapping mapKeyPath:@"type" toAttribute:@"buttonType"];
        [buttonMapping mapKeyPath:@"action" toRelationship:@"action" withMapping:buttonActionMapping];
        [buttonMapping mapAttributes:@"name", @"count", @"text", @"attribute", @"value", @"chevron", @"state", nil];
        [self setMapping:buttonMapping forKeyPath:@"buttons"];
        
        /** Screens
         */
        [myManagementScreenMapping mapKeyPath:@"user_info.buttons" toRelationship:@"userInfo" withMapping:buttonMapping];
        [myManagementScreenMapping mapKeyPath:@"management.buttons" toRelationship:@"management" withMapping:buttonMapping];
        [self setMapping:myManagementScreenMapping forKeyPath:@"ui-user-management"];
        
        [friendsManagementScreenMapping mapKeyPath:@"buttons" toRelationship:@"buttons" withMapping:buttonMapping];
        [friendsManagementScreenMapping mapKeyPath:@"search_box" toRelationship:@"searchBox" withMapping:searchBoxMapping];
        [self setMapping:friendsManagementScreenMapping forKeyPath:@"ui-friends-management"];
        
        [followingScreenMapping mapAttributes:@"title", @"subtitle", nil];
        [followingScreenMapping mapKeyPath:@"include_filter_search" toAttribute:@"includeFilterSearch"];
        [self setMapping:followingScreenMapping forKeyPath:@"ui-following"];
        
        [followersScreenMapping mapAttributes:@"title", @"subtitle", nil];
        [followersScreenMapping mapKeyPath:@"include_filter_search" toAttribute:@"includeFilterSearch"];
        [self setMapping:followersScreenMapping forKeyPath:@"ui-followers"];
        
        [findMyFriendsScreenMapping mapKeyPath:@"buttons" toRelationship:@"buttons" withMapping:buttonMapping];
        [findMyFriendsScreenMapping mapKeyPath:@"search_box" toRelationship:@"searchBox" withMapping:searchBoxMapping];
        [self setMapping:findMyFriendsScreenMapping forKeyPath:@"ui-friends"];
        
        /** Pagination
         */
        [paginationMapping mapKeyPath:@"previous_page" toAttribute:@"previousPage"];
        [paginationMapping mapKeyPath:@"next_page" toAttribute:@"nextPage"];
        [self setMapping:paginationMapping forKeyPath:@"pagination"];
        
        /** Search Box
         */
        [searchBoxMapping mapKeyPath:@"text" toAttribute:@"text"];
        
        /** Auth
         */
        
        // GTIOAuth
        [authMapping mapAttributes:@"token", nil];
        [self setMapping:authMapping forKeyPath:@"auth"];
        
        /** Post
         */
        
        // GTIOPost
        [postMapping mapKeyPath:@"id" toAttribute:@"postID"];
        [postMapping mapKeyPath:@"description" toAttribute:@"postDescription"];
        [postMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
        [postMapping mapKeyPath:@"created_when" toAttribute:@"createdWhen"];
        [postMapping mapKeyPath:@"who_hearted" toAttribute:@"whoHearted"];
        [postMapping mapKeyPath:@"action" toRelationship:@"action" withMapping:buttonActionMapping];
        [postMapping mapKeyPath:@"buttons" toRelationship:@"buttons" withMapping:buttonMapping];
        [postMapping mapKeyPath:@"dot_options.buttons" toRelationship:@"dotOptionsButtons" withMapping:buttonMapping];
        [postMapping mapKeyPath:@"brands.buttons" toRelationship:@"brandsButtons" withMapping:buttonMapping];
        [postMapping mapKeyPath:@"pagination" toRelationship:@"pagination" withMapping:paginationMapping];
        [postMapping mapKeyPath:@"photo" toRelationship:@"photo" withMapping:userPhotoMapping];
        [postMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [self setMapping:postMapping forKeyPath:@"post"];
        [self setMapping:postMapping forKeyPath:@"posts"];
        [self setMapping:postMapping forKeyPath:@"feed"];
        
        // GTIOTab
        [tabMapping mapAttributes:@"name", @"text", @"endpoint", @"selected", nil];
        [self setMapping:tabMapping forKeyPath:@"tabs"];
        
        /** Review
         */
        
        // GTIOReview
        [reviewMapping mapKeyPath:@"id" toAttribute:@"reviewID"];
        [reviewMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [reviewMapping mapKeyPath:@"text" toAttribute:@"text"];
        [reviewMapping mapKeyPath:@"created_when" toAttribute:@"createdWhen"];
        [reviewMapping mapKeyPath:@"buttons" toRelationship:@"buttons" withMapping:buttonMapping];
        [self setMapping:reviewMapping forKeyPath:@"reviews"];
        [self setMapping:reviewMapping forKeyPath:@"review"];
        
        /** Notifications
         */
        
        // GTIONotification
        [notificationMapping mapKeyPath:@"id" toAttribute:@"notificationID"];
        [notificationMapping mapAttributes:@"text", @"action", @"icon", nil];
        [self setMapping:notificationMapping forKeyPath:@"notifications"];

        // GTIOAutoCompleter
        [autocompleterMapping mapKeyPath:@"id" toAttribute:@"completerID"];
        [autocompleterMapping mapAttributes:@"name", @"icon", nil];
        [self setMapping:autocompleterMapping forKeyPath:@"dictionary"];
        
        /** Tags
         */
        [tagMapping mapAttributes:@"text", nil];
        [tagMapping mapKeyPath:@"icon" toAttribute:@"iconURL"];
        [tagMapping mapKeyPath:@"action" toRelationship:@"action" withMapping:buttonActionMapping];
        [self setMapping:tagMapping forKeyPath:@"search_result_tags"];
    
        // GTIORecentTag
        [recentTagMapping mapAttributes:@"text", nil];
        [recentTagMapping mapKeyPath:@"icon" toAttribute:@"iconURL"];
        [recentTagMapping mapKeyPath:@"action" toRelationship:@"action" withMapping:buttonActionMapping];
        [self setMapping:recentTagMapping forKeyPath:@"recent"];
    
        // GTIOTrendingTag
        [trendingTagMapping mapAttributes:@"text", nil];
        [trendingTagMapping mapKeyPath:@"icon" toAttribute:@"iconURL"];
        [trendingTagMapping mapKeyPath:@"action" toRelationship:@"action" withMapping:buttonActionMapping];
        [self setMapping:trendingTagMapping forKeyPath:@"trending"];
        
        /** Errors
         */
        
        // Alert
        [alertMapping mapAttributes:@"message", @"retry", @"title", nil];
        [alertMapping mapKeyPath:@"dim_screen" toAttribute:@"dimScreen"];
        [self setMapping:alertMapping forKeyPath:@"alert"];
        // Error
        [errorMapping mapAttributes:@"status", nil];
        [errorMapping mapKeyPath:@"alert" toRelationship:@"alert" withMapping:alertMapping];
        [errorMapping setRootKeyPath:@"error"];
        [self setErrorMapping:errorMapping];


        // GTIOInviation
        [invitationMapping mapAttributes:@"body", @"subject", nil];
        [invitationMapping mapKeyPath:@"twitter_url" toAttribute:@"twitterURL"];
        [invitationMapping mapKeyPath:@"id" toAttribute:@"invitationID"];
        [self setMapping:invitationMapping forKeyPath:@"invitation"];
    }
    return self;
}

@end


