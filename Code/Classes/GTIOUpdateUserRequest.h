//
//  GTIOUpdateUserRequest.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/30/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOUpdateUserRequest handles updating a user's profile data

#import <Foundation/Foundation.h>
#import "GTIOUser.h"

@interface GTIOUpdateUserRequest : NSObject {
	TTURLRequest* _request;
	id _delegate;
	SEL _selector;
	NSError* _error;
}
/// Error object
@property (nonatomic, retain) NSError *error;
/// url request
@property (nonatomic, retain) TTURLRequest *request;
/// delegate
@property (nonatomic, retain) id delegate;
/// selector to call on delegate when complete
@property (nonatomic, assign) SEL selector;
/// fires a GTIOUpdateUserRequest with the given user and will perform selector on delegate when done
+ (id)updateUser:(GTIOUser*)user delegate:(id)delegate selector:(SEL)selector;

@end
