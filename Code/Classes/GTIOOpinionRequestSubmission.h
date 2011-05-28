//
//  GTIOOpinionRequestSubmission.h
//  GoTryItOn
//
//  Created by Blake Watters on 9/8/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOOpinionRequest.h"

@protocol GTIOOpinionRequestSubmissionDelegate;

@interface GTIOOpinionRequestSubmission : NSObject <RKObjectLoaderDelegate> {
	GTIOOpinionRequest* _opinionRequest;
	NSObject<GTIOOpinionRequestSubmissionDelegate>* _delegate;
	TTURLRequest* _request; // TODO : Remove this?
	
	NSURL* _outfitURL;
	NSUInteger _photosAdded;
	NSUInteger _totalPhotos;
	NSString* _sid;	
}

/**
 * The Opinion Request we are submittion to GTIO for review
 */
@property (nonatomic, readonly) GTIOOpinionRequest* opinionRequest;

/**
 * The delegate object for this submission
 */
@property (nonatomic, readonly) NSObject<GTIOOpinionRequestSubmissionDelegate>* delegate;

// Response Properties

/**
 * The URL to the look page we created on GTIO
 */
@property (nonatomic, readonly) NSURL* outfitURL;

/**
 * The number of photos added to the look
 */
@property (nonatomic, readonly) NSUInteger photosAdded;

/**
 * The total number of photos in the look
 */
@property (nonatomic, readonly) NSUInteger totalPhotos;

/**
 * The server side ID of the look
 */
@property (nonatomic, readonly) NSString* sid;

/**
 * Initialize a new submission ready for sending to GTIO
 */
- (id)initWithOpinionRequest:(GTIOOpinionRequest*)opinionRequest delegate:(NSObject<GTIOOpinionRequestSubmissionDelegate>*)delegate;

/**
 * Send the request to GTIO
 */
- (void)send;

@end

#pragma mark -

@protocol GTIOOpinionRequestSubmissionDelegate

/**
 * Sent to the delegate when the opinion request was processed successfully by GTIO
 */
- (void)submissionDidSucceed:(GTIOOpinionRequestSubmission*)submission;

/**
 * Sent to the delegate when the opinion request failed submission
 */
- (void)submission:(GTIOOpinionRequestSubmission*)submission didFailWithErrorMessage:(NSString*)errorMessage;

@end
