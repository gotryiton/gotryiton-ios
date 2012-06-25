//
//  GTIOProfileCalloutView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOProfileCallout.h"
#import "GTIOUser.h"

@interface GTIOProfileCalloutView : UIView

@property (nonatomic, strong) GTIOProfileCallout *profileCallout;
@property (nonatomic, strong) GTIOUser *user;

- (void)setProfileCallout:(GTIOProfileCallout *)profileCallout user:(GTIOUser *)user;

@end
