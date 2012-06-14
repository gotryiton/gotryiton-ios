//
//  GTIOReturningUsersViewController.h
//  GTIO
//
//  Created by Scott Penrose on 5/17/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOUser.h"

@interface GTIOReturningUsersViewController : UIViewController

@property (nonatomic, copy) GTIOLoginHandler loginHandler;

- (id)initForReturningUsers:(BOOL)returning;

@end
