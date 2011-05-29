//
//  GTIOOpinionRequestSession.h
//  GoTryItOn
//
//  Created by Blake Watters on 8/30/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOOpinionRequestSession manages the creation of a [GTIOOpinionRequest](GTIOOpinionRequest) allowing the user to submit an outfit/look

#import "GTIOOpinionRequest.h"
#import "GTIOTakeAPictureViewController.h"
#import "GTIOOpinionRequestSubmission.h"
@interface GTIOOpinionRequestSession : NSObject <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, GTIOOpinionRequestSubmissionDelegate> {
	GTIOOpinionRequest* _opinionRequest;
	NSUInteger _cancelButtonIndex;
}

// TODO: Should be read-only...
@property (nonatomic, retain) GTIOOpinionRequest* opinionRequest;

/**
 * Returns the global session
 */
+ (GTIOOpinionRequestSession*)globalSession;

/**
 * Presents the initial action sheet to begin the session
 */
- (void)start;

/**
 * Cancel the session and abandon the current image
 */
- (void)cancel;

/**
 * Shows the action sheet asking the user if
 */
- (void)next;

/**
 * Submit the opinion request to GTIO
 */
- (void)submit;

/**
 * Show the Share with Contacts screen
 */
- (void)shareWithContacts;

/**
 * Shows the photo source action sheet without the photo guidelines option
 */
- (void)presentPhotoSourceActionSheetWithoutGuidelines;

@end
