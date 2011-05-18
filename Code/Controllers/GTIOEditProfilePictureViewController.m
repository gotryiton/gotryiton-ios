//
//  GTIOEditProfilePictureViewController.m
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOEditProfilePictureViewController.h"
#import "GTIOUserIconOption.h"
#import "GTIOBarButtonItem.h"
#import "GTIOUser.h"

@implementation GTIOEditProfilePictureViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
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
	_scrollview = [UIScrollView new];
	[_scrollview setBounces:NO];
	[_scrollview setDelegate:self];
	[_scrollview setFrame:CGRectMake(10,70,300,110)];
	[_scrollview setShowsHorizontalScrollIndicator:NO];
	[_scrollview setShowsVerticalScrollIndicator:NO];
	[self.view addSubview:_scrollview];
	_scrollSlider = [UISlider new];
	[_scrollSlider setFrame:CGRectMake(10,190,300,25)];
	[_scrollSlider setValue:0];
	[self.view addSubview:_scrollSlider];
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
		[_scrollview addSubview:image];
		i+=1;			
	} 
	[_scrollview setContentSize:CGSizeMake(i*110,110)];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	NSLog(@"Error:%@",[error localizedDescription]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSLog(@"%f",scrollView.contentOffset.x/(scrollView.contentSize.width - scrollView.frame.size.width));
	[_scrollSlider setValue:scrollView.contentOffset.x/(scrollView.contentSize.width - scrollView.frame.size.width)];
}

@end
