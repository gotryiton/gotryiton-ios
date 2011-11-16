//
//  GTIOOpinionRequestSession.m
//  GoTryItOn
//
//  Created by Blake Watters on 8/30/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
//  walks the user through the submission process
//

#import "GTIOOpinionRequestSession.h"
#import "GTIOPhoto.h"
#import "GTIOUser.h"
#import "UIImage+Manipulation.h"
#import "GTIOProfileViewController.h"
#import "GTIOPhotosPreviewViewController.h"
#import "GTIOAnalyticsTracker.h"
#import "UIDeviceHardware.h"
#import "GTIOOutfit.h"
#import "GTIOStaticOutfitListModel.h"
#import "GTIOOutfitViewController.h"
#import <ImageIO/ImageIO.h>

// Constants
static NSUInteger kGTIOGetAnOpinionPhotoSourceActionSheetTag = 18001;
static NSUInteger kGTIOGetAnOpinionDoneWithPhotosOrAddAnotherActionSheetTag = 18002;

static NSInteger kGTIOPhotoActionSheetDoneWithPhotosButtonIndex = 0;
static NSInteger kGTIOPhotoActionSheetAddAnotherOutfitButtonIndex = 1;
static NSInteger kGTIOPhotoActionSheetCancelButtonIndex = 2;

static NSInteger kGTIOActivityLabelTag = 99999;

@interface GTIOOpinionRequestSession (Private)

NSInteger _getAnOpinionChooseFromLibraryButtonIndex;

@property (nonatomic, readonly) UIWindow* window;
@property (nonatomic, readonly) UIViewController* topViewController;
@property (nonatomic, readonly) UINavigationController* navigationController;

/**
 * Presents the photo source action sheet
 */
- (void)presentPhotoSourceActionSheet:(BOOL)showGuidelines;

/**
 * Presents the action sheet asking the user if they want to add another photo
 */
- (void)presentDoneWithPhotosOrAddAnotherActionSheet;

@end

#pragma mark -

@implementation GTIOOpinionRequestSession

// Global Session instance
static GTIOOpinionRequestSession* globalSession = nil;

@synthesize opinionRequest = _opinionRequest;

+ (GTIOOpinionRequestSession*)globalSession {
	if (nil == globalSession) {
		globalSession = [[GTIOOpinionRequestSession alloc] init];
	}
	
	return globalSession;
}

- (id)init {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(resetSession)
													 name:kGTIOUserDidLogoutNotificationName
												   object:nil];
        _locationManager = [[CLLocationManager alloc] init];
		_locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
		_locationManager.delegate = self;
	}
	
	return self;
}

- (void)dealloc {
    [_locationManager stopUpdatingLocation];
    [_locationManager release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_opinionRequest release];

	[super dealloc];
}

- (void)resetSession {
	[_opinionRequest release];
	_opinionRequest = nil;
	
	UIViewController* viewController = [[TTNavigator globalNavigator] viewControllerForURL:@"gtio://getAnOpinion"];
	[viewController.navigationController popToViewController:viewController animated:YES];
}

#pragma mark Private

- (UIWindow*)window {
	return [TTNavigator navigator].window;
}

- (UIViewController*)topViewController {
	return [TTNavigator navigator].topViewController;
}

- (UINavigationController*)navigationController {
	return [self topViewController].navigationController;
}

#pragma mark Notifications

- (void)removeLoginObservers {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kGTIOUserDidLoginNotificationName object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kGTIOUserDidCancelLoginNotificationName object:nil];
}

- (void)userDidLogin {
	[self removeLoginObservers];
	
	// User has now logged in, let's start the process
	[self start];
}

#pragma mark Opinion Request Settings persistence

- (void)persistOpinionRequestToUserDefaults {
	if (_opinionRequest) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_opinionRequest] 
												  forKey:@"gtioOpinionRequest"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (GTIOOpinionRequest*)newOpinionRequestRespectingPreviousSettings {
	NSData* archivedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"gtioOpinionRequest"];
	if (archivedData) {		
		return [[NSKeyedUnarchiver unarchiveObjectWithData:archivedData] retain];
	} else {
		return [[GTIOOpinionRequest alloc] init];
	}
}

