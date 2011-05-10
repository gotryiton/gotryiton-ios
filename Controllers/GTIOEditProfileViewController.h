//
//  GTIOEditProfileViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/26/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Three20/Three20.h>
#import <TWTPickerControl.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GTIOEditProfileViewController : TTTableViewController <UITextFieldDelegate, TWTPickerDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, UITextViewDelegate> {
	UITextField* _emailField;
	UITextField* _firstNameField;
	UITextField* _lastInitialField;
	UITextField* _cityField;
	UITextField* _stateField;
	TWTPickerControl* _genderPicker;
	TWTPickerControl* _emailAlertSettingPicker;
	UITextView* _aboutMeTextView;
	
	CLLocationManager* _locationManager;
	MKReverseGeocoder* _reverseGeocoder;
	
	// This is to know if we are a new screen or editing.
	BOOL _isNew;
}

@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;

@end
