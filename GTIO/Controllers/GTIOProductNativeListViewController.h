//
//  GTIOProductNativeListViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"
#import "GTIOProductTableViewCell.h"

@interface GTIOProductNativeListViewController : GTIOViewController <UITableViewDelegate, UITableViewDataSource, GTIOProductTableViewCellDelegate>

@property (nonatomic, strong) NSNumber *collectionID;

@end
