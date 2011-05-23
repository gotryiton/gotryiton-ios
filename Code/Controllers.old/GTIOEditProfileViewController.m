//
//  GTIOEditProfileViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/26/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOEditProfileViewController.h"
#import "GTIOUser.h"
#import <Three20UI/Three20UI+Additions.h>
#import <Three20Core/Three20Core+Additions.h>
#import "GTIOUpdateUserRequest.h"
#import "GTIOControlTableViewVarHeightDelegate.h"
#import "GTIOBarButtonItem.h"
@implementation GTIOEditProfileViewController

@synthesize reverseGeocoder = _reverseGeocoder;

- (id)init {
	if (self = [super init]) {
		self.tableViewStyle = UITableViewStyleGrouped;
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(invalidateModel) 
													 name:kGTIOUserDidUpdateProfileNotificationName 
												   object:nil];
        [self.view setAccessibilityLabel:@"edit profile"];
	}
	
	return self;
}

- (id)initWithNewProfile {
	if (self = [self init]) {
		_isNew = YES;
	}
	
	return self;
}

- (id)initWithEditProfile {
	if (self = [self init]) {
		_isNew = NO;
	}
	
	return self;
}

- (void)startGeocodingIfNecessary {
	if ([[GTIOUser currentUser].state isWhitespaceAndNewlines] ||
		[GTIOUser currentUser].state == nil ||
		[[GTIOUser currentUser].state isWhitespaceAndNewlines] ||
		[GTIOUser currentUser].state == nil &&
		_locationManager == nil) {
		_locationManager = [[CLLocationManager alloc] init];
		if ([_locationManager respondsToSelector:@selector(setPurpose:)]) {
			_locationManager.purpose = @"To auto-fill your city and state";
		}
		_locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
		_locationManager.delegate = self;
		[_locationManager startUpdatingLocation];
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_locationManager stopUpdatingLocation];
	TT_RELEASE_SAFELY(_locationManager);
	TT_RELEASE_SAFELY(_genderPicker);
	TT_RELEASE_SAFELY(_emailAlertSettingPicker);
	[_reverseGeocoder cancel];
	TT_RELEASE_SAFELY(_reverseGeocoder);

	[super dealloc];
}

