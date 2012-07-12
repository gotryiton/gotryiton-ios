//
//  GTIONotificationManager.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIONotification.h"

typedef void(^GTIONotificationsRefreshCompletionHandler)(NSArray *loadedNotifications, NSError *error);

@interface GTIONotificationManager : NSObject

+ (GTIONotificationManager *)sharedManager;

- (void)refreshNotificationsWithCompletionHandler:(GTIONotificationsRefreshCompletionHandler)completionHandler;

@end
