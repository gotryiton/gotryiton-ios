//
//  GTIOQuickAddTableCell.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOUser.h"

@protocol GTIOQuickAddTableCellDelegate <NSObject>

@required
- (void)checkboxStateChanged:(GTIOButton *)checkbox;

@end

@interface GTIOQuickAddTableCell : UITableViewCell

@property (nonatomic, strong) GTIOUser *user;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<GTIOQuickAddTableCellDelegate> delegate;

@end
