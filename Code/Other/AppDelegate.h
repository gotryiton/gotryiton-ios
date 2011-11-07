//
//  AppDelegate.h
//  GTIO
//
//  Created by Blake Watters on 4/11/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOExternalURLHelper.h"
#import "GTIOMessageComposer.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, RKObjectLoaderDelegate> {
    NSURL* _launchURL;
	NSDate* _lastWentInactiveAt;
    BOOL _showStylistPush;
    GTIOExternalURLHelper* _externalURLHelper;
    GTIOMessageComposer* _messageComposer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
