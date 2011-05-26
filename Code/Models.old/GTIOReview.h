//
//  GTIOReview.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "GTIOProfile.h"
#import "GTIOOutfit.h"

@interface GTIOReview : NSObject {
	NSString* _outfitID;
	NSString* _uid;
	NSString* _reviewID;
	NSNumber* _timestamp;
	NSString* _text;
	GTIOProfile* _user;
	NSNumber* _agreeVotes;
	NSNumber* _flags;
    GTIOOutfit* _outfit;
}

@property (nonatomic, retain) NSNumber *agreeVotes;
@property (nonatomic, retain) NSNumber *flags;
@property (nonatomic, copy) NSString *outfitID;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *reviewID;
@property (nonatomic, retain) NSNumber *timestamp;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) GTIOProfile *user;
@property (nonatomic, retain) GTIOOutfit* outfit;

@end
