//
//  GTIONotificationManager.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIONotificationManager.h"

#import <RestKit/RestKit.h>

@interface GTIONotificationManager()

@property (nonatomic, strong) NSMutableArray *storedNotifications;

@end

@implementation GTIONotificationManager

@synthesize storedNotifications = _storedNotifications;

+ (GTIONotificationManager *)sharedManager
{
    static GTIONotificationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _storedNotifications = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.storedNotifications = [coder decodeObjectForKey:@"storedNotifications"];
    } 
    return self;
}

- (void)useNotifications:(NSArray *)notifications
{
    self.storedNotifications = [NSMutableArray arrayWithArray:notifications];
}

- (NSArray *)notifications
{
    return [NSArray arrayWithArray:self.storedNotifications];
}

- (GTIONotification *)notificationForNotificationID:(NSNumber *)notificationID
{
    for (GTIONotification *notification in self.storedNotifications) {
        if ([notification.notificationID isEqualToNumber:notificationID]) {
            return notification;
        }
    }
    return nil;
}

- (void)refreshNotificationsWithCompletionHandler:(GTIONotificationsRefreshCompletionHandler)completionHandler
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/notifications" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            NSMutableArray *loadingArray = [NSMutableArray array];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIONotification class]]) {
                    GTIONotification *existingNotification = [self notificationForNotificationID:[object notificationID]];
                    if (existingNotification) {
                        [(GTIONotification *)object setViewed:existingNotification.viewed];
                    }
                    [loadingArray addObject:object];
                }
            }
            [self.storedNotifications removeAllObjects];
            self.storedNotifications = loadingArray;
            if (completionHandler) {
                completionHandler([NSArray arrayWithArray:self.storedNotifications], nil);
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.storedNotifications forKey:@"storedNotifications"];
}

@end
