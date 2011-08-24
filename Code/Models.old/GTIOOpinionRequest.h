//
//  GTIOOpinionRequest.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * GTIOOpinionRequest blah blah blah blah blah blah blah blah 
 * blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah 
 * blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah
*/

@interface GTIOOpinionRequest : NSObject <NSCoding> {
	NSMutableArray* _photos; // GTIOPhoto
	BOOL _shareWithStylists;
	BOOL _public;
	NSMutableArray* _contactEmails;
	NSNumber* _whereYouAreGoing;
	NSString* _tellUsMoreAboutIt;
    CLLocation* _location;
}

@property (nonatomic, copy)		NSMutableArray *photos;
@property (nonatomic, assign)	BOOL isPublic;
@property (nonatomic, assign)	BOOL shareWithStylists;
@property (nonatomic, readonly)	NSMutableArray* contactEmails;
@property (nonatomic, copy)		NSNumber* whereYouAreGoing;
@property (nonatomic, copy)		NSString* tellUsMoreAboutIt;
@property (nonatomic, retain)   CLLocation* location;

/**
 * Return an array of valid choices for "where you're going"
 */
@property (nonatomic, readonly) NSArray* whereYouAreGoingChoices;

/**
 * Returns YES when the opinion request is valid
 */
@property (nonatomic, readonly) BOOL isValid;

/**
 * Returns YES when another photo can be added to the opinion request (maximum of 4 photos)
 */
@property (nonatomic, readonly) BOOL canAddAnotherPhoto;

/**
 * Returns an array of messages indicating why the opinion request is not valid
 */
- (NSArray*)validationErrors;

/**
 * Returns a summary of all validation errors as a hyphenated list
 */
- (NSString*)validationErrorsSummary;

/**
 * Returns the index to be submitted for the event type selected
 */
- (NSNumber*)indexForEventType:(NSString*)type;

/**
 * Returns YES if any photo had a blur mask applied to it
 */
- (BOOL)wasBlurAppliedToAnyPhoto;

/**
 * Returns a string encoding the configuration of this opinion request. This is used
 * by the analytics tracking as the label for the upload action, exposing the user's
 * configuration to Flurry for analysis.
 */
- (NSDictionary*)infoDict;

@end
