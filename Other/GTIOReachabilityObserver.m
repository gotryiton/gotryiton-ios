//
//  GTIOReachabilityObserver.m
//  GoTryItOn
//
//  Created by Blake Watters on 10/9/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOReachabilityObserver.h"

// Constants
NSString* const GTIOReachabilityStateChangedNotification = @"GTIOReachabilityStateChangedNotification";

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
#pragma unused (target, flags)
	// We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
	// in case someon uses the Reachablity object in a different thread.
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	GTIOReachabilityObserver* observer = (GTIOReachabilityObserver*) info;
	// Post a notification to notify the client that the network reachability changed.
	[[NSNotificationCenter defaultCenter] postNotificationName:GTIOReachabilityStateChangedNotification object:observer];
	
	[pool release];
}

#pragma mark -

@interface GTIOReachabilityObserver (Private)

// Internal initializer
- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef;
- (void)scheduleObserver;
- (void)unscheduleObserver;

@end

static GTIOReachabilityObserver* gSharedReachabilityObserver = nil;

@implementation GTIOReachabilityObserver

+ (GTIOReachabilityObserver*)sharedObserver {
	if (nil == gSharedReachabilityObserver) {
		NSURL* URL = [NSURL URLWithString:kGTIOBaseURLString];
		gSharedReachabilityObserver = [[GTIOReachabilityObserver reachabilityObserverWithHostName:URL.host] retain];
	}
	
	return gSharedReachabilityObserver;
}

+ (GTIOReachabilityObserver*)reachabilityObserverWithHostName:(NSString*)hostName {
	GTIOReachabilityObserver* observer = nil;
	SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	
	if (nil != reachabilityRef) {
		observer = [[[self alloc] initWithReachabilityRef:reachabilityRef] autorelease];
	}
	
	return observer;
}

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef {
	if (self = [self init]) {
		_reachabilityRef = reachabilityRef;
		[self scheduleObserver];
	}
	
	return self;
}

- (void)dealloc {
	[self unscheduleObserver];
	if (_reachabilityRef) {
		CFRelease(_reachabilityRef);
	}
	
	[super dealloc];
}

- (GTIOReachabilityNetworkStatus)networkStatus {
	NSAssert(_reachabilityRef != NULL, @"currentNetworkStatus called with NULL reachabilityRef");
	GTIOReachabilityNetworkStatus status = GTIOReachabilityNotReachable;
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {		
		if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
			// if target host is not reachable
			return GTIOReachabilityNotReachable;
		}
		
		if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
			// if target host is reachable and no connection is required
			//  then we'll assume (for now) that your on Wi-Fi
			status = GTIOReachabilityReachableViaWiFi;
		}
		
		
		if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
			 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
			// ... and the connection is on-demand (or on-traffic) if the
			//     calling application is using the CFSocketStream or higher APIs
			
			if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
				// ... and no [user] intervention is needed
				status = GTIOReachabilityReachableViaWiFi;
			}
		}
		
		if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
			// ... but WWAN connections are OK if the calling application
			//     is using the CFNetwork (CFSocketStream?) APIs.
			status = GTIOReachabilityReachableViaWWAN;
		}
	}
	
	return status;	
}

- (BOOL)isNetworkReachable {
	return (GTIOReachabilityNotReachable != [self networkStatus]);
}

- (BOOL)isConnectionRequired {
	NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
	}
	
	return NO;
}

#pragma mark Observer scheduling

- (void)scheduleObserver {
	SCNetworkReachabilityContext context = {0, self, NULL, NULL, NULL};
	if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context)) {
		if (NO == SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
			NSLog(@"Warning -- Unable to schedule reachability observer in current run loop.");
		}
	}
}

- (void)unscheduleObserver {
	if (nil != _reachabilityRef) {
		SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
}

@end
