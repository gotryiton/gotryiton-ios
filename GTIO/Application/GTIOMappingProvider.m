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

@implementation GTIOMappingProvider

- (id)init
{
    self = [super init];
    if (self) {
        
        /** Config
         */
        
        RKObjectMapping *introScreenMapping = [RKObjectMapping mappingForClass:[GTIOIntroScreen class]];
        [introScreenMapping mapKeyPath:@"id" toAttribute:@"introScreenID"];
        [introScreenMapping mapKeyPath:@"image_url" toAttribute:@"imageURL"];
        [introScreenMapping mapAttributes:@"track", nil];
        
        RKObjectMapping *configMapping = [RKObjectMapping mappingForClass:[GTIOConfig class]];
        [configMapping mapKeyPath:@"intro_images" toRelationship:@"introScreens" withMapping:introScreenMapping];
        [self setMapping:configMapping forKeyPath:@"config"];
        
        /** Visit
         */
        
        RKObjectMapping *visitMapping = [RKObjectMapping mappingForClass:[GTIOVisit class]];
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
        
        RKObjectMapping *trackMapping = [RKObjectMapping mappingForClass:[GTIOTrack class]];
        [trackMapping mapKeyPath:@"id" toAttribute:@"trackID"];
        [trackMapping mapKeyPath:@"visit" toRelationship:@"visit" withMapping:visitMapping serialize:YES];
        [self setMapping:trackMapping forKeyPath:@"track"];
        
        RKObjectMapping *trackSerializationMapping = [trackMapping inverseMapping];
        [trackSerializationMapping setRootKeyPath:@"track"];
        [self setSerializationMapping:trackSerializationMapping forClass:[GTIOTrack class]];
        
        /** User
         */
        
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[GTIOUser class]];
        [userMapping mapKeyPath:@"id" toAttribute:@"userID"];
        [userMapping mapKeyPath:@"born_in" toAttribute:@"birthYear"];
        [userMapping mapKeyPath:@"about_me" toAttribute:@"aboutMe"];
        [userMapping mapKeyPath:@"is_new_user" toAttribute:@"isNewUser"];
        [userMapping mapKeyPath:@"has_complete_profile" toAttribute:@"hasCompleteProfile"];
        [userMapping mapAttributes:@"name", @"icon", @"location", @"city", @"state", @"gender", @"service", @"auth", nil];
        [self setMapping:userMapping forKeyPath:@"user"];
        
    }
    return self;
}

@end
