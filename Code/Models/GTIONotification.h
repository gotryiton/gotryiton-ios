//
//  GTIONotification.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/20/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIONotification represents a notification the user recieves
#import <Foundation/Foundation.h>


@interface GTIONotification : NSObject {
    NSString* _text;
    NSString* _url;
    NSNumber* _notificationID;
    NSString* _notificationIcon;
}
/// Text of the notification
@property (nonatomic, copy) NSString* text;
/// url associated with the notification
@property (nonatomic, retain) NSString* url;
/// notification unique identifier
@property (nonatomic, retain) NSNumber* notificationID;
// The Notification Icon for display
@property (nonatomic, copy) NSString* notificationIcon;

+ (RKObjectMapping*)notificationMapping;

@end
