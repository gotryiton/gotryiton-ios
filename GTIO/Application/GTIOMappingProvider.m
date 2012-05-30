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
#import "GTIOFacebookIcon.h"

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
        RKObjectMapping *facebookUserIconMapping = [RKObjectMapping mappingForClass:[GTIOFacebookIcon class]];
        
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
        [userMapping mapKeyPath:@"about_me" toAttribute:@"aboutMe"];
        [userMapping mapKeyPath:@"is_new_user" toAttribute:@"isNewUser"];
        [userMapping mapKeyPath:@"has_complete_profile" toAttribute:@"hasCompleteProfile"];
        [userMapping mapAttributes:@"name", @"icon", @"location", @"city", @"state", @"gender", @"service", @"email", @"url", nil];
        [self setMapping:userMapping forKeyPath:@"user"];
        
        /** Auth
         */
        
        // GTIOAuth
        [authMapping mapAttributes:@"token", nil];
        [self setMapping:authMapping forKeyPath:@"auth"];
        
        // User Icons
        [userIconMapping mapAttributes:@"url", @"width", @"height", nil];
        [facebookUserIconMapping mapAttributes:@"url", @"width", @"height", nil];
        [self setMapping:facebookUserIconMapping forKeyPath:@"facebook_icon"];
        [self setMapping:userIconMapping forKeyPath:@"outfit_icons"];
    }
    return self;
}

@end