- (void)createModel {
	TT_RELEASE_SAFELY(_genderPicker);
	TT_RELEASE_SAFELY(_emailAlertSettingPicker);
	
	GTIOUser* user = [GTIOUser currentUser];
	
	_emailField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
	_emailField.placeholder = @"user@domain.com ";
	_emailField.textAlignment = UITextAlignmentRight;
	_emailField.textColor = TTSTYLEVAR(greyTextColor);
	_emailField.font = [UIFont systemFontOfSize:14];
	_emailField.text = user.email;
	_emailField.delegate = self;
	_emailField.keyboardType = UIKeyboardTypeEmailAddress;
	_emailField.returnKeyType = UIReturnKeyNext;
	
	_firstNameField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
	_firstNameField.placeholder = @"First Name ";
	_firstNameField.textAlignment = UITextAlignmentRight;
	_firstNameField.textColor = TTSTYLEVAR(greyTextColor);
	_firstNameField.font = [UIFont systemFontOfSize:14];
	_firstNameField.text = user.firstName;
	_firstNameField.delegate = self;
	_firstNameField.returnKeyType = UIReturnKeyNext;
	
	_lastInitialField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
	_lastInitialField.placeholder = @"Last Initial ";
	_lastInitialField.textAlignment = UITextAlignmentRight;
	_lastInitialField.textColor = TTSTYLEVAR(greyTextColor);
	_lastInitialField.font = [UIFont systemFontOfSize:14];
	_lastInitialField.text = user.lastInitial;
	_lastInitialField.delegate = self;
	_lastInitialField.returnKeyType = UIReturnKeyNext;
	
	_cityField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
	_cityField.placeholder = @"City ";
	_cityField.textAlignment = UITextAlignmentRight;
	_cityField.textColor = TTSTYLEVAR(greyTextColor);
	_cityField.font = [UIFont systemFontOfSize:14];
	_cityField.text = user.city;
	_cityField.delegate = self;
	_cityField.returnKeyType = UIReturnKeyNext;
	
	_stateField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
	_stateField.placeholder = @"State ";
	_stateField.textAlignment = UITextAlignmentRight;
	_stateField.textColor = TTSTYLEVAR(greyTextColor);
	_stateField.font = [UIFont systemFontOfSize:14];
	_stateField.text = user.state;
	_stateField.delegate = self;
	_stateField.returnKeyType = UIReturnKeyNext;
	[_stateField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
	
	NSArray* component = [NSArray arrayWithObjects:@"F", @"M", nil];
	_genderPicker = [[TWTPickerControl alloc] initWithFrame:CGRectMake(0, 0, 213, 30)];
	_genderPicker.dataSource = [[TWTPickerDataSource alloc ] initWithRows:component];
	_genderPicker.textLabel.textAlignment = UITextAlignmentRight;
	_genderPicker.textLabel.textColor = TTSTYLEVAR(pinkColor);
	_genderPicker.font = [UIFont boldSystemFontOfSize:14];
	_genderPicker.delegate = self;
	_genderPicker.placeholderText = @"select option";
	_genderPicker.toolbar.tintColor = TTSTYLEVAR(navigationBarTintColor);
	[_genderPicker updateToolbar];
	_genderPicker.doneButton.title = @"done";
	_genderPicker.nextButton.title = @"next";
	if (user.gender && ![user.gender isWhitespaceAndNewlines] && [component containsObject:user.gender]) {
		int index = [component indexOfObject:user.gender];
		_genderPicker.selection = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:index]];
	}
	
	_emailAlertSettingPicker = [emailPickerForUser(user) retain];
	_emailAlertSettingPicker.delegate = self;
	
	_aboutMeTextView = [[[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, 100 + 30)] autorelease];
	_aboutMeTextView.text = user.aboutMe;
	_aboutMeTextView.textColor = [UIColor grayColor];
	_aboutMeTextView.font = [UIFont systemFontOfSize:14];
	_aboutMeTextView.delegate = self;
	
	if (!_isNew) {
		self.dataSource = [TTListDataSource dataSourceWithObjects:
						   [TTTableControlItem itemWithCaption:@"email:" control:_emailField],
						   [TTTableControlItem itemWithCaption:@"first name:" control:_firstNameField],
						   [TTTableControlItem itemWithCaption:@"last initial:" control:_lastInitialField],
						   [TTTableControlItem itemWithCaption:@"email alerts:" control:_emailAlertSettingPicker],
						   [TTTableControlItem itemWithCaption:@"city:" control:_cityField],
						   [TTTableControlItem itemWithCaption:@"state:" control:_stateField],
						   [TTTableControlItem itemWithCaption:@"gender:" control:_genderPicker],
						   [TTTableControlItem itemWithCaption:@"about me:" control:(UIControl*)_aboutMeTextView],
						   nil];
	} else {
		[_genderPicker.toolbar setItems:[NSArray arrayWithObjects:
										 _genderPicker.doneButton,
										 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
										 _genderPicker.titleView,
										 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
										 nil]];
		self.dataSource = [TTListDataSource dataSourceWithObjects:
						   [TTTableControlItem itemWithCaption:@"email:" control:_emailField],
						   [TTTableControlItem itemWithCaption:@"first name:" control:_firstNameField],
						   [TTTableControlItem itemWithCaption:@"last initial:" control:_lastInitialField],
						   [TTTableControlItem itemWithCaption:@"city:" control:_cityField],
						   [TTTableControlItem itemWithCaption:@"state:" control:_stateField],
						   [TTTableControlItem itemWithCaption:@"gender:" control:_genderPicker],
						   nil];
		_aboutMeTextView = nil;
	}
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[GTIOControlTableViewVarHeightDelegate alloc] initWithController:self] autorelease];
}

