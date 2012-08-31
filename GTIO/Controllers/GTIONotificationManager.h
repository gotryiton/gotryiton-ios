//
//  GTIONotificationManager.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIONotification.h"

extern NSString * const kGTIONotificationUnreadCountUserInfo;

typedef void(^GTIONotificationsRefreshCompletionHandler)(NSArray *loadedNotifications, NSError *error);

@interface GTIONotificationManager : NSObject

@property (nonatomic, strong, readonly) NSArray *notifications;

+ (GTIONotificationManager *)sharedManager;

- (void)save;

- (void)loadNotificationsIfNeeded;
- (void)refreshNotificationsWithCompletionHandler:(GTIONotificationsRefreshCompletionHandler)completionHandler;
- (NSInteger)unreadNotificationCount;
- (void)broadcastNotificationCount;
//- (void)notificationID:(NSNumber *)notificationID markAsViewed:(BOOL)viewed;

@end
