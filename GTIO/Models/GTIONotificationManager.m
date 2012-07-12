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

- (void)refreshNotificationsWithCompletionHandler:(GTIONotificationsRefreshCompletionHandler)completionHandler
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/notifications" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [self.storedNotifications removeAllObjects];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIONotification class]]) {
                    [self.storedNotifications addObject:object];
                }
            }
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

@end
