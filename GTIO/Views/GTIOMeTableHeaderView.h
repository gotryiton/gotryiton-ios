//
//  GTIOMeTableHeaderView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOMeViewController.h"
#import "GTIOUser.h"

@interface GTIOMeTableHeaderView : UIView

@property (nonatomic, strong) GTIOUser *user;
@property (nonatomic, strong) NSArray *userInfoButtons;
@property (nonatomic, copy) GTIOButtonDidTapHandler editButtonTapHandler;
@property (nonatomic, copy) GTIOButtonDidTapHandler profilePictureTapHandler;
@property (nonatomic, assign) BOOL usesGearInsteadOfPencil;
@property (nonatomic, weak) id<GTIOMeTableHeaderViewDelegate> delegate;

- (void)refreshUserData;

@end
