//
//  GTIOMeViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOMeViewController.h"
#import "GTIONavigationNotificationTitleView.h"
#import "GTIOMeTableHeaderView.h"
#import "GTIOUser.h"
#import "GTIOEditProfileViewController.h"
#import "GTIOEditProfilePictureViewController.h"
#import "GTIOSignInViewController.h"
#import "GTIONavigationTitleView.h"
#import "GTIOMyManagementScreen.h"

@interface GTIOMeViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSArray *userInfoButtons;

@property (nonatomic, strong) NSMutableDictionary *sections;

@property (nonatomic, strong) GTIOMeTableHeaderView *profileHeaderView;

@end

@implementation GTIOMeViewController

@synthesize tableView = _tableView, tableData = _tableData, profileHeaderView = _profileHeaderView, userInfoButtons = _userInfoButtons, sections = _sections;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _tableData = [NSMutableArray array];
        _sections = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GTIOMyManagementScreen loadScreenLayoutDataWithCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
        if (!error) {
            int numberOfRows = 0;
            int numberOfSections = 0;
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOMyManagementScreen class]]) {                    
                    GTIOMyManagementScreen *screen = (GTIOMyManagementScreen *)object;
                    self.userInfoButtons = screen.userInfo;
                    for (GTIOButton *button in screen.management) {
                        if (![button.name isEqualToString:@"spacer_cell"]) {
                            [self.tableData addObject:button];
                            numberOfRows++;
                        } else {
                            numberOfSections++;
                            [self.sections setValue:[NSNumber numberWithInt:numberOfRows] forKey:[NSString stringWithFormat:@"section-%i", numberOfSections]];
                            numberOfRows = 0;
                        }
                    }
                    if (numberOfRows > 0) {
                        numberOfSections++;
                        [self.sections setValue:[NSNumber numberWithInt:numberOfRows] forKey:[NSString stringWithFormat:@"section-%i", numberOfSections]];
                    }
                    [self.tableView reloadData];
                }
            }
        }
    }];
    
    self.profileHeaderView = [[GTIOMeTableHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 72 }];
    [self.profileHeaderView setDelegate:self];
    [self.view addSubview:self.profileHeaderView];
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, self.profileHeaderView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.profileHeaderView.bounds.size.height } style:UITableViewStyleGrouped];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor gtio_groupedTableBorderColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 93.0, 0)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, _tableView.bounds.size.width, 128 }];
    UILabel *footerNotice = [[UILabel alloc] initWithFrame:(CGRect){ 50, -8, _tableView.bounds.size.width - 100, 40 }];
    [footerNotice setBackgroundColor:[UIColor clearColor]];
    [footerNotice setText:@"turn this option ON to require permission before someone can see what you post."];
    [footerNotice setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [footerNotice setTextColor:[UIColor gtio_darkGrayTextColor]];
    [footerNotice setTextAlignment:UITextAlignmentCenter];
    [footerNotice setNumberOfLines:0];
    [footerNotice setLineBreakMode:UILineBreakModeWordWrap];
    [footerView addSubview:footerNotice];
    [self.tableView setTableFooterView:footerView];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.profileHeaderView = nil;
    self.tableView = nil;
    self.tableData = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    GTIONavigationNotificationTitleView *titleView = [[GTIONavigationNotificationTitleView alloc] initWithNotifcationCount:[NSNumber numberWithInt:1] tapHandler:^{
        NSLog(@"tapped notification bubble");
    }];
    [self useTitleView:titleView];
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
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSNumber *)[self.sections objectForKey:[NSString stringWithFormat:@"section-%i", section + 1]] intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.tableData.count > 0) {
        GTIOButton *buttonForRow = (GTIOButton *)[self.tableData objectAtIndex:(indexPath.section * self.sections.count) + indexPath.row];
        
        if ([buttonForRow.name isEqualToString:@"custom_cell_hearts"]) {
            buttonForRow.text = @"my     s";
            UIImageView *heart = [[UIImageView alloc] initWithFrame:(CGRect){ 36, 16, 15, 12 }];
            [heart setImage:[UIImage imageNamed:@"profile.icon.heart.png"]];
            [cell.contentView addSubview:heart];
        }
        
        [cell.textLabel setText:buttonForRow.text];
        [cell.textLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:16.0]];
        [cell.textLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
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
