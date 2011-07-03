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
#import "GTIOHeaderView.h"

@interface GTIOEditProfileTableImageItem : TTTableImageItem
@end
@implementation GTIOEditProfileTableImageItem
@end

@interface GTIOEditProfileTableImageItemCell : TTTableImageItemCell {
    UIImageView* _overlayImageView;
}
@end

@implementation GTIOEditProfileTableImageItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 70;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
        _overlayImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-overlay-110.png"]] autorelease];
        [self.contentView addSubview:_overlayImageView];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView2.defaultImage = [UIImage imageNamed:@"empty-profile-pic.png"];
    _imageView2.frame = CGRectMake(10,10,50,50);
    _overlayImageView.frame = CGRectMake(7,7,56,56);
    self.textLabel.frame = CGRectMake(70,47,150,15);
}

@end

@interface GTIOProfileImageTableControlItem : TTTableControlItem {
    NSString* _imageURL;
}
@property (nonatomic, readonly) NSString* imageURL;
+ (id)itemWithCaption:(NSString*)caption imageURL:(NSString*)imageURL control:(UIControl*)control;
@end

@implementation GTIOProfileImageTableControlItem

@synthesize imageURL = _imageURL;

- (id)initWithCaption:(NSString*)caption imageURL:(NSString*)imageURL control:(UIControl*)control {
    if ((self = [super init])) {
        self.caption = caption;
        self.control = control;
        _imageURL = [imageURL copy];
    }
    return self;
}

+ (id)itemWithCaption:(NSString*)caption imageURL:(NSString*)imageURL control:(UIControl*)control {
    return [[[self alloc] initWithCaption:caption imageURL:imageURL control:control] autorelease];
}

- (void)dealloc {
    [_imageURL release];
    [super dealloc];
}

@end

@interface GTIOProfileImageTableControlItemCell : TTTableControlCell {
    TTImageView* _profileImageView;
    UIImageView* _overlayImageView;
}
@end

@implementation GTIOProfileImageTableControlItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 70;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
        _profileImageView = [[[TTImageView alloc] initWithFrame:CGRectZero] autorelease];
        [self.contentView addSubview:_profileImageView];
        
        _overlayImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-overlay-110.png"]] autorelease];
        [self.contentView addSubview:_overlayImageView];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _profileImageView.frame = CGRectMake(10,10,50,50);
    _overlayImageView.frame = CGRectMake(7,7,56,56);
    self.textLabel.numberOfLines = 2;
    self.textLabel.frame = CGRectMake(70,25,110,40);
    _control.frame = CGRectOffset(_control.frame, 0, 13);
}

- (void)setObject:(id)object {
    [super setObject:object];
    if (object) {
        GTIOProfileImageTableControlItem* item = (GTIOProfileImageTableControlItem*)object;
        _profileImageView.urlPath = item.imageURL;
    }
}

@end

@interface GTIOEditProfileListDataSource : TTListDataSource
@end
@implementation GTIOEditProfileListDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[GTIOEditProfileTableImageItem class]]) {
        return [GTIOEditProfileTableImageItemCell class];
    } else if ([object isKindOfClass:[GTIOProfileImageTableControlItem class]]) {
        return [GTIOProfileImageTableControlItemCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}

@end


@implementation GTIOEditProfileViewController

@synthesize reverseGeocoder = _reverseGeocoder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.tableViewStyle = UITableViewStyleGrouped;
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(invalidateModel) 
													 name:kGTIOUserDidUpdateProfileNotificationName 
												   object:nil];
        _isNew = [[GTIOUser currentUser].showAlmostDoneScreen boolValue];
        //[self.view setAccessibilityLabel:@"edit profile"];
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
	[_reverseGeocoder cancel];
	TT_RELEASE_SAFELY(_reverseGeocoder);
    TT_RELEASE_SAFELY(_bornInPicker);
    TT_RELEASE_SAFELY(_useFacebookProfileIconSwitch);

	[super dealloc];
}

