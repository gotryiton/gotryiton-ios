//
//  GTIOMeViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOMeViewController.h"
#import "GTIOMeTitleView.h"
#import "GTIOMeTableHeaderView.h"
#import "GTIOUser.h"
#import "GTIOEditProfileViewController.h"
#import "GTIOEditProfilePictureViewController.h"

@interface GTIOMeViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;

@property (nonatomic, strong) GTIOMeTableHeaderView *profileHeaderView;

@end

@implementation GTIOMeViewController

@synthesize tableView = _tableView, tableData = _tableData, profileHeaderView = _profileHeaderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithTitle:@"GO TRY IT ON" italic:NO leftNavBarButton:nil rightNavBarButton:nil];
    if (self) {
        self.tableData = [[NSArray alloc] initWithObjects:@"my shopping list", @"my     s", @"my posts", @"find my friends", @"invite friends", @"search tags", @"settings", @"sign out", @"posts are private", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _profileHeaderView = [[GTIOMeTableHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 71.5 }];
    [_profileHeaderView setDelegate:self];
    [self.view addSubview:_profileHeaderView];
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 71.5, self.view.bounds.size } style:UITableViewStyleGrouped];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorColor:[UIColor gtio_groupedTableBorderColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 165.0, 0)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, _tableView.bounds.size.width, 200 }];
    UILabel *footerNotice = [[UILabel alloc] initWithFrame:(CGRect){ 50, -8, _tableView.bounds.size.width - 100, 40 }];
    [footerNotice setBackgroundColor:[UIColor clearColor]];
    [footerNotice setText:@"turn this option ON to require permission before someone can see what you post."];
    [footerNotice setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [footerNotice setTextColor:[UIColor gtio_darkGrayTextColor]];
    [footerNotice setTextAlignment:UITextAlignmentCenter];
    [footerNotice setNumberOfLines:0];
    [footerNotice setLineBreakMode:UILineBreakModeWordWrap];
    [footerView addSubview:footerNotice];
    [_tableView setTableFooterView:footerView];
    
    [self.view addSubview:_tableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    GTIOMeTitleView *titleView = [[GTIOMeTitleView alloc] initWithTapHandler:^(id sender) {
        NSLog(@"tapped notification bubble");
    } notificationCount:[NSNumber numberWithInt:0]];
    [self useTitleView:titleView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.profileHeaderView refreshData];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }
    return 1.0f;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    [cell.textLabel setText:[self.tableData objectAtIndex:(indexPath.section * 3) + indexPath.row]];
    [cell.textLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:16.0]];
    [cell.textLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
    
    if (!(indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2))) {
        UIImageView *chevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general.chevron.png"]];
        [cell setAccessoryView:chevron];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIImageView *heart = [[UIImageView alloc] initWithFrame:(CGRect){ 36, 16, 15, 12 }];
        [heart setImage:[UIImage imageNamed:@"profile.icon.heart.png"]];
        [cell.contentView addSubview:heart];
    }
    
    return cell;

}

#pragma mark - GTIOMeTableHeaderViewDelegate Methods

- (void)pushEditProfilePictureViewController
{
    GTIOEditProfilePictureViewController *editProfilePictureViewController = [[GTIOEditProfilePictureViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:editProfilePictureViewController animated:YES];
}

- (void)pushEditProfileViewController
{
    GTIOEditProfileViewController *editProfileViewController = [[GTIOEditProfileViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:editProfileViewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
