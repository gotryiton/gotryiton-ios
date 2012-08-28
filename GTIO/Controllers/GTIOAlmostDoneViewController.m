//
//  GTIOAlmostDoneViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAlmostDoneViewController.h"
#import "GTIOAlmostDoneTableHeaderCell.h"
#import "GTIOPickerViewForTextFields.h"
#import "GTIOEditProfilePictureViewController.h"
#import "GTIOUser.h"
#import "GTIOProgressHUD.h"
#import "GTIOAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "GTIOAlmostDoneTableDataItem.h"
#import "GTIOQuickAddViewController.h"

static NSInteger kGTIOGTIOMinimumAge = 13;

@implementation GTIOAlmostDoneViewController

@synthesize tableData = _tableData, tableView = _tableView, originalContentFrame = _originalContentFrame, profilePicture = _profilePicture, saveData = _saveData, textFields = _textFields;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {    
        NSMutableArray *selectableYears = [NSMutableArray array];
        NSDate *startDate = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setYear:-kGTIOGTIOMinimumAge];
        startDate = [calendar dateByAddingComponents:offsetComponents toDate:startDate options:0];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        for (int i = 0; i < 100; i++) {
            [selectableYears addObject:[dateFormatter stringFromDate:startDate]];
            startDate = [startDate dateByAddingTimeInterval:-(60 * 60 * 24 * 365.25)];
        }
        
        NSArray *selectableGenders = [NSArray arrayWithObjects:@"female", @"male", nil];
        
        GTIOUser *currentUser = [GTIOUser currentUser];
        _profilePicture = [currentUser icon];
        
        _tableData = [NSArray arrayWithObjects:
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"email" andTitleText:@"email" andPlaceHolderText:@"user@domain.com" andAccessoryText:[currentUser email] andPickerItems:nil isRequired:YES usesPicker:NO isMultiline:NO characterLimit:50],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"name" andTitleText:@"name" andPlaceHolderText:@"Jane Doe" andAccessoryText:[currentUser name] andPickerItems:nil isRequired:YES usesPicker:NO isMultiline:NO characterLimit:25],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"city" andTitleText:@"city" andPlaceHolderText:@"New York" andAccessoryText:[currentUser city] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:NO characterLimit:20],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"state" andTitleText:@"state or country" andPlaceHolderText:@"NY" andAccessoryText:[currentUser state] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:NO characterLimit:20],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"gender" andTitleText:@"gender" andPlaceHolderText:@"select" andAccessoryText:[currentUser gender] andPickerItems:selectableGenders isRequired:YES usesPicker:YES isMultiline:NO characterLimit:25 ],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"born_in" andTitleText:@"year born" andPlaceHolderText:@"select year" andAccessoryText:[NSString stringWithFormat:@"%i",[[currentUser birthYear] intValue]] andPickerItems:selectableYears isRequired:NO usesPicker:YES isMultiline:NO characterLimit:25],
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"url" andTitleText:@"website" andPlaceHolderText:@"http://myblog.tumblr.com" andAccessoryText:[currentUser url] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:NO characterLimit:50],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"about" andTitleText:@"about me" andPlaceHolderText:@"...tell us about your personal style!" andAccessoryText:[currentUser aboutMe] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:YES characterLimit:250],
                      nil];
        
        // prepopulate save data with values from current user
        _saveData = [NSMutableDictionary dictionary];
        for (GTIOAlmostDoneTableDataItem *dataItem in _tableData) {
            [_saveData setValue:[dataItem accessoryText] forKey:[dataItem apiKey]];
        }
        
        _textFields = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"almost done!" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *saveButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeSaveGreenTopMargin tapHandler:^(id sender) {
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
            UIAlertView *missingRequiredData = [[UIAlertView alloc] initWithTitle:@"Incomplete Profile!" message:[NSString stringWithFormat:@"Please complete the '%@' section%@.",[missingDataElements componentsJoinedByString:@", "], ([missingDataElements count] > 1) ? @"s" : @""] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [missingRequiredData show];
        } else {
            [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
            NSDictionary *trackingInformation = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 @"edit_profile", @"id",
                                                 @"almost_done", @"screen",
                                                 nil];
            [[GTIOUser currentUser] updateCurrentUserWithFields:self.saveData withTrackingInformation:trackingInformation andLoginHandler:^(GTIOUser *user, NSError *error) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                if (!error) {
                    GTIOQuickAddViewController *quickAddViewController = [[GTIOQuickAddViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:quickAddViewController animated:YES];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"We were not able to save your profile." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }];
    [self setRightNavigationButton:saveButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height } style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor gtio_grayBorderColorE6E6E6]];
    self.originalContentFrame = self.tableView.frame;
    [self.view addSubview:self.tableView];
}