- (void)loadView {
	self.tableViewStyle = UITableViewStyleGrouped;
	[super loadView];
	
	self.variableHeightRows = YES;
	self.autoresizesForKeyboard = YES;
	
	// Background
	UIImageView* bgImage = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(modalBackgroundImage)] autorelease];
	bgImage.frame = CGRectOffset(TTScreenBounds(), 0, -20 - 44);
	[self.view insertSubview:bgImage atIndex:0];
	self.tableView.backgroundColor = [UIColor clearColor];
	
	if (_isNew) {
		UILabel* headerView = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
		headerView.text = @"almost done!";
		headerView.backgroundColor = [UIColor clearColor];
		headerView.textColor = TTSTYLEVAR(greyTextColor);
		headerView.font = [UIFont boldSystemFontOfSize:14];
		headerView.textAlignment = UITextAlignmentCenter;
		self.tableView.tableHeaderView = headerView;
		self.tableView.sectionHeaderHeight = 0;
	} else {
        GTIOBarButtonItem* cancelButton = [[GTIOBarButtonItem alloc] initWithTitle:@"cancel" target:self action:@selector(cancelButtonWasPressed:)];
		self.navigationItem.leftBarButtonItem = cancelButton;
        [cancelButton release];
	}

	GTIOBarButtonItem* goButton = [[GTIOBarButtonItem alloc] initWithTitle:@"save" target:self action:@selector(goButtonWasPressed:)];
	self.navigationItem.rightBarButtonItem = goButton;
    [goButton release];
	
	// Title Image
	UIImage* titleImage = nil;
	if (_isNew) {
		titleImage = TTSTYLEVAR(newProfileHeaderImage);
	} else {
		titleImage = TTSTYLEVAR(editProfileHeaderImage);
	}
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:titleImage] autorelease];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self startGeocodingIfNecessary];
}

- (void)picker:(TWTPickerControl*)picker nextButtonWasTouched:(NSString*)choice {
	[[(TTListDataSource*)self.dataSource nextSiblingControlToControl:picker] becomeFirstResponder];
	[self.tableView scrollFirstResponderIntoView];
}

- (void)picker:(TWTPickerControl*)picker didShowPicker:(UIView*)pickerView {
	[UIView beginAnimations:nil context:nil];
	self.tableView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - pickerView.bounds.size.height);
	[UIView commitAnimations];
	[self.tableView scrollFirstResponderIntoView];
}

- (void)picker:(TWTPickerControl*)picker willHidePicker:(UIView*)pickerView {
	[UIView beginAnimations:nil context:nil];
	self.tableView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSInteger insertDelta = string.length - range.length;
	if (_lastInitialField == textField) {
        if (textField.text.length + insertDelta > 1) {
			return NO;
        }
	}
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[[(TTListDataSource*)self.dataSource nextSiblingControlToControl:textField] becomeFirstResponder];
	[self.tableView scrollFirstResponderIntoView];
	return NO;
}

- (void)showLoading {
	TTActivityLabel* label = [[[TTActivityLabel alloc] initWithFrame:TTScreenBounds() style:TTActivityLabelStyleBlackBox text:@"loading..."] autorelease];
	label.tag = 9999;
	[[TTNavigator navigator].window addSubview:label];
}

- (void)hideLoading {
	[[[TTNavigator navigator].window viewWithTag:9999] removeFromSuperview];
}

- (void)dismissKeyboard {
	TTListDataSource* dataSource = (TTListDataSource*) self.dataSource;
	for (TTTableControlItem* item in dataSource.items) {
		if ([item isKindOfClass:[TTTableControlItem class]]) {
			[[(TTTableControlItem*)item control] resignFirstResponder];
		}
	}
}

