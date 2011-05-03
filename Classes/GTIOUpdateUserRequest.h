//
//  GTIOUpdateUserRequest.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/30/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOUser.h"

@interface GTIOUpdateUserRequest : NSObject {
	TTURLRequest* _request;
	id _delegate;
	SEL _selector;
	NSError* _error;
}

@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) TTURLRequest *request;
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) SEL selector;

+ (id)updateUser:(GTIOUser*)user delegate:(id)delegate selector:(SEL)selector;

@end
