//
//  GTIOSignInViewController.h
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "TTTAttributedLabel.h"
#import "GTIOUser.h"

@interface GTIOSignInViewController : UIViewController <TTTAttributedLabelDelegate>

@property (nonatomic, copy) GTIOLoginHandler loginHandler;

- (void)track;

@end
