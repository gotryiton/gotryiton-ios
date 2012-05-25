//
//  GTIOAlmostDoneViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOAlmostDoneTableCell.h"

@interface GTIOAlmostDoneViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, GTIOAlmostDoneTableCellDelegate>

- (void)updateDataSourceWithValue:(id)value ForKey:(NSString*)key;

@end
