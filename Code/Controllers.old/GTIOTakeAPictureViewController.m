//
//  GTIOTakeAPictureViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOTakeAPictureViewController.h"
#import "GTIOOpinionRequest.h"
#import "UIImage+Manipulation.h"

@interface GTIOTakeAPictureViewController (Private)
- (void)loadPhoto:(GTIOPhoto*)photo;
@end

@implementation GTIOTakeAPictureViewController

@synthesize photo = _photo;
@synthesize useDoneButton = _useDoneButton;
@synthesize useCancelButton = _useCancelButton;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if (self = [super initWithNavigatorURL:URL query:query]) {
		_photo = [[query objectForKey:@"photo"] retain];
		_useDoneButton = [[query objectForKey:@"useDoneButton"] boolValue];
		_useCancelButton = [[query objectForKey:@"useCancelButton"] boolValue];
		_offsetPoint = CGPointZero;
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_photo);
	[super dealloc];
}

- (void)viewDidUnload {
	TT_RELEASE_SAFELY(_scrollView);
	TT_RELEASE_SAFELY(_blurrableImageView);
	TT_RELEASE_SAFELY(_toolbar);
	
	[super viewDidUnload];
}

- (void)loadView {
	[super loadView];
	
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(step1TitleImage)] autorelease];		
	
	// Background
	UIImageView* bgImage = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(modalBackgroundImage)] autorelease];
	bgImage.frame = CGRectOffset(TTScreenBounds(), 0, -20 - 44);
	[self.view insertSubview:bgImage atIndex:0];
	
	// Navigation Items
	self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" 
																			  
																			 target:nil 
																			 action:nil] autorelease];
	
	if (self.useDoneButton) {
		self.navigationItem.rightBarButtonItem = [[GTIOBarButtonItem alloc] initWithTitle:@"done"
																				  
																				 target:self
																				 action:@selector(nextButtonWasTouched:)];
	} else {		
		self.navigationItem.rightBarButtonItem = [[GTIOBarButtonItem alloc] initWithTitle:@"next" 
																				  
																				 target:self
																				 action:@selector(nextButtonWasTouched:)];
	}
	
	if (self.useCancelButton) {
		self.navigationItem.leftBarButtonItem = [[GTIOBarButtonItem alloc] initWithTitle:@"cancel" 
																				 
																				target:self 
																				action:@selector(cancelButtonWasTouched:)];
	}
	
	// Configure the Toolbar
	_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.height - 44, 320, 44)];
	[_toolbar setTintColor:RGBCOLOR(100,100,100)];
	[self.view addSubview:_toolbar];
	
	UIBarButtonItem* fixedSpace = [[[GTIOBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
	fixedSpace.width = 14;
	UIBarButtonItem* rotate = [[[GTIOBarButtonItem alloc] initWithImage:TTSTYLEVAR(rotateImage) 
																style:UIBarButtonItemStylePlain 
															   target:self 
															   action:@selector(rotateButtonWasPressed:)] autorelease];
	UIBarButtonItem* zoomIn = [[[GTIOBarButtonItem alloc] initWithImage:TTSTYLEVAR(zoomInImage) 
																style:UIBarButtonItemStylePlain 
															   target:self 
															   action:@selector(zoomInButtonWasPressed:)] autorelease];
	UIBarButtonItem* zoomOut = [[[GTIOBarButtonItem alloc] initWithImage:TTSTYLEVAR(zoomOutImage) 
																 style:UIBarButtonItemStylePlain 
																target:self 
																action:@selector(zoomOutButtonWasPressed:)] autorelease];
	
	// Blur button
	_blurButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_blurButton setImage:TTSTYLEVAR(blurButtonOffStateImage) forState:UIControlStateNormal];
	[_blurButton setImage:TTSTYLEVAR(blurButtonOnStateImage) forState:UIControlStateSelected];
	[_blurButton addTarget:self action:@selector(toggleBlur:) forControlEvents:UIControlEventTouchUpInside];
	[_blurButton sizeToFit];
	UIBarButtonItem* blurItem = [[[GTIOBarButtonItem alloc] initWithCustomView:_blurButton] autorelease];
	
	[_toolbar setItems:[NSArray arrayWithObjects:fixedSpace, fixedSpace, rotate, 
						fixedSpace, zoomIn, fixedSpace, zoomOut, fixedSpace, 
						fixedSpace, blurItem, fixedSpace, fixedSpace, nil]];
	
	[_toolbar setTintColor:TTSTYLEVAR(navigationBarTintColor)];
	
	// Image Border
	imageBorder = [[[UIView alloc] initWithFrame:CGRectMake((320 - (267 + 6)) / 2, 3, 267 + 6, 362)] autorelease];	
	// shadowOffset and friends are iOS 3.2 and higher only...
	if ([imageBorder.layer respondsToSelector:@selector(setShadowOffset:)]) {
		imageBorder.layer.shadowOffset = CGSizeMake(3,3);
		imageBorder.layer.shadowColor = [UIColor blackColor].CGColor;
		imageBorder.layer.shadowOpacity = 0.33;	
		imageBorder.layer.shadowRadius = 2;
	}
	imageBorder.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:imageBorder];
	
	// Image View
	_blurrableImageView = [[GTIOBlurrableImageView alloc] initWithImage:nil];
	_blurrableImageView.overlayParentView = imageBorder;
	_blurrableImageView.delegate = self;
	// This doesn't stretch the image.
	[_blurrableImageView setContentMode:UIViewContentModeCenter];
	
	// Scroll View
	CGRect scrollableFrame = CGRectMake(3, 3, 267, 356); //new aspect ratio: 4:3
	UIView* backgroundView = [[UIView alloc] initWithFrame:scrollableFrame];
	backgroundView.backgroundColor = TTSTYLEVAR(patternedPhotoBackgroundColor);
	[imageBorder addSubview:backgroundView];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:scrollableFrame];
	_scrollView.backgroundColor = [UIColor clearColor];
	[_scrollView addSubview:_blurrableImageView];
	[imageBorder addSubview:_scrollView];
	
	if (_photo) {
		[self loadPhoto:_photo];
	}
}

