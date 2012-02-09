//
//  SXYAlertView.h
//  GTIO
//
//  Created by Jeremy Ellison on 2/9/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SXYAlertAction)(int buttonIndex);

@interface SXYAlertView : UIAlertView <UIAlertViewDelegate>

@property (nonatomic, retain) SXYAlertAction action;

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message action:(SXYAlertAction)block cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
