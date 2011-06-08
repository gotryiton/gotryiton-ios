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
#import "GTIOUserMiniProfileHeaderView.h"

@interface GTIOHomeViewController : UIViewController {
    IBOutlet TTImageView* _profileThumbnailView;
    IBOutlet UIButton* _notificationsButton;
    IBOutlet UIButton* _notificationsBadgeButton;
    
    IBOutlet UIButton* _todoButton;
    IBOutlet UIButton* _todosBadgeButton;
    
    UILabel* _nameLabel;
    UILabel* _locationLabel;
    
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
