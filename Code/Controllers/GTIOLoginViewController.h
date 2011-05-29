//
//  GTIOLoginViewController.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOLoginViewController is the view controller responsible for allowing a user to either sign in via facebook or via the JanRain other providers

@interface GTIOLoginViewController : UIViewController {}

/// Action for the facebook button
- (IBAction)facebookButtonWasPressed:(id)sender;
/// Action for the other providers button
- (IBAction)otherProvidersButtonWasPressed:(id)sender;

@end