- (void)createModel {
	TT_RELEASE_SAFELY(_genderPicker);
	
	GTIOUser* user = [GTIOUser currentUser];
	
    [_useFacebookProfileIconSwitch release];
    _useFacebookProfileIconSwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
	_useFacebookProfileIconSwitch.on = YES;
    
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
    _firstNameField.accessibilityLabel = @"first name field";
	
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
    [_genderPicker release];
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
    
    NSMutableArray* years = [NSMutableArray array];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents* dateComponents = [currentCalendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    int year = [dateComponents year];
    for (int i = year - 13;i >= year-100;i--) {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [_bornInPicker release];
    _bornInPicker = [[TWTPickerControl alloc] initWithFrame:CGRectMake(0, 0, 213, 30)];
	_bornInPicker.dataSource = [[TWTPickerDataSource alloc ] initWithRows:years];
	_bornInPicker.textLabel.textAlignment = UITextAlignmentRight;
	_bornInPicker.textLabel.textColor = TTSTYLEVAR(pinkColor);
	_bornInPicker.font = [UIFont boldSystemFontOfSize:14];
	_bornInPicker.delegate = self;
	_bornInPicker.placeholderText = @"select year";
	_bornInPicker.toolbar.tintColor = TTSTYLEVAR(navigationBarTintColor);
	[_bornInPicker updateToolbar];
	_bornInPicker.doneButton.title = @"done";
	_bornInPicker.nextButton.title = @"next";
    NSString* bornInString = [NSString stringWithFormat:@"%d", [user.bornIn intValue]];
	if ([years containsObject:bornInString]) {
		int index = [years indexOfObject:bornInString];
		_bornInPicker.selection = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:index]];
	}

        
	
	_aboutMeTextView = [[[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, 100 + 30)] autorelease];
	_aboutMeTextView.text = user.aboutMe;
	_aboutMeTextView.textColor = [UIColor grayColor];
	_aboutMeTextView.font = [UIFont systemFontOfSize:14];
	_aboutMeTextView.delegate = self;
	
	if (!_isNew) {
        NSString* name = [user.username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* location = [user.location stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([location length] == 0) {
            location = @" ";
        }
        NSString* editProfilePictureURL = [NSString stringWithFormat:@"gtio://profile/edit/picture/%@/%@",name,location];
		self.dataSource = [GTIOEditProfileListDataSource dataSourceWithObjects:
                           [GTIOEditProfileTableImageItem itemWithText:@"edit profile picture" imageURL:user.profileIconURL URL:editProfilePictureURL],
						   [TTTableControlItem itemWithCaption:@"email" control:_emailField],
						   [TTTableControlItem itemWithCaption:@"first name" control:_firstNameField],
						   [TTTableControlItem itemWithCaption:@"last initial" control:_lastInitialField],
						   [TTTableControlItem itemWithCaption:@"city" control:_cityField],
						   [TTTableControlItem itemWithCaption:@"state" control:_stateField],
						   [TTTableControlItem itemWithCaption:@"gender" control:_genderPicker],
                           [TTTableControlItem itemWithCaption:@"year born" control:_bornInPicker],
						   [TTTableControlItem itemWithCaption:@"about me" control:(UIControl*)_aboutMeTextView],
						   nil];
	} else {
		[_bornInPicker.toolbar setItems:[NSArray arrayWithObjects:
										 _bornInPicker.doneButton,
										 [[[GTIOBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
										 _bornInPicker.titleView,
										 [[[GTIOBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
										 nil]];
        NSMutableArray* objects = [NSMutableArray arrayWithObjects:
                                   [TTTableControlItem itemWithCaption:@"email" control:_emailField],
                                   [TTTableControlItem itemWithCaption:@"first name" control:_firstNameField],
                                   [TTTableControlItem itemWithCaption:@"last initial" control:_lastInitialField],
                                   [TTTableControlItem itemWithCaption:@"city" control:_cityField],
                                   [TTTableControlItem itemWithCaption:@"state" control:_stateField],
                                   [TTTableControlItem itemWithCaption:@"gender" control:_genderPicker],
                                   [TTTableControlItem itemWithCaption:@"year born" control:_bornInPicker],
                                   nil];
        if ([user.isFacebookConnected boolValue] && user.profileIconURL) {
            TTTableControlItem* item = [GTIOProfileImageTableControlItem itemWithCaption:@"use Facebook profile picture" imageURL:user.profileIconURL control:_useFacebookProfileIconSwitch];
            [objects insertObject:item atIndex:0];
        }
		self.dataSource = [GTIOEditProfileListDataSource dataSourceWithItems:objects];
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
        self.navigationItem.leftBarButtonItem = nil;
	} else {
        GTIOBarButtonItem* cancelButton = [[GTIOBarButtonItem alloc] initWithTitle:@"cancel" target:self action:@selector(cancelButtonWasPressed:)];
		self.navigationItem.leftBarButtonItem = cancelButton;
        [cancelButton setAccessibilityLabel:@"Cancel Bar Button"];
        [cancelButton release];
	}

	GTIOBarButtonItem* goButton = [[GTIOBarButtonItem alloc] initWithTitle:@"save" target:self action:@selector(goButtonWasPressed:)];
    [goButton setAccessibilityLabel:@"Save Bar Button"];
	self.navigationItem.rightBarButtonItem = goButton;
    [goButton release];
	
	// Title Image
	NSString* title = nil;
	if (_isNew) {
		title = @"NEW PROFILE";
	} else {
		title = @"EDIT PROFILE";
	}
	self.navigationItem.titleView = [GTIOHeaderView viewWithText:title];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isNew) {
        GTIOAnalyticsEvent(kUserSignUpAlmostDoneEventName);
    } else {
        GTIOAnalyticsEvent(kUserEditProfileEventName);
    }
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
	user.aboutMe = _aboutMeTextView.text;
    user.bornIn = [NSNumber numberWithInt:[_bornInPicker.textLabel.text intValue]];
    if (_useFacebookProfileIconSwitch.on == NO) {
        user.profileIconURL = @"";
    }
	
	[[GTIOUpdateUserRequest updateUser:user delegate:self selector:@selector(updateFinished:)] retain];
	[self dismissKeyboard];
	[self showLoading];
}

- (void)dismiss {
    if(_isNew) {
        [self dismissModalViewControllerAnimated:NO];
        TTOpenURL(@"gtio://pushStylists");
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
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
	
	[self dismiss];
}

- (void)cancelButtonWasPressed:(id)sender {
	[self dismissKeyboard];
    [self dismiss];
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