- (void)viewDidUnload
{
    [self viewDidUnload];
    self.tableView = nil;
    self.originalContentFrame = CGRectZero;
    self.profilePicture = nil;
    self.tableData = nil;
    self.textFields = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self refreshScreenData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // get rid of the pesky keyboard
    [self dismissKeyboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dismissKeyboard
{
    for (id object in self.textFields) {
        [object resignFirstResponder];
    }
    [self resetScrollAfterEditing];
}

#pragma mark - TableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 88.0f;
    }
    if (indexPath.row == 7) {
        return 115.0f;
    }
    return 43.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell-%i-%i",indexPath.section,indexPath.row];
    
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    GTIOAlmostDoneTableDataItem *dataItemForRow = (GTIOAlmostDoneTableDataItem *)[self.tableData objectAtIndex:indexPath.row];
    
    if (!cell) {
        if (indexPath.section == 0) {
            cell = (GTIOAlmostDoneTableHeaderCell *)[[GTIOAlmostDoneTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell setProfilePictureWithURL:self.profilePicture];
            [cell setTag:(indexPath.section+indexPath.row)];
        } else {
            cell = [[GTIOAlmostDoneTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell setCellTitle:[dataItemForRow titleText]];
            [cell setRequired:[dataItemForRow required]];
            [cell setAccessoryTextIsMultipleLines:[dataItemForRow multiline]];
            [cell setAccessoryTextUsesPicker:[dataItemForRow usesPicker]];
            [cell setAccessoryTextPlaceholderText:[dataItemForRow placeHolderText]];
            [cell setCharacterLimit:[dataItemForRow characterLimit]];
            [cell setApiKey:[dataItemForRow apiKey]];
            [cell setTag:(indexPath.section+indexPath.row)];
            [cell setIndexPath:indexPath];
            [cell setDelegate:self];
            
            if ([dataItemForRow usesPicker]) {
                [cell setPickerViewItems:[dataItemForRow pickerItems]];
            }
            
            if (![self.textFields containsObject:[cell cellAccessoryText]]) {
                [self.textFields addObject:[cell cellAccessoryText]];
            }
        }
    }
    
    if (indexPath.section == 0) {
        [cell setProfilePictureWithURL:self.profilePicture];
    } else {
        // prepopulate anything from the current user
        if ([[dataItemForRow accessoryText] length] > 0 && ![[dataItemForRow accessoryText] isEqualToString:@"0"]) {
            [cell setAccessoryText:[dataItemForRow accessoryText]];
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        GTIOEditProfilePictureViewController *editProfilePictureViewController = [[GTIOEditProfilePictureViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:editProfilePictureViewController animated:YES];
    }
}

#pragma mark - Helpers

- (void)moveResponderToNextCellFromCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:1];
    [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    GTIOAlmostDoneTableCell *cellToFocus = (GTIOAlmostDoneTableCell *)[self.tableView cellForRowAtIndexPath:nextIndexPath];
    [cellToFocus becomeFirstResponder];
}

- (void)scrollUpWhileEditing:(NSUInteger)cellIdentifier
{
    GTIOAlmostDoneTableCell *cell = (GTIOAlmostDoneTableCell *)[self.tableView viewWithTag:cellIdentifier];
    CGRect frame = cell.frame;
    frame.origin.y = frame.origin.y + 55;
    if (CGRectEqualToRect(self.tableView.frame, self.originalContentFrame)) {
        [self.tableView setFrame:(CGRect){ 0, 0, self.originalContentFrame.size.width, self.originalContentFrame.size.height - 260 }];
        [self.tableView scrollRectToVisible:frame animated:NO];
    } else {
        [self.tableView scrollRectToVisible:frame animated:YES];
    }
}

- (void)updateDataSourceWithValue:(id)value ForKey:(NSString*)key
{
    [self.saveData setValue:value forKey:key];
    for (GTIOAlmostDoneTableDataItem *rowDataItem in self.tableData) {
        if ([rowDataItem.apiKey isEqualToString:key]) {
            rowDataItem.accessoryText = value;
        }
    }
}

- (void)refreshScreenData
{
    self.profilePicture = [GTIOUser currentUser].icon;
    for (GTIOAlmostDoneTableDataItem *dataItem in self.tableData)
    {
        [dataItem setAccessoryText:[self.saveData valueForKey:[dataItem apiKey]]];
    }
    [self.tableView reloadData];
    [self adjustContentSizeToFit];
}

- (void)resetScrollAfterEditing
{
    [self.tableView setFrame:self.originalContentFrame];
    [self adjustContentSizeToFit];
    [self scrollToBottom];
}

- (void)adjustContentSizeToFit
{
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    CGRect lastRowRect= [self.tableView rectForRowAtIndexPath:[indexPaths objectAtIndex:[indexPaths count] - 1]];
    CGFloat contentHeight = lastRowRect.origin.y + lastRowRect.size.height;
    [self.tableView setContentSize:(CGSize){ self.tableView.contentSize.width, contentHeight + 55 }];
}

- (void)scrollToBottom
{
    [self.tableView scrollRectToVisible:(CGRect){ 0, self.tableView.contentSize.height - 1, self.tableView.bounds.size.width, 1 } animated:NO];
}

@end