- (void)goButtonWasPressed:(id)sender {
	// TODO: This validation should NOT occur in the controller.
	// if _emailField, first name, lst name, city, state, or gender are blank, throw error.
	NSMutableArray* errors = [NSMutableArray array];
	if (_emailField.text == nil ||
		[_emailField.text isWhitespaceAndNewlines]) {
		[errors addObject:@"Email Address is required"];
	}
	if (_firstNameField.text == nil ||
		[_firstNameField.text isWhitespaceAndNewlines]) {
		[errors addObject:@"First Name is required"];
	}
	if (_lastInitialField.text == nil ||
		[_lastInitialField.text isWhitespaceAndNewlines]) {
		[errors addObject:@"Last Initial is required"];
	}
	if (_cityField.text == nil ||
		[_cityField.text isWhitespaceAndNewlines]) {
		[errors addObject:@"City is required"];
	}
	if (_stateField.text == nil ||
		[_stateField.text isWhitespaceAndNewlines]) {
		[errors addObject:@"State is required"];
	}
	NSString* gender = nil;
	if ([_genderPicker.textLabel.text isEqualToString:@"M"]) {
		gender = @"male";
	} else if ([_genderPicker.textLabel.text isEqualToString:@"F"]) {
		gender = @"female";
	}
	if (![gender isEqualToString:@"male"] &&
		![gender isEqualToString:@"female"]) {
		[errors addObject:@"Gender is required"];
	}
	if ([errors count] > 0) {
		TTAlert([errors componentsJoinedByString:@"\n"]);
		return;
	}
	
	GTIOUser* user = [GTIOUser currentUser];
	
	// update properties
	user.username = [NSString stringWithFormat:@"%@ %@", _firstNameField.text, _lastInitialField.text];
	user.email = _emailField.text;
	user.city = _cityField.text;
	user.state = _stateField.text;
	user.gender = _genderPicker.textLabel.text;
	user.emailAlertSetting = emailPickerChoiceAsNumber(_emailAlertSettingPicker);
	user.aboutMe = _aboutMeTextView.text;
	
	[[GTIOUpdateUserRequest updateUser:user delegate:self selector:@selector(updateFinished:)] retain];
	[self dismissKeyboard];
	[self showLoading];
}

- (void)updateFinished:(GTIOUpdateUserRequest*)updateRequest {
	[updateRequest autorelease];
	[self hideLoading];
	
	TTURLRequest* request = updateRequest.request;
	TTURLDataResponse* response = request.response;
	
	if (updateRequest.error) {
		TTAlert([updateRequest.error localizedDescription]);
		return;
	}
	
	NSString* body = [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary* json = (NSDictionary*)[[[SBJsonParser new] autorelease] objectWithString:body];
	
	if ([[json objectForKey:@"response"] isEqualToString:@"error"]) {
		NSString* error = [json objectForKey:@"error"];
		if ([error isKindOfClass:[NSNull class]]) {
			TTAlert(@"Unknown Error");
		} else {
			TTAlert(error);
		}
		return;
	}
	
	[[GTIOUser currentUser] digestProfileInfo:json];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)cancelButtonWasPressed:(id)sender {
	[self dismissKeyboard];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[manager stopUpdatingLocation];
	[_reverseGeocoder cancel];
	self.reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
	_reverseGeocoder.delegate = self;
	[_reverseGeocoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	if ([_cityField.text isWhitespaceAndNewlines] ||
		_cityField.text == nil) {
		_cityField.text = placemark.locality;
	}
	if ([_stateField.text isWhitespaceAndNewlines] ||
		_stateField.text == nil) {
		_stateField.text = placemark.administrativeArea;
	}
	
	self.reverseGeocoder = nil;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	self.reverseGeocoder = nil;
}

#pragma mark UITextViewDelegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {	
	// Enforce maximum length for fields
	// New length is the current length of the text, plus the length of the replacement text, minus any characters being replaced
	NSInteger newTextLength = [textView.text length] + [text length] - range.length;
	NSInteger maxLength = 240;
	
	return newTextLength <= maxLength;
}

@end
