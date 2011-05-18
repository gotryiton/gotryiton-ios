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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_facebookIconOption = nil;
		_slidingState = NO;		
		NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
														[[GTIOUser currentUser] token], @"gtioToken",
														nil];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
		[[RKObjectManager sharedManager] loadObjectsAtResourcePath:GTIORestResourcePath(@"/user-icons") queryParams:params delegate:self];
	}
	return self;
}

- (void)loadView {
	[super loadView];
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
	[_scrollSlider setFrame:CGRectMake(10,175,200,25)];
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
	[self.view addSubview:clearProfilePictureButton];
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
	//NSLog(@"dictionary: %@", dictionary);
	NSArray* options = [dictionary objectForKey:@"userIconOptions"];
	int i = 0;
	for (GTIOUserIconOption* option in options) {
		TTImageView* image = [[TTImageView alloc] init];
		[image setFrame:CGRectMake(i*110,0,110,110)];
		image.urlPath = option.url;
		[_scrollView addSubview:image];
		i+=1;			
	} 
	[_scrollView setContentSize:CGSizeMake(i*110,110)];
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

@end
