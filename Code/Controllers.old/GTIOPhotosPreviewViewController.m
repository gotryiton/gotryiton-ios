//
//  GTIOPhotosPreviewViewController.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/16/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOPhotosPreviewViewController.h"
#import "GTIOPhoto.h"

@interface GTIOPhotosPreviewViewController (Private)
- (void)loadPhotosIntoView;
@end

@implementation GTIOPhotosPreviewViewController

@synthesize opinionRequest = _opinionRequest;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if (self = [super initWithNavigatorURL:URL query:query]) {
		_opinionRequest = [[query objectForKey:@"opinionRequest"] retain];				

		
		// Navigation Item
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(step1TitleImage)] autorelease];		
        
		self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" 
																				  
																				 target:nil 
																				 action:nil] autorelease];
		// Cancel button
		UIBarButtonItem* cancelButton = [[[GTIOBarButtonItem alloc] initWithTitle:@"cancel" 
																		  
																		 target:self 
																		 action:@selector(cancelButtonWasTouched:)] autorelease];
		self.navigationItem.leftBarButtonItem = cancelButton;
	}
	return self;
}

- (void)loadView {
	[super loadView];
	
	// Concrete background
	[self setConcreteBackgroundImage];
	
	// Buttons		
	_addAnotherOutfitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_addAnotherOutfitButton.frame = CGRectZero;
	[_addAnotherOutfitButton setImage:TTSTYLEVAR(addAnotherOutfitButtonImageNormal) forState:UIControlStateNormal];
	[_addAnotherOutfitButton setImage:TTSTYLEVAR(addAnotherOutfitButtonImageHighlighted) forState:UIControlStateHighlighted];
	[_addAnotherOutfitButton addTarget:self action:@selector(addAnotherOutfitButtonWasTouched:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_addAnotherOutfitButton];
	
	_doneWithPhotosButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_doneWithPhotosButton.frame = CGRectZero;
	[_doneWithPhotosButton setImage:TTSTYLEVAR(doneWithPhotosButtonImageNormal) forState:UIControlStateNormal];
	[_doneWithPhotosButton setImage:TTSTYLEVAR(doneWithPhotosButtonImageHighlighted) forState:UIControlStateHighlighted];
	[_doneWithPhotosButton addTarget:self action:@selector(doneWithPhotosButtonWasTouched:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_doneWithPhotosButton];
	
	_photoPreviews = [[NSMutableArray alloc] initWithCapacity:4];
	
	// Photo Previews
	for (int i = 0; i < 4; i++) {			
		UIButton* photoPreviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
		photoPreviewButton.frame = CGRectZero;
		photoPreviewButton.contentMode = UIViewContentModeScaleAspectFit;
		[photoPreviewButton addTarget:self action:@selector(photoButtonWasTouched:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:photoPreviewButton];
		[_photoPreviews addObject:photoPreviewButton];
	}
    
    UIImage* topShadow = [UIImage imageNamed:@"list-top-shadow.png"];
    UIView* topShadowImageView = [[[UIImageView alloc] initWithImage:topShadow] autorelease];
    [self.view addSubview:topShadowImageView];
}

- (void)viewDidUnload {
	[_doneWithPhotosButton release];
	_doneWithPhotosButton = nil;
	[_addAnotherOutfitButton release];
	_addAnotherOutfitButton = nil;
	[_photoPreviews release];
	_photoPreviews = nil;
}

- (void)dealloc {
	[_opinionRequest release];
	[super dealloc];
}

- (BOOL)iOS4orGreater {
	// Known iOS 4 selector
	return ([[UIApplication sharedApplication] respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)]);
}

- (void)loadPhotosIntoView {
	for (NSUInteger i = 0; i < 4; i++) {
		UIButton* photoPreview = [_photoPreviews objectAtIndex:i];
		if (i < [self.opinionRequest.photos count]) {
			GTIOPhoto* photo = [self.opinionRequest.photos objectAtIndex:i];			
			photoPreview.enabled = YES;
			photoPreview.backgroundColor = [UIColor whiteColor];
			photoPreview.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);			
			if ([self iOS4orGreater]) {
				[photoPreview setImage:photo.image forState:UIControlStateNormal];
			} else {
				[photoPreview setBackgroundImage:photo.image forState:UIControlStateNormal];
			}
		} else {			
			photoPreview.enabled = NO;
			photoPreview.backgroundColor = [UIColor clearColor];
			photoPreview.contentEdgeInsets = UIEdgeInsetsZero;
			if ([self iOS4orGreater]) {
				[photoPreview setImage:[UIImage imageNamed:@"empty-box.png"] forState:UIControlStateNormal];
			} else {
				[photoPreview setBackgroundImage:[UIImage imageNamed:@"empty-box.png"] forState:UIControlStateNormal];
			}
		}
	}	
}

- (void)layoutViews {
	CGRect firstButtonRect = CGRectMake(10, 10, 300, 45);	
	CGRect secondButtonRect = CGRectOffset(firstButtonRect, 0, firstButtonRect.size.height + 10);
	CGRect doneButtonRect = CGRectZero;
	
	// Position the done button based on our ability add another photo
	if ([self.opinionRequest canAddAnotherPhoto]) {
		_addAnotherOutfitButton.hidden = NO;
		doneButtonRect = secondButtonRect;
	} else {
		_addAnotherOutfitButton.hidden = YES;
		doneButtonRect = firstButtonRect;
	}
	
	_addAnotherOutfitButton.frame = firstButtonRect;
	_doneWithPhotosButton.frame = doneButtonRect;
	
	// Offset the photos from the bottom of the done button
	CGFloat y = CGRectGetMaxY(doneButtonRect) + 20;
	CGRect basePhotoRect = CGRectMake(10, y, 70, 90);
	for (int i = 0; i < 4; i++) {
		CGFloat dx = (i == 0) ? 0 : (i * (basePhotoRect.size.width + 7)); // offset the rect on x axis by its width + 8 pixels of padding
		CGRect photoRect = CGRectOffset(basePhotoRect, dx, 0);
		UIButton* photoButton = [_photoPreviews objectAtIndex:i];
		photoButton.frame = photoRect;
		photoButton.imageView.frame = photoRect;
	}
	
	// Ensure that you cannot continue with no photos loaded
	if (0 == [self.opinionRequest.photos count]) {
		_doneWithPhotosButton.enabled = NO;
	} else {
		_doneWithPhotosButton.enabled = YES;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Update the view
	[self loadPhotosIntoView];
	[self layoutViews];
}

#pragma mark Actions

- (void)addAnotherOutfitButtonWasTouched:(id)sender {
	[[TTNavigator navigator] openURLAction:
	 [[TTURLAction actionWithURLPath:@"gtio://getAnOpinion/photos/new"] applyAnimated:YES]];
}

- (void)doneWithPhotosButtonWasTouched:(id)sender {
	// TODO: Should dispatch through the opinion request session...
	NSDictionary* query = [NSDictionary dictionaryWithObject:_opinionRequest forKey:@"opinionRequest"];
	[[TTNavigator navigator] openURLAction:
	 [[[TTURLAction actionWithURLPath:@"gtio://getAnOpinion/tellUsAboutIt/multiplePhotos"] applyQuery:query] applyAnimated:YES]];
}

- (void)photoButtonWasTouched:(id)sender {
	UIButton* button = (UIButton*) sender;
	NSInteger photoIndex = [_photoPreviews indexOfObject:button];
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"" 
															 delegate:self 
													cancelButtonTitle:@"cancel" 
											   destructiveButtonTitle:@"delete photo" 
													otherButtonTitles:@"edit photo", nil];
	actionSheet.tag = photoIndex;
	[actionSheet showInView:[TTNavigator navigator].window];
	[actionSheet release];
}

- (void)cancelButtonWasTouched:(id)sender {
	[self.opinionRequest.photos removeAllObjects];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSUInteger photoIndex = actionSheet.tag;
	
	if (0 == buttonIndex) {
		// delete
		[self.opinionRequest.photos removeObjectAtIndex:photoIndex];
		[self loadPhotosIntoView];
		[self layoutViews];
	} else if (1 == buttonIndex) {
		// edit
		[[TTNavigator navigator] openURLAction:
		[TTURLAction actionWithURLPath:[NSString stringWithFormat:@"gtio://getAnOpinion/photos/edit/%d", photoIndex]]];
	} else if (2 == buttonIndex) {
		// cancel
	}
	
}

@end
