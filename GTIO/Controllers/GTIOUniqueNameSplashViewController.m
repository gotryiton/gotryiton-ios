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

static CGFloat const kGTIOEditingViewLeftPadding = 26.0;
static CGFloat const kGTIOEditingCellLeftPadding = -36.0;
static CGFloat const kGTIOEditingCellTopPadding = 3.0;

@interface GTIOUniqueNameSplashViewController ()

@property (nonatomic, assign) BOOL formEnabled;
@property (nonatomic, strong) GTIOUIButton *saveButton;

@end

@implementation GTIOUniqueNameSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {    

        self.saveData = [NSMutableDictionary dictionary];
  
        self.tableData = [NSArray arrayWithObjects:
                  [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"unique_name" andTitleText:@"@username" andPlaceHolderText:@"type a username" andAccessoryText:[[GTIOUser currentUser] uniqueName] andPickerItems:nil isRequired:YES usesPicker:NO isMultiline:NO characterLimit:25 usesNameValidation:YES],
                  nil];
        
        [self saveDataItems];
        
        _formEnabled = YES;

        _saveButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeUniqueNameSave tapHandler:^(id sender) {
        if (self.formEnabled) {
            // dismiss keyboard
            [self dismissKeyboard];
            // form validation
            NSMutableArray *missingDataElements = [NSMutableArray array];
            for (GTIOAlmostDoneTableDataItem *dataItem in self.tableData) {
                if ([dataItem required]) {
                    if ([[self.saveData valueForKey:[dataItem apiKey]] length] == 0) {
                        [missingDataElements addObject:[dataItem titleText]];
                    }
                }
            }
            if ([missingDataElements count] > 0) {
                GTIOAlertView *missingRequiredData = [[GTIOAlertView alloc] initWithTitle:@"oops!" message:@"Please enter a username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [missingRequiredData show];
            } else {
                [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
                NSDictionary *trackingInformation = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"edit_profile", @"id",
                                                     @"unique_name", @"screen",
                                                     nil];
                __block typeof(self) blockSelf = self;
                [[GTIOUser currentUser] updateCurrentUserWithFields:self.saveData withTrackingInformation:trackingInformation andLoginHandler:^(GTIOUser *user, NSError *error) {
                    [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                    if (!error) {
                        blockSelf.dismissHandler(blockSelf);
                    } else {
                        [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:nil];
                    }
                }];
            }
        }
    }];
    }
    return self;
}


- (void)viewDidLoad
{
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"claim your username!" italic:YES];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[GTIOUIImage imageNamed:@"quick-add-bg.png"]];
    [backgroundImageView setFrame:CGRectOffset(backgroundImageView.frame, 0, -20)];
    [self.view addSubview:backgroundImageView];

    UIImageView *editingBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"claim-username-overlay.png"]];
    [editingBackgroundView setFrame:(CGRect){kGTIOEditingViewLeftPadding, (self.view.frame.size.height )/2 - editingBackgroundView.bounds.size.height/2 - self.view.frame.origin.y, editingBackgroundView.bounds.size}];

    [self.view addSubview:editingBackgroundView];

    [super viewDidLoad];
	
    
    [self useTitleView:navTitleView];

    __block typeof(self) blockSelf = self;
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeSkipGrayTopMargin tapHandler:^(id sender) {
        if (blockSelf.dismissHandler) {
            blockSelf.dismissHandler(blockSelf);
        }
    }];
    self.rightNavigationButton = backButton;

    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setScrollEnabled:NO];
    [self.tableView setFrame:(CGRect){kGTIOEditingCellLeftPadding, editingBackgroundView.frame.origin.y + kGTIOEditingCellTopPadding, self.tableView.frame.size}];

    
    [self.saveButton setFrame:(CGRect){editingBackgroundView.frame.origin.x + 19, editingBackgroundView.frame.origin.y + 69, self.saveButton.frame.size }];
    [self.view addSubview:self.saveButton];

    
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
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)validateName:(NSString *)name{
    [super validateName:name];
    [self.saveButton setEnabled:NO];   
}

- (void)setValidationStatusIsValid:(BOOL)valid
{
    if (valid){
        [self.saveButton setEnabled:YES];
        [self.saveButton setTitle:@"save this username" forState:UIControlStateDisabled];
        [self.validationCell setStatusIndicatorStatus:GTIOAlmostDoneTableCellStatusSuccess];
    } else {
        [self.saveButton setEnabled:NO];
        [self.saveButton setTitle:@"unavailable, try again!" forState:UIControlStateDisabled];
        [self.validationCell setStatusIndicatorStatus:GTIOAlmostDoneTableCellStatusFailure];
    }
}

@end
