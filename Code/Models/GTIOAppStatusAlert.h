//
//  GTIOAppStatusAlert.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface GTIOAppStatusAlert : RKObject <UIAlertViewDelegate> {
	NSString* _title;
	NSString* _message;
	NSString* _cancelButtonTitle;
	NSArray* _buttons;
	NSNumber* _alertID;
}

@property (nonatomic, retain) NSNumber *alertID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSArray *buttons;

- (void)show;

@end