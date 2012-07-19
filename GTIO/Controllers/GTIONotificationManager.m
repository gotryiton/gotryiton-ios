//
//  GTIONotificationManager.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIONotificationManager.h"

#import <RestKit/RestKit.h>

NSString * const kGTIONotificationUnreadCountUserInfo = @"kGTIONotificationUnreadCountUserInfo";

static NSString * const kGTIONotificationsUserDefaults = @"kGTIONotificationsUserDefaults";
static NSTimeInterval const kGTIOLoadNotificationsTimeDelta = 60.0f;

@interface GTIONotificationManager()

@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, strong) NSDate *lastUpdatedAt;

@end

@implementation GTIONotificationManager

@synthesize notifications = _notifications, lastUpdatedAt = _lastUpdatedAt;

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
        [self load];
        self.lastUpdatedAt = [NSDate date];
        
        // Load new notifications after delay
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self loadNotificationsIfNeeded];
        });
    }
    return self;
}

- (NSInteger)unreadNotificationCount
{
    NSInteger unreadNotificationCount = 0;
    
    for (GTIONotification *notification in self.notifications) {
        if (!notification.viewed.boolValue) {
            unreadNotificationCount++;
        }
    }
    
    return unreadNotificationCount;
}

#pragma mark - Loading and Saving

- (void)load
{
    self.notifications = [NSArray array];
    
    // Load from cache
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:kGTIONotificationsUserDefaults];
    if (data) {
        NSArray *notificationsArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (notificationsArray) {
            self.notifications = notificationsArray;
        }
    }
    
    [self broadcastNotificationCount];
}

- (void)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.notifications];

    if (data) {
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:kGTIONotificationsUserDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self broadcastNotificationCount];
}

#pragma mark - Load Data

- (void)loadNotificationsIfNeeded
{
    if ([[NSDate date] timeIntervalSinceDate:self.lastUpdatedAt] > kGTIOLoadNotificationsTimeDelta) {
        [self refreshNotificationsWithCompletionHandler:nil];
    }
}

- (void)refreshNotificationsWithCompletionHandler:(GTIONotificationsRefreshCompletionHandler)completionHandler
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/notifications" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            NSMutableArray *loadingArray = [NSMutableArray array];
            for (id object in objects) {
                if ([object isMemberOfClass:[GTIONotification class]]) {
                    GTIONotification *existingNotification = [self notificationForNotificationID:[object notificationID]];
                    if (existingNotification) {
                        [(GTIONotification *)object setViewed:existingNotification.viewed];
                    }
                    [loadingArray addObject:object];
                }
            }
            
            self.notifications = loadingArray;
            [self save];
            self.lastUpdatedAt = [NSDate date];
            
            if (completionHandler) {
                completionHandler([NSArray arrayWithArray:self.notifications], nil);
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
}

#pragma mark - Viewed
//
//- (void)notificationID:(NSNumber *)notificationID markAsViewed:(BOOL)viewed
//{
//    for (GTIONotification *notification in self.notifications) {
//        if ([notification.notificationID isEqualToNumber:notificationID]) {
//            notification.viewed = [NSNumber numberWithBool:viewed];
//        }
//    }
//    
//    [self save];
//}

#pragma mark - Helpers

- (void)broadcastNotificationCount
{
    // Post notification unread count
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[self unreadNotificationCount]] forKey:kGTIONotificationUnreadCountUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIONotificationCountNofitication object:self userInfo:userInfo];
}

- (GTIONotification *)notificationForNotificationID:(NSNumber *)notificationID
{
    for (GTIONotification *notification in self.notifications) {
        if ([notification.notificationID isEqualToNumber:notificationID]) {
            return notification;
        }
    }
    return nil;
}

@end
