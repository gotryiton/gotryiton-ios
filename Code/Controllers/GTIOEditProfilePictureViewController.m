//
//  GTIOEditProfilePictureViewController.m
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOEditProfilePictureViewController.h"
#import "GTIOBarButtonItem.h"
#import "GTIOUser.h"

@implementation GTIOEditProfilePictureViewController

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
        _profileName = [[[GTIOUser currentUser] username] copy];
        _profileLocation = [[NSString stringWithFormat:@"%@, %@",[[GTIOUser currentUser] city],[[GTIOUser currentUser] state]] copy];
		NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
														[[GTIOUser currentUser] token], @"gtioToken",
														nil];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
		[[RKObjectManager sharedManager] loadObjectsAtResourcePath:GTIORestResourcePath(@"/user-icons") queryParams:params delegate:self];
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
    [super dealloc];
}

- (void)loadView {
	[super loadView];
    // Background Color
    UIColor* grayColor = [UIColor colorWithRed:.898 green:.898 blue:.898 alpha:1.0];
	// Background Image
	UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"full-wallpaper.png"]];
	[self.view addSubview:backgroundImageView];
	[backgroundImageView release];
	// Two White Containers With Rounded Corners
	UIImage* stretchableContainer = [[UIImage imageNamed:@"container.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:12];
	UIImageView* topContainer = [[UIImageView alloc] initWithImage:stretchableContainer];
	UIImageView* bottomContainer = [[UIImageView alloc] initWithImage:stretchableContainer];
	[topContainer setFrame:CGRectMake(9,10,302,190)];
	[bottomContainer setFrame:CGRectMake(9,210,302,200)];
	[self.view addSubview:topContainer];
	[self.view addSubview:bottomContainer];
	[topContainer release];
	[bottomContainer release];
	// Labels
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
	//	
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
	[self.view addSubview:clearProfilePictureButton];
    _myLooksLabel = [UILabel new];
    [_myLooksLabel setFrame:CGRectMake(100,70,75,10)];
    [_myLooksLabel setText:@"my looks"];
    [_myLooksLabel setTextColor:[UIColor colorWithRed:0.745 green:0.745 blue:0.745 alpha:1]];
    [_myLooksLabel setFont:[UIFont boldSystemFontOfSize:10]];    
    [self.view addSubview:_myLooksLabel];
    _facebookLabel = [UILabel new];
    [_facebookLabel setFrame:CGRectMake(30,70,50,10)];
    [_facebookLabel setText:@"facebook"];
    [_facebookLabel setTextColor:[UIColor colorWithRed:0 green:.541 blue:.773 alpha:1.0]];
    [_facebookLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [self.view addSubview:_facebookLabel];
    _seperator = [UIView new];
    [_seperator setFrame:CGRectMake(90,60,0.5,100)];
    [_seperator setBackgroundColor:grayColor];
    [self.view addSubview:_seperator];
    //
    UIView* previewBackground = [UIView new];
    [previewBackground setFrame:CGRectMake(30,255,260,85)];
    [previewBackground setBackgroundColor:grayColor];
    [[previewBackground layer] setBorderColor:[grayColor CGColor]];
    [[previewBackground layer] setBorderWidth:1];
    [[previewBackground layer] setCornerRadius:5];
    [self.view addSubview:previewBackground];
    _previewImageView = [TTImageView new];
    [_previewImageView setImage:[UIImage imageNamed:@"empty-profile-pic.png"]];
    [_previewImageView setFrame:CGRectMake(44,269,56,56)];
    [self.view addSubview:_previewImageView];
    UIImageView* profileIconOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-icon-overlay-110.png"]];
    [profileIconOverlay setFrame:CGRectMake(40,265,64,64)];
    [self.view addSubview:profileIconOverlay];
    //
    UILabel* nameLabel = [UILabel new];
    UILabel* locationLabel = [UILabel new];
    [nameLabel      setBackgroundColor:[UIColor clearColor]];
    [locationLabel  setBackgroundColor:[UIColor clearColor]];
    [nameLabel      setFont:kGTIOFetteFontOfSize(32)];
    [locationLabel  setFont:[UIFont systemFontOfSize:14]];
    [nameLabel      setTextColor:kGTIOColorBrightPink];
    [locationLabel  setTextColor:kGTIOColorAAAAAA];
    [nameLabel      setFrame:CGRectMake(120,275,140,30)];
    [locationLabel  setFrame:CGRectMake(120,300,140,20)];
    [nameLabel      setText:_profileName];
    [locationLabel  setText:_profileLocation];
    [self.view      addSubview:nameLabel];
    [self.view      addSubview:locationLabel];
    [nameLabel      release];
    [locationLabel  release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	GTIOBarButtonItem* cancelButton = [[GTIOBarButtonItem alloc] initWithTitle:@"cancel" target:self action:@selector(cancelButtonWasPressed:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)cancelButtonWasPressed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary {
	_options = [[dictionary objectForKey:@"userIconOptions"] retain];
    [self performSelector:@selector(displayOptions)];
}

- (void)displayOptions {
	int i = 0;
	for (GTIOUserIconOption* option in _options) {
        if ([option.type isEqualToString:@"Facebook"]) {
            _facebookIconOption = option;
            TTImageView* image = [[TTImageView alloc] init];
            [image setFrame:CGRectMake(30,90,48,48)];
            image.urlPath = option.url;
            [[image layer] setBorderColor:[[UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1] CGColor]];
            [[image layer] setBorderWidth:1];
            [self.view addSubview:image];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:image.frame];
            [button setTag:[_options indexOfObject:option]];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        } else {
            TTImageView* image = [[TTImageView alloc] init];
            [image setFrame:CGRectMake(i*49+i*2.5,0,49,67)];
            image.urlPath = option.url;
            [[image layer] setBorderColor:[[UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1] CGColor]];
            [[image layer] setBorderWidth:1];
            [_scrollView addSubview:image];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:image.frame];
            [button setTag:[_options indexOfObject:option]];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            i+=1;			
        }
	}
	[_scrollView setContentSize:CGSizeMake(i*49+i*2.5,67)];
    // Setup Frame For Scroll View
    if (_facebookIconOption) {
        [_scrollView setFrame:CGRectMake(100,90,190,67)];
        [_scrollSlider setFrame:CGRectMake(100,155,190,25)];
    } else {
        [_scrollView setFrame:CGRectMake(30,90,260,67)];
        [_scrollSlider setFrame:CGRectMake(30,155,260,25)];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	NSLog(@"Error:%@",[error localizedDescription]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (!_slidingState) {
		[_scrollSlider setValue:scrollView.contentOffset.x/(scrollView.contentSize.width - scrollView.frame.size.width)];
	}
}

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

- (void)selectOption:(id)sender {
    _currentSelection = [sender tag];
    NSLog(@"selecting option:%@",[_options objectAtIndex:_currentSelection]);
    [_previewImageView setUrlPath:[[_options objectAtIndex:_currentSelection] url]];
}

- (void)clearButtonAction {
    [_previewImageView setImage:[UIImage imageNamed:@"empty-profile-pic.png"]];
}

@end
