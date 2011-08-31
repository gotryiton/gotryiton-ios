//
//  GTIOSettingsViewController.h
//  GoTryItOn
//
//  Created by Blake Watters on 8/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOSettingsViewController is a subclass of [GTIOTableViewController](GTIOTableViewController) that shows the controls for user settings and a means to logout

#import "GTIOTableViewController.h"
#import "CustomUISwitch.h"
#import <TWTPickerControl.h>

@interface GTIOSettingsViewController : GTIOConcreteBackgroundTableViewController <TWTPickerDelegate, CustomUISwitchDelegate> {
    CustomUISwitch* _pushNotificationsSwitch;
    CustomUISwitch* _alertActivitySwitch;
    CustomUISwitch* _alertStylistActivitySwitch;
    CustomUISwitch* _alertStylistAddSwitch;
    CustomUISwitch* _alertNewsletterSwitch;
}

@end
