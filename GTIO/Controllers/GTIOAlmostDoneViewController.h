//
//  GTIOAlmostDoneViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOAlmostDoneTableCell.h"
#import "GTIOViewController.h"
#import <RestKit/RestKit.h>

@interface GTIOAlmostDoneViewController : GTIOViewController <UITableViewDelegate, RKObjectLoaderDelegate, UITableViewDataSource, GTIOAlmostDoneTableCellDelegate>

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGRect originalContentFrame;
@property (nonatomic, strong) NSURL *profilePicture;
@property (nonatomic, strong) NSMutableDictionary *saveData;
@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, strong) GTIOAlmostDoneTableCell *validationCell;

- (void)updateDataSourceWithValue:(id)value ForKey:(NSString*)key;
- (void)dismissKeyboard;
- (void)saveDataItems;
- (void)validateName:(NSString *)name;

@end