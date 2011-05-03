//
//  GTIOBadge.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GTIOBadge : RKObject {
	NSString* _type;
	NSNumber* _since;
	NSString* _imgURL;
}

@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSNumber *since;
@property (nonatomic, copy) NSString *imgURL;

@end
