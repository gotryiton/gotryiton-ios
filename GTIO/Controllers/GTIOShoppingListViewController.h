//
//  GTIOShoppingListViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/18/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"
#import "GTIOProductTableViewCell.h"
#import "GTIOProductOptionAddButton.h"

@interface GTIOShoppingListViewController : GTIOViewController <UITableViewDelegate, UITableViewDataSource, GTIOProductTableViewCellDelegate, UIAlertViewDelegate, GTIOProductOptionAddButtonDelegate>

@end