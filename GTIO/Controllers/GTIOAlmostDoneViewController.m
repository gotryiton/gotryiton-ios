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

@interface GTIOAlmostDoneTableDataItem : NSObject

@property (nonatomic, copy) NSString* apiKey;
@property (nonatomic, copy) NSString* titleText;
@property (nonatomic, copy) NSString* placeHolderText;
@property (nonatomic, copy) NSString* accessoryText;
@property (nonatomic, retain) NSArray* pickerItems;
@property (nonatomic, unsafe_unretained) BOOL required;
@property (nonatomic, unsafe_unretained) BOOL usesPicker;
@property (nonatomic, unsafe_unretained) BOOL multiline;

- (id)initWithApiKey:(NSString*)apiKey andTitleText:(NSString*)title andPlaceHolderText:(NSString*)placeholder andAccessoryText:(NSString*)accessoryText andPickerItems:(NSArray*)pickerItems isRequired:(BOOL)required usesPicker:(BOOL)usesPicker isMultiline:(BOOL)multiline;

@end

@implementation GTIOAlmostDoneTableDataItem

@synthesize apiKey = _apiKey, titleText = _titleText, placeHolderText = _placeHolderText, accessoryText = _accessoryText, pickerItems = _pickerItems, required = _required, usesPicker = _usesPicker, multiline = _multiline;

- (id)initWithApiKey:(NSString*)apiKey andTitleText:(NSString*)title andPlaceHolderText:(NSString*)placeholder andAccessoryText:(NSString*)accessoryText andPickerItems:(NSArray*)pickerItems isRequired:(BOOL)required usesPicker:(BOOL)usesPicker isMultiline:(BOOL)multiline
{
    self = [super init];
    if (self) {
        _apiKey = apiKey;
        _titleText = title;
        _placeHolderText = placeholder;
        _accessoryText = accessoryText;
        _pickerItems = pickerItems;
        _required = required;
        _usesPicker = usesPicker;
        _multiline = multiline;
    }
    return self;
}

@end


@interface GTIOAlmostDoneViewController () {
@private
    NSArray* _tableData;
    UITableView* _content;
    CGRect _originalContentFrame;
    NSURL* _profilePicture;
    NSMutableDictionary* _saveData;
    NSMutableArray* _textFields;
}

@end

@implementation GTIOAlmostDoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {    
        NSMutableArray* selectableYears = [NSMutableArray array];
        NSDate* currentDate = [NSDate date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        for (int i = 0; i < 100; i++) {
            [selectableYears addObject:[dateFormatter stringFromDate:currentDate]];
            currentDate = [currentDate dateByAddingTimeInterval:-(60*60*24*365.25)];
        }
        
        NSArray* selectableGenders = [NSArray arrayWithObjects:@"female", @"male", nil];
        
        GTIOUser* currentUser = [GTIOUser currentUser];
        _profilePicture = [currentUser icon];
        
        _tableData = [NSArray arrayWithObjects:
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"email" andTitleText:@"email" andPlaceHolderText:@"user@domain.com" andAccessoryText:@"" andPickerItems:nil isRequired:YES usesPicker:NO isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"name" andTitleText:@"name" andPlaceHolderText:@"Jane Doe" andAccessoryText:[currentUser name] andPickerItems:nil isRequired:YES usesPicker:NO isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"city" andTitleText:@"city" andPlaceHolderText:@"New York" andAccessoryText:[currentUser city] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"state" andTitleText:@"state or country" andPlaceHolderText:@"NY" andAccessoryText:[currentUser state] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"gender" andTitleText:@"gender" andPlaceHolderText:@"select" andAccessoryText:[currentUser gender] andPickerItems:selectableGenders isRequired:YES usesPicker:YES isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"born_in" andTitleText:@"year born" andPlaceHolderText:@"select year" andAccessoryText:[NSString stringWithFormat:@"%i",[[currentUser birthYear] intValue]] andPickerItems:selectableYears isRequired:NO usesPicker:YES isMultiline:NO],
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"website" andTitleText:@"website" andPlaceHolderText:@"http://myblog.tumblr.com" andAccessoryText:@"" andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"about_me" andTitleText:@"about me" andPlaceHolderText:@"...tell us about your personal style!" andAccessoryText:[currentUser aboutMe] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:YES],
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
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"green-pattern-nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    GTIOButton *saveButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeSaveGreenTopMargin tapHandler:^(id sender) {
        NSMutableArray *missingDataElements = [NSMutableArray array];
        for (GTIOAlmostDoneTableDataItem *dataItem in _tableData) {
            if ([dataItem required]) {
                if ([[_saveData valueForKey:[dataItem apiKey]] length] == 0) {
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
            [[GTIOUser currentUser] updateCurrentUserWithFields:_saveData withTrackingInformation:trackingInformation andLoginHandler:^(GTIOUser *user, NSError *error) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                if (!error) {
                    [((GTIOAppDelegate *)[UIApplication sharedApplication].delegate) addTabBarToWindow];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"We were not able to save your profile." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }];
    
    [self.navigationItem setHidesBackButton:YES];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleView setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:18.0]];
    [titleView setText:@"almost done!"];
    [titleView sizeToFit];
    [titleView setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:titleView];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:saveButton]];
    
    _content = [[UITableView alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width,self.view.bounds.size.height} style:UITableViewStyleGrouped];
    [_content setDelegate:self];
    [_content setDataSource:self];
    [_content setBackgroundColor:[UIColor clearColor]];
    [_content setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_content setSeparatorColor:[UIColor gtio_lightGrayBorderColor]];
    _originalContentFrame = _content.frame;
    [self.view addSubview:_content];
    
    UIView *topShadow = [[UIView alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width,3}];
    [topShadow setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top-shadow.png"]]];
    [self.view addSubview:topShadow];
}