#pragma mark Actions

- (void)showTellUsAboutItView {
    GTIOAnalyticsEvent(kUserDidViewTellUsAboutItEventName);
	NSDictionary* query = [NSDictionary dictionaryWithObject:_opinionRequest forKey:@"opinionRequest"];
	[[TTNavigator navigator] openURLAction:
	 [[[TTURLAction actionWithURLPath:@"gtio://getAnOpinion/tellUsAboutIt"] applyQuery:query] applyAnimated:YES]];
}

- (void)start {
    GTIOAnalyticsEvent(kUploadGetStartedEventName);
	GTIOUser* currentUser = [GTIOUser currentUser];
	if (currentUser.isLoggedIn) {
		[_opinionRequest release];
		_opinionRequest = [self newOpinionRequestRespectingPreviousSettings];
		[self presentPhotoSourceActionSheet:YES];
	} else {
		// Watch for login to complete or be canceled
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userDidLogin) 
													 name:kGTIOUserDidLoginNotificationName 
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(removeLoginObservers) 
													 name:kGTIOUserDidCancelLoginNotificationName 
												   object:nil];
		//[currentUser login];
        TTOpenURL(@"gtio://login");
	}		
}

- (void)next {
	if (1 == [_opinionRequest.photos count]) {
		[self presentDoneWithPhotosOrAddAnotherActionSheet];
	} else {
		[self.navigationController dismissModalViewControllerAnimated:YES];
		[self performSelector:@selector(showPhotosPreview) withObject:nil afterDelay:1.0];
	}	
}

- (void)showPhotosPreview {
	NSDictionary* query = [NSDictionary dictionaryWithObject:_opinionRequest forKey:@"opinionRequest"];
	[[TTNavigator navigator] openURLAction:
	 [[[TTURLAction actionWithURLPath:@"gtio://getAnOpinion/photosPreview"] 
	   applyQuery:query]
	  applyAnimated:YES]];
}

// Cancels out the Take a Picture modal
- (void)cancel {
    [_locationManager stopUpdatingLocation];
	GTIOTakeAPictureViewController* viewController = (GTIOTakeAPictureViewController*) [TTNavigator navigator].topViewController;
	[_opinionRequest.photos removeObject:viewController.photo];
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
	// If there are any photos left, just show the preview screen?
	if ([_opinionRequest.photos count] > 0) {
		[self performSelector:@selector(showPhotosPreview) withObject:nil afterDelay:1.0];
	}
}

- (void)submit {
    [_locationManager stopUpdatingLocation];
	TTActivityLabel* label = [[[TTActivityLabel alloc] initWithFrame:TTScreenBounds() style:TTActivityLabelStyleBlackBox text:@"loading..."] autorelease];
	label.tag = kGTIOActivityLabelTag;
	[self.window addSubview:label];
	
	_submission = [[GTIOOpinionRequestSubmission alloc] initWithOpinionRequest:self.opinionRequest delegate:self];
	[_submission send];
}

- (void)hideLoading {
	[[self.window viewWithTag:kGTIOActivityLabelTag] removeFromSuperview];
}

- (void)cancelUpload {
    [self hideLoading];
    [_submission cancel];
    [_submission release];
    _submission = nil;
    [_opinionRequest.photos removeAllObjects];
}

- (void)shareWithContacts {
	TTOpenURL(@"gtio://analytics/trackUserDidViewContacts");
	NSDictionary* query = [NSDictionary dictionaryWithObject:self.opinionRequest forKey:@"opinionRequest"];
	[[TTNavigator globalNavigator] openURLAction:
	 [[[TTURLAction actionWithURLPath:@"gtio://contacts"] 
	  applyQuery:query]
	  applyAnimated:YES]];
}

- (void)editPhoto:(NSString*)photoNumber {
	int photoIndex = [photoNumber intValue];
	if (photoIndex < [_opinionRequest.photos count]) {
		GTIOPhoto* photo = [_opinionRequest.photos objectAtIndex:photoIndex];
		NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:photo, @"photo", 
							   [NSNumber numberWithBool:YES], @"useDoneButton", 
							   [NSNumber numberWithBool:NO], @"useCancelButton", 
							   nil];
		[[TTNavigator navigator] openURLAction:
		 [[[TTURLAction actionWithURLPath:@"gtio://takeAPicture"]
		   applyQuery:query]
		  applyAnimated:YES]];
	}
}

