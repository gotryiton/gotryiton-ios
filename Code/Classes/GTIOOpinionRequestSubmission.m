//
//  GTIOOpinionRequestSubmission.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/8/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
//  submits GTIOOpinionRequest
//


#import "GTIOOpinionRequestSubmission.h"
#import "TTURLJSONResponse.h"
#import "GTIOUser.h"
#import "GTIOPhoto.h"
#import "UIImage+Manipulation.h"
#import <RestKit/ObjectMapping/RKErrorMessage.h>

@implementation GTIOOpinionRequestSubmission

@synthesize opinionRequest = _opinionRequest;
@synthesize delegate = _delegate;
@synthesize outfitURL = _outfitURL;
@synthesize photosAdded = _photosAdded;
@synthesize totalPhotos = _totalPhotos;
@synthesize sid = _sid;

+ (GTIOOpinionRequestSubmission*)submissionWithOpinionRequest:(GTIOOpinionRequest*)opinionRequest delegate:(NSObject<GTIOOpinionRequestSubmissionDelegate>*)delegate {
	return [[[self alloc] initWithOpinionRequest:opinionRequest delegate:delegate] autorelease];
}

- (id)initWithOpinionRequest:(GTIOOpinionRequest*)opinionRequest delegate:(NSObject<GTIOOpinionRequestSubmissionDelegate>*)delegate {
	if (self = [self init]) {
		_opinionRequest = [opinionRequest retain];
		_delegate = [delegate retain];
	}
	
	return self;
}

- (void)dealloc {
	[_delegate release];
	[_opinionRequest release];
	[_outfitURL release];
	[_sid release];
	
	[super dealloc];
}

- (void)send {
    _loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/upload/") delegate:self];
    
	NSString* publicValue = self.opinionRequest.isPublic ? @"1" : @"0";
	NSString* stylistsValue = self.opinionRequest.shareWithStylists ? @"1" : @"0";
    NSString* latitude = [NSString stringWithFormat:@"%f", self.opinionRequest.location.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%f", self.opinionRequest.location.coordinate.longitude];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:publicValue, @"public",
                          stylistsValue, @"shareWithStylists",
                          self.opinionRequest.whereYouAreGoing, @"eventId",
                          self.opinionRequest.tellUsMoreAboutIt, @"description",
                          latitude, @"latitude", 
                          longitude, @"longitude", nil];
    
    RKParams* params = [RKParams paramsWithDictionary:[GTIOUser paramsByAddingCurrentUserIdentifier:dict]];
    
    NSArray* photos = self.opinionRequest.photos;
	for (GTIOPhoto* photo in photos) {
		NSUInteger number = [photos indexOfObject:photo] + 1;
		NSString* fileParam = [NSString stringWithFormat:@"image%d", number];
		NSString* brandsParam = [NSString stringWithFormat:@"outfit%dBrands", number];
		
		// Scale image down to a max heigh tof 560px right before submission
		UIImage* image = photo.image;
		float scaleFactor = 560.0/image.size.height;
		UIImage* scaledImage = [image imageWithScale:scaleFactor];
		
        RKParamsAttachment* attachment = [params setData:UIImageJPEGRepresentation(scaledImage, 1) forParam:fileParam];
        attachment.MIMEType = @"image/jpeg";
        attachment.fileName = [NSString stringWithFormat:@"%@.jpg", fileParam];
        if (photo.brandsYouAreWearing) {
            [params setValue:photo.brandsYouAreWearing forParam:brandsParam];
        }
	}
    
    _loader.params = params;
    _loader.method = RKRequestMethodPOST;
    [_loader send];
}

- (void)cancel {
    _loader.delegate = nil;
    _delegate = nil;
    [_loader cancel];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    [_delegate submission:self didFailWithErrorMessage:[error localizedDescription]];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Response: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)objectDictionary {
    NSLog(@"Object Dictionary: %@", objectDictionary);
    RKErrorMessage* error = [objectDictionary objectForKey:@"error"];
    if (error) {
        [_delegate submission:self didFailWithErrorMessage:[error errorMessage]];
        return;
    }
    [self performSelector:@selector(informDelegateOfSuccessWithOutfit:) withObject:[objectDictionary objectForKey:@"outfit"] afterDelay:0.1];
}

- (void)informDelegateOfSuccessWithOutfit:(id)outfit {
    [_delegate submissionDidSucceed:self withOutfit:outfit];
}

@end
