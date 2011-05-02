//
//  GTIOLauncherViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface GTIOLauncherViewController : UIViewController {
    IBOutlet UIView* _launcherView;
    IBOutlet UIButton* _notifications;
}

- (IBAction)myStylistsButtonWasPressed;
- (IBAction)featuredButtonWasPressed;
- (IBAction)myLooksButtonWasPressed;
- (IBAction)uploadButtonWasPressed;
- (IBAction)todosButtonWasPressed;
- (IBAction)browseButtonWasPressed;
- (IBAction)myReviewsButtonWasPressed;
- (IBAction)notificationButtonWasPressed;
- (IBAction)profileViewWasTouched;
- (IBAction)logoutButtonWasPressed;

@end