#pragma mark - TableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell-%i-%i",indexPath.section,indexPath.row];
    
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    GTIOAlmostDoneTableDataItem* dataItemForRow = (GTIOAlmostDoneTableDataItem*)[_tableData objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        if (indexPath.section == 0) {
            cell = (GTIOAlmostDoneTableHeaderCell*)[[GTIOAlmostDoneTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setProfilePicture:_profilePicture];
            [cell setTag:(indexPath.section+indexPath.row)];
        } else {
            cell = [[GTIOAlmostDoneTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setCellTitle:[dataItemForRow titleText]];
            [cell setRequired:[dataItemForRow required]];
            [cell setAccessoryTextIsMultipleLines:[dataItemForRow multiline]];
            [cell setAccessoryTextUsesPicker:[dataItemForRow usesPicker]];
            [cell setAccessoryTextPlaceholderText:[dataItemForRow placeHolderText]];
            [cell setApiKey:[dataItemForRow apiKey]];
            [cell setTag:(indexPath.section+indexPath.row)];
            [cell setDelegate:self];
            
            if ([dataItemForRow usesPicker]) {
                [cell setPickerViewItems:[dataItemForRow pickerItems]];
            }
            
            if (![_textFields containsObject:[cell cellAccessoryText]]) {
                [_textFields addObject:[cell cellAccessoryText]];
            }
        }
    }
    
    if (indexPath.section == 0) {
        [cell setProfilePicture:_profilePicture];
    } else {
        // prepopulate anything from the current user
        if ([[dataItemForRow accessoryText] length] > 0 && ![[dataItemForRow accessoryText] isEqualToString:@"0"]) {
            [cell setAccessoryText:[dataItemForRow accessoryText]];
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        GTIOEditProfilePictureViewController *editProfilePictureViewController = [[GTIOEditProfilePictureViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:editProfilePictureViewController animated:YES];
    }
}

- (void)moveResponderToNextCellFromCell:(NSUInteger)cellIdentifier {
    cellIdentifier++;
    GTIOAlmostDoneTableCell* cellToActivate = (GTIOAlmostDoneTableCell*)[_content viewWithTag:cellIdentifier];
    if (cellToActivate) {
        [cellToActivate becomeFirstResponder];
    }
}

- (void)scrollUpWhileEditing:(NSUInteger)cellIdentifier {
    GTIOAlmostDoneTableCell *cell = (GTIOAlmostDoneTableCell*)[_content viewWithTag:cellIdentifier];
    CGRect frame = cell.frame;
    frame.origin.y = frame.origin.y + 55;
    if (CGRectEqualToRect(_content.frame,_originalContentFrame)) {
        [_content setFrame:(CGRect){0,0,_originalContentFrame.size.width,_originalContentFrame.size.height-260}];
        [_content scrollRectToVisible:frame animated:NO];
    } else {
        [_content scrollRectToVisible:frame animated:YES];
    }
}

- (void)updateDataSourceWithValue:(id)value ForKey:(NSString*)key
{
    [_saveData setValue:value forKey:key];
}

- (void)refreshScreenData {
    _profilePicture = [GTIOUser currentUser].icon;
    for (GTIOAlmostDoneTableDataItem* dataItem in _tableData) {
        [dataItem setAccessoryText:[_saveData valueForKey:[dataItem apiKey]]];
    }
    [_content reloadData];
    [self adjustContentSizeToFit];
}

- (void)resetScrollAfterEditing {
    [_content setFrame:_originalContentFrame];
    [self adjustContentSizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    [self refreshScreenData];
}

- (void)adjustContentSizeToFit {
    NSArray* indexPaths = [_content indexPathsForVisibleRows];
    CGRect lastRowRect= [_content rectForRowAtIndexPath:[indexPaths objectAtIndex:[indexPaths count]-1]];
    CGFloat contentHeight = lastRowRect.origin.y + lastRowRect.size.height;
    [_content setContentSize:(CGSize){_content.contentSize.width,contentHeight+55}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // get rid of the pesky keyboard
    for (UITextField *textField in _textFields) {
        [textField resignFirstResponder];
    }
    [self resetScrollAfterEditing];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
