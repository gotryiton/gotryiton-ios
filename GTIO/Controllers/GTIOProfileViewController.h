//
//  GTIOProfileViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"
#import "GTIOFollowRequestAcceptBarView.h"

@interface GTIOProfileViewController : GTIOViewController <GTIOFollowRequestAcceptBarViewDelegate>

@property (nonatomic, copy) NSString *userID;

@end
