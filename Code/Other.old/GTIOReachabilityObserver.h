//
//  GTIOReachabilityObserver.h
//  GoTryItOn
//
//  Created by Blake Watters on 10/9/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

/**
 * Posted when the network state has changed
 */
extern NSString* const GTIOReachabilityStateChangedNotification;

typedef enum {
	GTIOReachabilityNotReachable,
	GTIOReachabilityReachableViaWiFi,
	GTIOReachabilityReachableViaWWAN
} GTIOReachabilityNetworkStatus;

/**
 * Provides a notification based interface for monitoring changes
 * to network status
 */
@interface GTIOReachabilityObserver : NSObject {
	SCNetworkReachabilityRef _reachabilityRef;	
}

/**
 * Returns a shared reachability observer monitoring the Go Try It On base server
 */
+ (GTIOReachabilityObserver*)sharedObserver;

/**
 * Create a new reachability observer against a given hostname. The observer
 * will monitor the ability to reach the specified hostname and emit notifications
 * when its reachability status changes. 
 *
 * Note that the observer will be scheduled in the current run loop.
 */
+ (GTIOReachabilityObserver*)reachabilityObserverWithHostName:(NSString*)hostName;

/**
 * Returns the current network status
 */
- (GTIOReachabilityNetworkStatus)networkStatus;

/**
 * Returns YES when the Internet is reachable (via WiFi or WWAN)
 */
- (BOOL)isNetworkReachable;

/**
 * Returns YES when WWAN may be available, but not active until a connection has been established.
 */
- (BOOL)isConnectionRequired;

@end
