//
//  GTIOEditProfileViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/26/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOEditProfileViewController is a subclass of TTTableViewController that allows the user to change their profile data

#import <Three20/Three20.h>
#import <TWTPickerControl.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CustomUISwitch.h"
#import "GTIOTableViewController.h"
#import "GTIOPlaceholderTextField.h"

@interface GTIOEditProfileViewController : GTIOTableViewController <UITextFieldDelegate, TWTPickerDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, UITextViewDelegate> {
	GTIOPlaceholderTextField* _emailField;
	GTIOPlaceholderTextField* _firstNameField;
	GTIOPlaceholderTextField* _lastInitialField;
	GTIOPlaceholderTextField* _cityField;
	GTIOPlaceholderTextField* _stateField;
	TWTPickerControl* _genderPicker;
    TWTPickerControl* _bornInPicker;
    CustomUISwitch* _useFacebookProfileIconSwitch;
	GTIOPlaceholderTextView* _aboutMeTextView;
	
	CLLocationManager* _locationManager;
	MKReverseGeocoder* _reverseGeocoder;
	
	// This is to know if we are a new screen or editing.
	BOOL _isNew;
}
/// the reverse geocoder handler
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;

@end
