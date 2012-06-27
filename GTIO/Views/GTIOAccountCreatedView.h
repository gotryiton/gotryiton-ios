//
//  GTIOAccountCreatedView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTIOAccountCreatedDelegate <NSObject>

@required
- (void)pushEditProfileViewController;

@end

@interface GTIOAccountCreatedView : UIView

@property (nonatomic, weak) id<GTIOAccountCreatedDelegate> delegate;

- (void)refreshUserData;

@end
