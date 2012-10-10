//
//  GTIOUniqueNameSplashViewController.m
//  GTIO
//
//  Created by Simon Holroyd on 10/10/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUniqueNameSplashViewController.h"
#import "GTIOAlmostDoneTableDataItem.h"
#import "GTIOAlmostDoneTableCell.h"
#import "GTIOUIImage.h"
#import "GTIOUser.h"

@interface GTIOUniqueNameSplashViewController ()

@end

@implementation GTIOUniqueNameSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {    

        self.saveData = [NSMutableDictionary dictionary];
  
        self.tableData = [NSArray arrayWithObjects:
                  [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"unique_name" andTitleText:@"@username" andPlaceHolderText:@"@gotryiton" andAccessoryText:[[GTIOUser currentUser] uniqueName] andPickerItems:nil isRequired:YES usesPicker:NO isMultiline:NO characterLimit:25 usesNameValidation:YES],
                  nil];
        
        [self saveDataItems];
    
    }
    return self;
}


- (void)viewDidLoad
{

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[GTIOUIImage imageNamed:@"quick-add-bg.png"]];
    [backgroundImageView setFrame:CGRectOffset(backgroundImageView.frame, 0, -20)];
    [self.view addSubview:backgroundImageView];

    [super viewDidLoad];
	

    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"claim your username!" italic:YES];
    [self useTitleView:navTitleView];

    __block typeof(self) blockSelf = self;
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeSkipGrayTopMargin tapHandler:^(id sender) {
        if (blockSelf.dismissHandler) {
            blockSelf.dismissHandler(blockSelf);
        }
    }];
    self.rightNavigationButton = backButton;

    
}

#pragma mark - TableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIOAlmostDoneTableCell *cell = (GTIOAlmostDoneTableCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];

    cell.cellTitleLabel.hidden = YES;
    
    [cell.cellAccessoryText setReturnKeyType:UIReturnKeyDone];

    return cell;
}

@end
