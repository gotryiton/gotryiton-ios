//
//  GTIOMeTableViewCell.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOSwitch.h"

@protocol GTIOMeTableViewCellToggleDelegate <NSObject>

@required
- (void)updateSwitchAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GTIOMeTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL hasHeart;
@property (nonatomic, assign) BOOL hasToggle;
@property (nonatomic, assign) BOOL hasChevron;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<GTIOMeTableViewCellToggleDelegate> toggleDelegate;

- (void)setToggleState:(BOOL)on;

@end
