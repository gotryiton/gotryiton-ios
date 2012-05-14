//
//  GTIOUser.h
//  GTIO
//
//  Created by Scott Penrose on 5/11/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOUser : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *icon;
@property (nonatomic, strong) NSNumber *birthYear;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *aboutMe;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSNumber *auth;
@property (nonatomic, strong) NSNumber *isNewUser;
@property (nonatomic, strong) NSNumber *hasCompleteProfile;

@end
