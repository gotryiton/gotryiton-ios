//
//  GTIOAppStatusAlertButton.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GTIOAppStatusAlertButton : RKObject {
	NSString* _title;
	NSString* _url;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

@end
