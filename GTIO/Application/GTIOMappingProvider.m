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
#import "GTIOPagination.h"
#import "GTIOButton.h"
#import "GTIOUserProfile.h"
#import "GTIOProfileCallout.h"
#import "GTIOFollowRequestAcceptBar.h"
#import "GTIOPostList.h"

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
        RKObjectMapping *badgeMapping = [RKObjectMapping mappingForClass:[GTIOBadge class]];
        RKObjectMapping *buttonMapping = [RKObjectMapping mappingForClass:[GTIOButton class]];
        RKObjectMapping *buttonActionMapping = [RKObjectMapping mappingForClass:[GTIOButtonAction class]];
        RKObjectMapping *myManagementScreenMapping = [RKObjectMapping mappingForClass:[GTIOMyManagementScreen class]];
        RKObjectMapping *userProfileMapping = [RKObjectMapping mappingForClass:[GTIOUserProfile class]];
        RKObjectMapping *profileCalloutMapping = [RKObjectMapping mappingForClass:[GTIOProfileCallout class]];
        RKObjectMapping *followRequestAcceptBarMapping = [RKObjectMapping mappingForClass:[GTIOFollowRequestAcceptBar class]];
        RKObjectMapping *postListMapping = [RKObjectMapping mappingForClass:[GTIOPostList class]];
        RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[GTIOPagination class]];
        
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
        [userPhotoMapping mapAttributes:@"url", @"width", @"height", nil];
        [self setMapping:userPhotoMapping forKeyPath:@"photo"];
        
        // Profile callouts
        [profileCalloutMapping mapAttributes:@"icon", @"text", nil];
        
        // Post list
        [postListMapping mapKeyPath:@"posts" toRelationship:@"posts" withMapping:postMapping];
        [postListMapping mapKeyPath:@"pagination" toRelationship:@"pagination" withMapping:paginationMapping];
        
        // User Profile
        [userProfileMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
        [userProfileMapping mapKeyPath:@"ui.buttons" toRelationship:@"userInfoButtons" withMapping:buttonMapping];
        [userProfileMapping mapKeyPath:@"ui.profile_callouts" toRelationship:@"profileCallOuts" withMapping:profileCalloutMapping];
        [userProfileMapping mapKeyPath:@"ui.settings.buttons" toRelationship:@"settingsButtons" withMapping:buttonMapping];
        [userProfileMapping mapKeyPath:@"ui.accept_bar" toRelationship:@"acceptBar" withMapping:followRequestAcceptBarMapping];
        [userProfileMapping mapKeyPath:@"posts_list" toRelationship:@"postsList" withMapping:postListMapping];
        [userProfileMapping mapKeyPath:@"hearts_list" toRelationship:@"heartsList" withMapping:postListMapping];
        [self setMapping:userProfileMapping forKeyPath:@"userProfile"];
        
        // Follow request accept bar
        [followRequestAcceptBarMapping mapKeyPath:@"text" toAttribute:@"text"];
        [followRequestAcceptBarMapping mapKeyPath:@"buttons" toRelationship:@"buttons" withMapping:buttonMapping];
        
        /** Buttons
         */
        [buttonActionMapping mapAttributes:@"destination", @"endpoint", @"spinner", nil];
        [buttonMapping mapKeyPath:@"image" toAttribute:@"imageURL"];
        [buttonMapping mapKeyPath:@"action" toRelationship:@"action" withMapping:buttonActionMapping];
        [buttonMapping mapAttributes:@"name", @"count", @"text", @"attribute", @"value", @"chevron", @"state", nil];
        
        /** Screens
         */
        [myManagementScreenMapping mapKeyPath:@"user_info.buttons" toRelationship:@"userInfo" withMapping:buttonMapping];
        [myManagementScreenMapping mapKeyPath:@"management.buttons" toRelationship:@"management" withMapping:buttonMapping];
        [self setMapping:myManagementScreenMapping forKeyPath:@"ui"];
        
        /** Pagination
         */
        [paginationMapping mapKeyPath:@"previous_page" toAttribute:@"previousPage"];
        [paginationMapping mapKeyPath:@"next_page" toAttribute:@"nextPage"];
        [self setMapping:paginationMapping forKeyPath:@"pagination"];
        
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
        [postMapping mapKeyPath:@"star" toAttribute:@"stared"];
        [postMapping mapKeyPath:@"buttons" toRelationship:@"buttons" withMapping:buttonMapping];
        [postMapping mapKeyPath:@"dot_options.buttons" toRelationship:@"dotOptionsButtons" withMapping:buttonMapping];
        [postMapping mapKeyPath:@"who_hearted.buttons" toRelationship:@"whoHeartedButtons" withMapping:buttonMapping];
        [postMapping mapKeyPath:@"brands.buttons" toRelationship:@"brandsButtons" withMapping:buttonMapping];
        [postMapping mapKeyPath:@"pagination" toRelationship:@"pagination" withMapping:paginationMapping];
        [postMapping mapKeyPath:@"photo" toRelationship:@"photo" withMapping:userPhotoMapping];
        [postMapping mapRelationship:@"user" withMapping:userMapping];
        [self setMapping:postMapping forKeyPath:@"post"];
        [self setMapping:postMapping forKeyPath:@"feed"];
    }
    return self;
}

@end
