//
//  GTIONotification.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIONotification.h"


@implementation GTIONotification

@synthesize text = _text;
@synthesize url = _url;
@synthesize notificationID = _notificationID;
@synthesize notificationIcon = _notificationIcon;

+ (RKObjectMapping*)notificationMapping {
    RKObjectMapping* notificationMapping = [RKObjectMapping mappingForClass:[GTIONotification class]];
    [notificationMapping mapAttributes:@"text", @"url", @"notificationIcon", nil];
    [notificationMapping mapKeyPath:@"id" toAttribute:@"notificationID"];
    return notificationMapping;
}

- (void)dealloc {
    [_text release];
    [_url release];
    [_notificationID release];
    [_notificationIcon release];
    [super dealloc];
}

@end