- (void)presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
	UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.sourceType = sourceType;
	imagePickerController.delegate = self;
    
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [imagePickerController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
    
	[self.topViewController presentModalViewController:imagePickerController animated:YES];
	[imagePickerController release];
}

#pragma mark Action Sheets

- (void)presentPhotoSourceActionSheet:(BOOL)showGuidelines {
	if (!showGuidelines && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[self.navigationController dismissModalViewControllerAnimated:NO];
		[self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		return;
	}
	
	UIActionSheet*   actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															   delegate:self
													  cancelButtonTitle:nil
												 destructiveButtonTitle:nil
													  otherButtonTitles:nil];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[actionSheet addButtonWithTitle:@"take a photo"];
	}
	_getAnOpinionChooseFromLibraryButtonIndex = [actionSheet addButtonWithTitle:@"choose from library"];
	if (showGuidelines) {
		_cancelButtonIndex = [actionSheet addButtonWithTitle:@"photo guidelines"];
	}
	[actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:@"cancel"]];
	
	actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
	actionSheet.tag = kGTIOGetAnOpinionPhotoSourceActionSheetTag;
	[actionSheet showInView:self.window];
	[actionSheet release];
}

- (void)presentPhotoSourceActionSheetWithoutGuidelines {
	[self presentPhotoSourceActionSheet:NO];
}

- (void)presentDoneWithPhotosOrAddAnotherActionSheet {
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"comparing more than one?" 
															 delegate:self 
													cancelButtonTitle:@"cancel" 
											   destructiveButtonTitle:nil 
													otherButtonTitles:@"no, done with photos", @"yes, add another", nil];
	actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
	actionSheet.tag = kGTIOGetAnOpinionDoneWithPhotosOrAddAnotherActionSheetTag;
	[actionSheet showInView:self.window];
}

#pragma mark UIActionSheetDelegate

- (void)photoSourceActionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [_locationManager startUpdatingLocation];
    
	if (actionSheet.cancelButtonIndex == buttonIndex) {
		return;
	}
	
	if(_cancelButtonIndex == buttonIndex) {
		[[TTNavigator navigator] openURLAction:
		 [[TTURLAction actionWithURLPath:@"gtio://photoGuidelines"] applyAnimated:YES]];
		
		return;
	}
	
	[self.navigationController dismissModalViewControllerAnimated:NO];
	UIImagePickerControllerSourceType sourceType = (_getAnOpinionChooseFromLibraryButtonIndex == buttonIndex) ? 
	UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;	
	[self presentImagePickerWithSourceType:sourceType];
}