- (void)loadPhoto:(GTIOPhoto*)photo {
	[photo retain];
	[_photo release];
	_photo = photo;
	
	// Reset the blurring state
	_blurButton.selected = NO;
	_blurrableImageView.blurringEnabled = NO;
	
	// Set the image view
	_blurrableImageView.image = _photo.image;	
	[_blurrableImageView sizeToFit];
	_blurrableImageView.frame = CGRectMake(0, 0, _blurrableImageView.width, _blurrableImageView.height);
	
	// Zooming and sizing
	CGFloat padding = 0;//30.0;
	CGSize photoSize = self.photo.image.size;
	CGSize photoFrameSize = _scrollView.bounds.size;
    CGFloat widthRatio = photoFrameSize.width / photoSize.width;
    CGFloat heightRatio = photoFrameSize.height / photoSize.height;
    CGFloat initialZoom = (widthRatio > heightRatio) ? widthRatio : heightRatio;
	[_scrollView setDelegate:self];
	[_scrollView setBouncesZoom:YES];
    [_scrollView setMaximumZoomScale:3.0];
	[_scrollView setMinimumZoomScale:initialZoom];
    [_scrollView setZoomScale:initialZoom];
	_scrollView.contentOffset = CGPointZero;
    [_scrollView setContentSize:CGSizeMake((photoSize.width * initialZoom) + padding,
										   (photoSize.height * initialZoom) + padding)];
	[self scrollViewDidZoom:_scrollView];
}

#pragma mark Actions

- (void)cancelButtonWasTouched:(id)sender {
	[[TTNavigator navigator] openURLAction:
	 [TTURLAction actionWithURLPath:@"gtio://getAnOpinion/cancel"]];
}

- (void)rotateButtonWasPressed:(id)sender {
	_photo.image = [_blurrableImageView.image rotate:UIImageOrientationRight];
	[self loadPhoto:_photo];
}

- (void)zoomInButtonWasPressed:(id)sender {
	_scrollView.zoomScale = _scrollView.zoomScale + 0.1;
}

- (void)zoomOutButtonWasPressed:(id)sender {
	_scrollView.zoomScale = _scrollView.zoomScale - 0.1;
}

- (void)toggleBlur:(id)sender {
	if (_blurButton.selected) {
		_blurButton.selected = NO;		
		_blurrableImageView.blurringEnabled = NO;
		_scrollView.scrollEnabled = YES;
	} else {
		_blurButton.selected = YES;
		_blurrableImageView.blurringEnabled = YES;
		_scrollView.scrollEnabled = NO;
	}
}

- (void)nextButtonWasTouched:(id)sender {
	// Apply blur if necessary	
	if (_blurButton.selected) {
		_blurButton.selected = NO;
		[_blurrableImageView commitBlur];
	}
	
	CGRect visibleRect;
	visibleRect.origin = _scrollView.contentOffset;
	visibleRect.size = _scrollView.bounds.size;
	float theScale = 1.0 / _scrollView.zoomScale;
	CGRect scaledRect = CGRectMake(visibleRect.origin.x * theScale,
										visibleRect.origin.y * theScale,
										visibleRect.size.width * theScale,
										visibleRect.size.height * theScale);
	self.photo.image = [_blurrableImageView.image sampleImageForRegionAtRect:scaledRect];
	
	[[TTNavigator navigator] openURLAction:
	 [TTURLAction actionWithURLPath:@"gtio://getAnOpinion/next"]];
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _blurrableImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? 
		(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? 
		(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
	
	_offsetPoint = CGPointMake(offsetX, offsetY);
    _blurrableImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, 
                                   scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark GTIOBlurrableImageViewDelegate methods

- (void)blurrableImageViewDidCommitBlur:(GTIOBlurrableImageView*)blurrableImageView {
	_photo.blurApplied = YES;
	_blurButton.selected = NO;
	_scrollView.scrollEnabled = YES;
}

- (void)blurrableImageViewDidAbandonBlur:(GTIOBlurrableImageView*)blurrableImageView {
	_blurButton.selected = NO;
	_scrollView.scrollEnabled = YES;
}

- (CGRect)rectForCommitBlurWithRect:(CGRect)rect {
	CGRect visibleRect = CGRectZero;
	visibleRect.origin = _scrollView.contentOffset;
	visibleRect.size = _scrollView.bounds.size;
	
	float theScale = 1.0 / _scrollView.zoomScale;
	CGRect blurRect = CGRectMake((visibleRect.origin.x + rect.origin.x)*theScale,
								 (visibleRect.origin.y + rect.origin.y)*theScale,
								 rect.size.width*theScale,
								 rect.size.height*theScale);
	return CGRectOffset(blurRect, -_offsetPoint.x*theScale, -_offsetPoint.y*theScale);
}

@end
