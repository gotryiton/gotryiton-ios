//
//  GTIOUpdateUserRequest.m
//  GTIO
//
//  Created by Daniel Hammond on 5/23/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOUpdateUserRequest.h"


@implementation GTIOUpdateUserRequest

+ (id)updateUser:(GTIOUser*)user delegate:(id)delegate selector:(SEL)selector {
	NSLog(@"User Params: %@", user);
    // This allows us to check for this alert as a means to test the api would be hit
    TTAlert(@"Updating User"); 
    return nil;
}

- (TTURLRequest*)request {return nil;}
- (NSError*)error {return nil;}
- (id)delegate {return nil;}
- (SEL)selector {return nil;}

@end
