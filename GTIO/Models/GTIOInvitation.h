//
//  GTIOInvitation.h
//  GTIO
//
//  Created by Simon Holroyd on 7/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOInvitation : NSObject

@property (nonatomic, strong) NSURL *twitterURL;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *invitationID;

@end

