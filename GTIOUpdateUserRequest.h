//
//  GTIOUpdateUserRequest.h
//  GTIO
//
//  Created by Daniel Hammond on 5/23/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOUpdateUserRequest : NSObject {
    
}

+ (id)updateUser:(GTIOUser*)user delegate:(id)delegate selector:(SEL)selector;

@end
