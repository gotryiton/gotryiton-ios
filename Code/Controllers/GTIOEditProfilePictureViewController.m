//
//  GTIOEditProfilePictureViewController.m
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOEditProfilePictureViewController.h"
#import "GTIOUpdateUserRequest.h"
#import "GTIOBarButtonItem.h"
#import "GTIOUser.h"
#import "GTIOUserIconOptionDataSource.h"
#import "GTIOHeaderView.h"

@implementation GTIOEditProfilePictureViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithName:(NSString*)name location:(NSString*)location {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _profileName = [name copy];
        _profileLocation = [location copy];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_facebookIconOption = nil;
        _options = nil;
		_slidingState = NO;
        // Name and Location Info For Preview
        _profileName = [[[GTIOUser currentUser] username] copy];
        _profileLocation = [[NSString stringWithFormat:@"%@, %@",[[GTIOUser currentUser] city],[[GTIOUser currentUser] state]] copy];
        //[self.view setAccessibilityLabel:@"edit profile picture"];
	}
	return self;
}

- (void)dealloc {
    // subviews
    TT_RELEASE_SAFELY(_scrollView);
    TT_RELEASE_SAFELY(_scrollSlider);
    TT_RELEASE_SAFELY(_myLooksLabel);
    TT_RELEASE_SAFELY(_facebookLabel);
    TT_RELEASE_SAFELY(_seperator);
    TT_RELEASE_SAFELY(_previewImageView);
    // ivars
    TT_RELEASE_SAFELY(_profileName);
    TT_RELEASE_SAFELY(_profileLocation);
    TT_RELEASE_SAFELY(_options);
    TT_RELEASE_SAFELY(_imageViews);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController Lifecycle

- (void)loadView {
	[super loadView];
    
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"PROFILE PICTURE"];
    
	// Background Image
	UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"full-wallpaper.png"]];
	[self.view addSubview:backgroundImageView];
	[backgroundImageView release];
	// Two White Containers With Rounded Corners
	UIImage* stretchableContainer = [[UIImage imageNamed:@"container.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:12];
	UIImageView* topContainer = [[UIImageView alloc] initWithImage:stretchableContainer];
	UIImageView* bottomContainer = [[UIImageView alloc] initWithImage:stretchableContainer];
	[topContainer setFrame:CGRectMake(9,10,302,186)];
	[bottomContainer setFrame:CGRectMake(9,206,302,200)];
	[self.view addSubview:topContainer];
	[self.view addSubview:bottomContainer];
	[topContainer release];
	[bottomContainer release];
	// Section Labels
	UILabel* choseFromLabel = [UILabel new];
	UILabel* previewLabel = [UILabel new];
	[choseFromLabel setText:@"choose from"];
	[previewLabel setText:@"preview"];
	[choseFromLabel setFrame:CGRectMake(30,20,260,30)];
	[previewLabel setFrame:CGRectMake(30,220,260,30)];
	[choseFromLabel setFont:[UIFont systemFontOfSize:19]];
	[previewLabel setFont:[UIFont systemFontOfSize:19]];
	[choseFromLabel setTextColor:[UIColor colorWithRed:0.745 green:0.745 blue:0.745 alpha:1]];
	[previewLabel setTextColor:[UIColor colorWithRed:0.745 green:0.745 blue:0.745 alpha:1]];
	[self.view addSubview:choseFromLabel];
	[self.view addSubview:previewLabel];	
	[choseFromLabel release];
	[previewLabel release];
	// Choose From Section
	_scrollView = [UIScrollView new];
	[_scrollView setBounces:NO];
	[_scrollView setDelegate:self];
	[_scrollView setFrame:CGRectMake(10,60,300,110)];
	[_scrollView setShowsHorizontalScrollIndicator:NO];
	[_scrollView setShowsVerticalScrollIndicator:NO];
	[self.view addSubview:_scrollView];
	_scrollSlider = [UISlider new];
	[_scrollSlider setFrame:CGRectMake(100,160,190,25)];
	[_scrollSlider setValue:0];
	UIImage* trackImage = [[UIImage imageNamed:@"profile-picture-edit-scroll-under.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
	UIImage* thumbImage = [UIImage imageNamed:@"profile-picture-edit-scroll-over.png"];
	[_scrollSlider setMaximumTrackImage:trackImage forState:UIControlStateNormal];	
	[_scrollSlider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
	[_scrollSlider setThumbImage:thumbImage forState:UIControlStateNormal];
	[_scrollSlider addTarget:self action:@selector(sliderValueDidChange) forControlEvents:UIControlEventValueChanged];
	[_scrollSlider addTarget:self action:@selector(sliderEditBegin) forControlEvents:UIControlEventTouchDown];
	[_scrollSlider addTarget:self action:@selector(sliderEditEnd) forControlEvents:UIControlEventTouchUpInside];	 
	[_scrollSlider addTarget:self action:@selector(sliderEditEnd) forControlEvents:UIControlEventTouchUpOutside];	 	   
	[self.view addSubview:_scrollSlider];
	UIButton* clearProfilePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[clearProfilePictureButton setImage:[UIImage imageNamed:@"clear-profile-picture-OFF.png"] forState:UIControlStateNormal];
	[clearProfilePictureButton setFrame:CGRectMake(30,370,120,20)];
    [clearProfilePictureButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [clearProfilePictureButton setAccessibilityLabel:@"Clear Profile Picture"];
	[self.view addSubview:clearProfilePictureButton];
    _myLooksLabel = [UILabel new];
    [_myLooksLabel setFrame:CGRectMake(100,65,85,15)];
    [_myLooksLabel setText:@"my looks"];
    [_myLooksLabel setTextColor:[UIColor colorWithRed:0.745 green:0.745 blue:0.745 alpha:1]];
    [_myLooksLabel setFont:[UIFont boldSystemFontOfSize:11]];    
    [self.view addSubview:_myLooksLabel];
    _facebookLabel = [UILabel new];
    [_facebookLabel setFrame:CGRectMake(30,65,60,15)];
    [_facebookLabel setText:@"facebook"];
    [_facebookLabel setTextColor:[UIColor colorWithRed:0 green:.541 blue:.773 alpha:1.0]];
    [_facebookLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [self.view addSubview:_facebookLabel];
    _seperator = [UIView new];
    [_seperator setFrame:CGRectMake(90,60,1,100)];
    [_seperator setBackgroundColor:kGTIOColorE3E3E3];
    [self.view addSubview:_seperator];
    // Preview Section
    UIView* previewBackground = [UIView new];
    [previewBackground setFrame:CGRectMake(30,255,260,85)];
    [previewBackground setBackgroundColor:kGTIOColorE3E3E3];
    [[previewBackground layer] setBorderColor:[kGTIOColorE3E3E3 CGColor]];
    [[previewBackground layer] setBorderWidth:1];
    [[previewBackground layer] setCornerRadius:5];
    [self.view addSubview:previewBackground];
    _previewImageView = [TTImageView new];
    _previewImageView.defaultImage = [UIImage imageNamed:@"empty-profile-pic.png"];
    NSLog(@"currentURL=%@",[[GTIOUser currentUser] profileIconURL]);
    _previewImageView.urlPath = [[GTIOUser currentUser] profileIconURL];
    [_previewImageView setFrame:CGRectMake(44,269,56,56)];
    [_previewImageView setAccessibilityLabel:@"preview image"];
    [self.view addSubview:_previewImageView];
    UIImageView* profileIconOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-overlay-110.png"]];
    [profileIconOverlay setFrame:CGRectMake(40,265,64,64)];
    [self.view addSubview:profileIconOverlay];
    UILabel* locationLabel = [UILabel new];
    [locationLabel setBackgroundColor:[UIColor clearColor]];
    [locationLabel setFont:[UIFont systemFontOfSize:14]];
    [locationLabel setTextColor:kGTIOColorAAAAAA];
    [locationLabel setFrame:CGRectMake(115,302,160,20)];
    [locationLabel setText:_profileLocation];
    [self.view addSubview:locationLabel];
    [locationLabel release];
    UILabel* nameLabel = [UILabel new];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:kGTIOFetteFontOfSize(32)];
    [nameLabel setTextColor:kGTIOColorBrightPink];
    [nameLabel setFrame:CGRectMake(115,277,160,30)];
    [nameLabel setText:[_profileName uppercaseString]];
    [self.view addSubview:nameLabel];
    [nameLabel release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    // Send Request for icon options
    [GTIOUserIconOptionDataSource iconOptionRequestWithDelegate:self];
    // Setup Navigation Bar Items
	GTIOBarButtonItem* cancelButton = [[GTIOBarButtonItem alloc] initWithTitle:@"cancel" target:self action:@selector(cancelButtonAction)];
	self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton setAccessibilityLabel:@"Cancel"];
    GTIOBarButtonItem* saveButton = [[GTIOBarButtonItem alloc] initWithTitle:@"save" target:self action:@selector(saveButtonAction)];
    [saveButton setAccessibilityLabel:@"Save"];
    self.navigationItem.rightBarButtonItem = saveButton;
    // Release buttons
    [cancelButton release];
    [saveButton release];
}

#pragma mark -
#pragma mark Rendering Profile Pic Picker

- (void)displayOptions {
	int i = 0;
    _currentSelection = -1;
    NSMutableArray* imageViews = [NSMutableArray new];
    float outfitPadding = 0;
	for (GTIOUserIconOption* option in _options) {
        if ([option.url isEqualToString:_previewImageView.urlPath] && ![option.type isEqualToString:@"Default"]) {
            _currentSelection = [_options indexOfObject:option];
        }
        float width = 50;//floor([option.width floatValue]/2.0f);
        float height = 50;//floor([option.height floatValue]/2.0f);
        if ([option.type isEqualToString:@"Default"]) {
            continue;
        } else if ([option.type isEqualToString:@"Facebook"]) {
            _facebookIconOption = option;
            TTImageView* image = [[TTImageView alloc] init];
//            [image setFrame:CGRectMake(30,90,48,48)];
            [image setFrame:CGRectMake(30,90,width,height)];
            image.urlPath = option.url;
            [[image layer] setBorderColor:[[UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1] CGColor]];
            [[image layer] setBorderWidth:1];
            [self.view addSubview:image];
            [imageViews addObject:image];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:image.frame];
            [button setTag:[_options indexOfObject:option]];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        } else {
            TTImageView* image = [[TTImageView alloc] init];
//            [image setFrame:CGRectMake(i*49+i*2.5,0,49,67)];
            [image setFrame:CGRectMake(outfitPadding,0,width,height)];
            image.urlPath = option.url;
            [[image layer] setBorderColor:[[UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1] CGColor]];
            [[image layer] setBorderWidth:1];
            [_scrollView addSubview:image];
            [imageViews addObject:image];            
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:image.frame];
            [button setTag:[_options indexOfObject:option]];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            i+=1;
            outfitPadding += width + 3;
        }
	}
    _imageViews = [imageViews retain];
    [self performSelector:@selector(displayHighlight)];
    // Setup Frame For Scroll View
    
    [_scrollView setFrame:CGRectMake(100,90,190,67)];
    [_scrollSlider setFrame:CGRectMake(100,155,190,25)];
    
    [_connectToFacebookButton removeFromSuperview];
    _connectToFacebookButton = nil;
    [_connectToFacebookImageView removeFromSuperview];
    _connectToFacebookImageView = nil;
    
    if (!_facebookIconOption) {
        // show connect to facebook;
        _connectToFacebookImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fb-empty.png"]] autorelease];
        _connectToFacebookImageView.frame = CGRectMake(30,90,50,50);
        [self.view addSubview:_connectToFacebookImageView];
        _connectToFacebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectToFacebookButton setImage:[UIImage imageNamed:@"fb-connect-small.png"] forState:UIControlStateNormal];
        _connectToFacebookButton.frame = CGRectMake(28,150,53,16);
        [_connectToFacebookButton addTarget:self action:@selector(connectToFacebook:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_connectToFacebookButton];
    }
    [_scrollView setContentSize:CGSizeMake(i*49+i*2.5,67)];
    if (_scrollView.contentSize.width <= _scrollView.frame.size.width) {
        [_scrollSlider setHidden:YES];
    }
}

#pragma mark -
#pragma mark Button Actions

- (void)connectToFacebook:(id)sender {
    [[GTIOUser currentUser] loginWithFacebook];
}

- (void)cancelButtonAction {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)saveButtonAction {
    // Save Action
    GTIOUser* user = [GTIOUser currentUser];
    user.profileIconURL = _previewImageView.urlPath;
    [[GTIOUpdateUserRequest updateUser:user delegate:self selector:@selector(updateFinished:)] retain];
}

- (void)selectOption:(id)sender {
    _currentSelection = [sender tag];
    NSLog(@"selecting option:%@",[_options objectAtIndex:_currentSelection]);
    [_previewImageView setUrlPath:[[_options objectAtIndex:_currentSelection] url]];
    [self performSelector:@selector(clearHighlight)];
    [self performSelector:@selector(displayHighlight)];
}

- (void)clearButtonAction {
    _currentSelection = -1;
    [self performSelector:@selector(clearHighlight)];
    [_previewImageView setUrlPath:@"http://assets.gotryiton.com/img/profile-default.png"];
}

#pragma mark -
#pragma mark GTIOUpdateUserRequest delegate

- (void)updateFinished:(GTIOUpdateUserRequest*)updateRequest {
	[updateRequest autorelease];
	//[self hideLoading];
	
	TTURLRequest* request = updateRequest.request;
	TTURLDataResponse* response = request.response;
	
	if (updateRequest.error) {
		TTAlert([updateRequest.error localizedDescription]);
		return;
	}
	
	NSString* body = [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary* json = (NSDictionary*)[[[SBJsonParser new] autorelease] objectWithString:body];
	NSLog(@"json response=%@",json);
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

#pragma mark -
#pragma mark RKObjectLoader Delegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary {
    NSLog(@"dictionary:%@",dictionary);
	_options = [[dictionary objectForKey:@"userIconOptions"] retain];
    for (GTIOUserIconOption* option in _options) {
        NSLog(@"Option: %@ %@", option.type, option.url);
    }
    [self performSelector:@selector(displayOptions)];
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	NSLog(@"Error:%@",[error localizedDescription]);
}

#pragma mark -
#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (!_slidingState) {
		[_scrollSlider setValue:scrollView.contentOffset.x/(scrollView.contentSize.width - scrollView.frame.size.width)];
	}
}

#pragma mark -
#pragma mark UISlider Delegate

- (void)sliderValueDidChange {
	CGFloat newHorizontalContentOffset = _scrollSlider.value * _scrollView.contentSize.width;
	CGRect newVisibleRect = CGRectMake(newHorizontalContentOffset,0,110,110);
	[_scrollView scrollRectToVisible:newVisibleRect animated:NO];
}

- (void)sliderEditBegin {
	_slidingState = YES;
}

- (void)sliderEditEnd {
	_slidingState = NO;
}

#pragma mark -
#pragma mark Image Frames

- (void)clearHighlight {
    for (TTImageView* view in _imageViews) {
        [[view layer] setBorderColor:[[UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1] CGColor]];
        [[view layer] setBorderWidth:1];
    }
}

- (void)displayHighlight {
    if (-1 == _currentSelection) {
        return;
    }
    [[[_imageViews objectAtIndex:_currentSelection] layer] setBorderColor:[kGTIOColorBrightPink CGColor]];
    [[[_imageViews objectAtIndex:_currentSelection] layer] setBorderWidth:3];
}


@end