- (void)doneWithPhotosOrAddAnotherActionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (kGTIOPhotoActionSheetCancelButtonIndex == buttonIndex) {
		// Nothing to do
		return;
	} else if (kGTIOPhotoActionSheetDoneWithPhotosButtonIndex == buttonIndex) {
		[self.navigationController dismissModalViewControllerAnimated:YES];
		[self performSelector:@selector(showTellUsAboutItView) withObject:nil afterDelay:1.0];
	} else if (kGTIOPhotoActionSheetAddAnotherOutfitButtonIndex) {
		[self presentPhotoSourceActionSheet:NO];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (kGTIOGetAnOpinionPhotoSourceActionSheetTag == actionSheet.tag) {
		[self photoSourceActionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
	} else if (kGTIOGetAnOpinionDoneWithPhotosOrAddAnotherActionSheetTag == actionSheet.tag) {
		[self doneWithPhotosOrAddAnotherActionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
	}
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	// Scale the image appropriately
	UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    /* Analize EXIF Data */
    CGImageRef imageRef = [image CGImage];
    CGImageSourceRef source = CGImageSourceCreateWithData(UIImageJPEGRepresentation(image, 1.0), NULL);
    NSDictionary* metadata = CGImageSourceCopyPropertiesAtIndex(source,0, NULL);
    
    NSLog(@"Dict: %@", metadata);
    /* end */
    
	UIImageOrientation originalOrientation = image.imageOrientation;
	
	/**
 	 iPhone 4: 2592x1936
	 iPhone 3GS: 2048×1536	 
	 iPhone 3: 1600x1200
	 */
	// Target 560 height for everything
	NSLog(@"Photo info returned from camera is: %@", info);
	float scaleFactor = 1.0;
	UIDeviceHardware* deviceHardware = [UIDeviceHardware deviceHardware];
	if ([deviceHardware isiPhone3G]) {
		scaleFactor = 0.5;
	} else if ([deviceHardware isiPhone3GS]) {
		scaleFactor = 0.5;
	} else if ([deviceHardware isiPhone4]) {
		scaleFactor = 0.75;
	} else {
		scaleFactor = 0.5;
	}

	NSLog(@"Applying a scale of %f", scaleFactor);
	image = [image imageWithScale:scaleFactor];
	if (originalOrientation != UIImageOrientationUp) {
		image = [image rotate:originalOrientation];
	}
	
	GTIOPhoto* photo = [[GTIOPhoto alloc] init];
	photo.image = image;	
	[self.opinionRequest.photos addObject:photo];
	
	// Dismiss this after we add the photo so the overlay view shows up on the get an oppinion tab.
	[picker dismissModalViewControllerAnimated:NO];
	
	// If this is the first picture, invoke the Take a Picture controller
	NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:photo, @"photo", 
						   [NSNumber numberWithBool:NO], @"useDoneButton", 
						   [NSNumber numberWithBool:YES], @"useCancelButton", 
						   nil];
	[[TTNavigator navigator] openURLAction:
	 [[[TTURLAction actionWithURLPath:@"gtio://takeAPicture"]
	   applyQuery:query] 
	  applyAnimated:YES]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:NO];
	GTIOPhoto* photo = [self.opinionRequest.photos lastObject];
	
	// If this is the first picture, invoke the Take a Picture controller
	if (NO == [self.topViewController isKindOfClass:[GTIOPhotosPreviewViewController class]] && nil != photo) {
		BOOL useDoneButton = [self.opinionRequest.photos count] > 1;
		NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:photo, @"photo", [NSNumber numberWithBool:useDoneButton], @"useDoneButton", nil];
		[[TTNavigator navigator] openURLAction:
		 [[[TTURLAction actionWithURLPath:@"gtio://takeAPicture"]
		   applyQuery:query] 
		  applyAnimated:YES]];
	}
}

#pragma mark GTIOOpinionRequestSubmissionDelegate

- (void)submissionDidSucceed:(GTIOOpinionRequestSubmission*)submission withOutfit:(GTIOOutfit*)outfit {
	// Track the details (NOTE: must track details before removing photos!)
	[[GTIOAnalyticsTracker sharedTracker] trackOpinionRequestSubmittedWithInfoDict:[_opinionRequest infoDict]];
	
	// Remove the photos
	[_opinionRequest.photos removeAllObjects];
	
    [self hideLoading];
	
    UIViewController* homeController = TTOpenURL(@"gtio://home");
    
    if (outfit) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        GTIOStaticOutfitListModel* staticModel = [GTIOStaticOutfitListModel modelWithOutfits:[NSArray arrayWithObject:outfit]];
        // manage showing outfits from a sectioned list.
        GTIOOutfitViewController* viewController = [[GTIOOutfitViewController alloc] initWithModel:staticModel outfitIndex:0];
        [homeController.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
//    TTOpenURL([NSString stringWithFormat:@"gtio://profile/look/%@", submission.outfitURL]);
//	TTDINFO(@"Loading submitted URL: %@", submission.outfitURL);

	[_submission release];
    _submission = nil;
	
	// Persist the settings for next time
	[self persistOpinionRequestToUserDefaults];		
}

- (void)submission:(GTIOOpinionRequestSubmission*)submission didFailWithErrorMessage:(NSString*)errorMessage {
    [self hideLoading];
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Rats! An error occurred" 
														message:errorMessage
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
	[_submission release];
    _submission = nil;
}

- (void)popViewController {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootViewController {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    _opinionRequest.location = newLocation;
}

@end
