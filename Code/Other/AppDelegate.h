//
//  AppDelegate.h
//  GTIO
//
//  Created by Blake Watters on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate, RKObjectLoaderDelegate> {
    NSURL* _launchURL;
	NSDate* _lastWentInactiveAt;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
