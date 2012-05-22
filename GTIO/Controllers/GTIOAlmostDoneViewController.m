//
//  GTIOAlmostDoneViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAlmostDoneViewController.h"
#import "GTIOAlmostDoneTableHeaderCell.h"
#import <QuartzCore/QuartzCore.h>

@interface GTIOAlmostDoneTableDataItem : NSObject

@property (nonatomic, copy) NSString* titleText;
@property (nonatomic, copy) NSString* placeHolderText;
@property (nonatomic, unsafe_unretained) BOOL required;
@property (nonatomic, unsafe_unretained) BOOL editable;
@property (nonatomic, unsafe_unretained) BOOL multiline;

- (id)initWithTitleText:(NSString*)title andPlaceHolderText:(NSString*)placeholder isRequired:(BOOL)required isEditable:(BOOL)editable isMultiline:(BOOL)multiline;

@end

@implementation GTIOAlmostDoneTableDataItem

@synthesize titleText = _titleText, placeHolderText = _placeHolderText, required = _required, editable = _editable, multiline = _multiline;

- (id)initWithTitleText:(NSString*)title andPlaceHolderText:(NSString*)placeholder isRequired:(BOOL)required isEditable:(BOOL)editable isMultiline:(BOOL)multiline
{
    self = [super init];
    if (self) {
        _titleText = title;
        _placeHolderText = placeholder;
        _required = required;
        _editable = editable;
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
}

@end

@implementation GTIOAlmostDoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tableData = [NSArray arrayWithObjects:
                        [[GTIOAlmostDoneTableDataItem alloc] initWithTitleText:@"email" andPlaceHolderText:@"user@domain.com" isRequired:YES isEditable:YES isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithTitleText:@"name" andPlaceHolderText:@"Jane Doe" isRequired:YES isEditable:YES isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithTitleText:@"city" andPlaceHolderText:@"New York" isRequired:NO isEditable:YES isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithTitleText:@"state or country" andPlaceHolderText:@"NY" isRequired:NO isEditable:YES isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithTitleText:@"gender" andPlaceHolderText:@"select" isRequired:YES isEditable:NO isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithTitleText:@"year born" andPlaceHolderText:@"select year" isRequired:NO isEditable:NO isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithTitleText:@"website" andPlaceHolderText:@"http://myblog.tumblr.com" isRequired:NO isEditable:YES isMultiline:NO],
                        [[GTIOAlmostDoneTableDataItem alloc] initWithTitleText:@"about me" andPlaceHolderText:@"...tell us about your personal style!" isRequired:NO isEditable:YES isMultiline:YES],
                      nil];
    }
    return self;
}

- (void)viewDidLoad
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [backgroundImageView setBackgroundColor:[UIColor whiteColor]];
    [backgroundImageView setFrame:CGRectOffset(backgroundImageView.frame, 0, -64)];
    [self.view addSubview:backgroundImageView];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"green-pattern-nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    GTIOButton *saveButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeSave tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
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
    [_content setSeparatorColor:UIColorFromRGB(0xE6E6E6)];
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
    
    if (cell == nil) {
        if (indexPath.section == 0) {
            cell = (GTIOAlmostDoneTableHeaderCell*)[[GTIOAlmostDoneTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            // we'll need to grab the profile picture from the current user
            // do we have a placeholder image to put here when the user doesn't have a profile picture?
            [cell setProfilePicture:[UIImage imageNamed:@""]];
            [cell setTag:(indexPath.section+indexPath.row)];
        } else {
            cell = [[GTIOAlmostDoneTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setCellTitle:[[_tableData objectAtIndex:indexPath.row] titleText]];
            [cell setRequired:[[_tableData objectAtIndex:indexPath.row] required]];
            [cell setAccessoryTextEditable:[[_tableData objectAtIndex:indexPath.row] editable]];
            [cell setAccessoryTextPlaceholderText:[[_tableData objectAtIndex:indexPath.row] placeHolderText]];
            [cell setAccessoryTextIsMultipleLines:[[_tableData objectAtIndex:indexPath.row] multiline]];
            [cell setTag:(indexPath.section+indexPath.row)];
            [cell setDelegate:self];
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"tapped edit profile picture");
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        NSLog(@"tapped gender");
    }
    if (indexPath.section == 1 && indexPath.row == 5) {
        NSLog(@"tapped year");
    }
}

- (void)scrollUpWhileEditing:(NSUInteger)cellIdentifier {
    [_content setFrame:(CGRect){0,0,_originalContentFrame.size.width,_originalContentFrame.size.height-260}];
    UIView *cell = [_content viewWithTag:cellIdentifier];
    CGRect frame = cell.frame;
    frame.origin.y = frame.origin.y + 55;
    [_content scrollRectToVisible:frame animated:NO];
}

- (void)resetScrollAfterEditing {
    [_content setFrame:_originalContentFrame];
    [self adjustContentSizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    [self adjustContentSizeToFit];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
