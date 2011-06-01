//
//  GTIOHomeViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOHomeViewController is the principal top level view controller, that has icons to access all the major view controllers in the app 
/// also provides the ability to login/logout and 
///

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "GTIONotificationsOverlayViewController.h"

@interface GTIOHomeViewController : UIViewController {
    IBOutlet UIView* _launcherView;
    IBOutlet UIButton* _notificationsButton;
    IBOutlet UILabel* _usernameLabel;
    IBOutlet UIButton* _todoButton;
    
    GTIONotificationsOverlayViewController* _notificationsController;
}
/// My Stylists
- (IBAction)myStylistsButtonWasPressed;
/// Featured
- (IBAction)featuredButtonWasPressed;
/// My Looks
- (IBAction)myLooksButtonWasPressed;
/// Upload
- (IBAction)uploadButtonWasPressed;
/// To-Do's
- (IBAction)todosButtonWasPressed;
// Browse
- (IBAction)browseButtonWasPressed;
/// My Reviews
- (IBAction)myReviewsButtonWasPressed;
/// Notification
- (IBAction)notificationButtonWasPressed;
/// Profile
- (IBAction)profileViewWasTouched;

@end
