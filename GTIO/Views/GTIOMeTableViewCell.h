//
//  GTIOMeTableViewCell.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOSwitch.h"

@interface GTIOMeTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL hasHeart;
@property (nonatomic, assign) BOOL hasToggle;
@property (nonatomic, assign) BOOL hasChevron;

@property (nonatomic, assign) GTIOSwitchChangeHandler toggleHandler;

- (void)setToggleState:(BOOL)on;

@end
