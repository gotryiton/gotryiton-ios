//
//  GTIOChangeItReason.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GTIOChangeItReason : RKObject {
	NSNumber* _reasonID;
	NSNumber* _display;
	NSString* _text;
}

@property (nonatomic, retain) NSNumber* reasonID;
@property (nonatomic, retain) NSNumber* display;
@property (nonatomic, copy) NSString *text;

@end
