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
#import "GTIORouter.h"
#import "GTIOProgressHUD.h"
#import "GTIOSignInViewController.h"
#import "GTIOButton.h"
#import "GTIOSwitch.h"
#import "GTIOProgressHUD.h"

#import "GTIONotificationsViewController.h"

static NSString * const kGTIOCustomHeartsCell = @"custom_cell_hearts";
static NSString * const kGTIOCustomToggleCell = @"custom_cell_toggle";
static NSString * const kGTIOAlertForLogout = @"Are you sure you want to sign out?";
static NSString * const kGTIOAlertForTurningPrivateOn = @"Are you sure you want to make your posts private? From now on, only followers you approve will see your posts.";
static NSString * const kGTIOAlertForTurningPrivateOff = @"Are you sure you want to make your posts public? From now on, anyone will be able to follow your posts.";

@interface GTIOMeViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSArray *userInfoButtons;

@property (nonatomic, strong) NSMutableDictionary *sections;

@property (nonatomic, strong) GTIOMeTableHeaderView *profileHeaderView;

@property (nonatomic, strong) UIViewController *viewControllerToRouteTo;

@property (nonatomic, strong) NSIndexPath *indexOfPrivateToggle;

@end

@implementation GTIOMeViewController

@synthesize tableView = _tableView, tableData = _tableData, profileHeaderView = _profileHeaderView, userInfoButtons = _userInfoButtons, sections = _sections, viewControllerToRouteTo = _viewControllerToRouteTo;

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

    self.profileHeaderView = [[GTIOMeTableHeaderView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 72 }];
    [self.profileHeaderView setDelegate:self];
    [self.profileHeaderView setUser:[GTIOUser currentUser]];
    [self.profileHeaderView setEditButtonTapHandler:^(id sender) {
        GTIOEditProfileViewController *editProfileViewController = [[GTIOEditProfileViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:editProfileViewController animated:YES];
    }];
    [self.profileHeaderView setProfilePictureTapHandler:^(id sender) {
        GTIOEditProfilePictureViewController *editProfilePictureViewController = [[GTIOEditProfilePictureViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:editProfilePictureViewController animated:YES];
    }];
    [self.profileHeaderView setHasBackground:YES];
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
    [footerNotice setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
    [footerNotice setTextAlignment:UITextAlignmentCenter];
    [footerNotice setNumberOfLines:0];
    [footerNotice setLineBreakMode:UILineBreakModeWordWrap];
    [footerView addSubview:footerNotice];
    [self.tableView setTableFooterView:footerView];
    self.tableView.tableFooterView.hidden = YES;
    
    [self.view addSubview:self.tableView];
    
    [self refreshScreenLayout];
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
    
    GTIONavigationNotificationTitleView *titleView = [[GTIONavigationNotificationTitleView alloc] initWithTapHandler:^(void) {
        GTIONotificationsViewController *notificationsViewController = [[GTIONotificationsViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:notificationsViewController];
        [self presentModalViewController:navigationController animated:YES];
    }];
    [self useTitleView:titleView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView setUserInteractionEnabled:YES];
}

- (void)refreshScreenLayout
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [GTIOMyManagementScreen loadScreenLayoutDataWithCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
        if (!error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            int numberOfRows = 0;
            int numberOfSections = 0;
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOMyManagementScreen class]]) {                    
                    GTIOMyManagementScreen *screen = (GTIOMyManagementScreen *)object;
                    self.userInfoButtons = screen.userInfo;
                    [self.profileHeaderView setUser:[GTIOUser currentUser]];
                    [self.profileHeaderView setUserInfoButtons:self.userInfoButtons];
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
                    self.tableView.tableFooterView.hidden = NO;
                    [self.tableView reloadData];
                }
            }
        }
    }];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GTIOButton *buttonForRow = (GTIOButton *)[self.tableData objectAtIndex:(indexPath.section * self.sections.count) + indexPath.row];
    self.viewControllerToRouteTo = [[GTIORouter sharedRouter] viewControllerForURLString:buttonForRow.action.destination];
    
    if (self.viewControllerToRouteTo) {
        [self.tableView setUserInteractionEnabled:NO];
        // handle any special cases
        if ([buttonForRow.action.destination isEqualToString:@"gtio://sign-out"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kGTIOAlertForLogout delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil];
            [alert show];
        } else {
            [self.navigationController pushViewController:self.viewControllerToRouteTo animated:YES];
        }
    }
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
    static NSString *CellIdentifier = @"GTIOMeTableViewCell"; 
    
    GTIOMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[GTIOMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.tableData.count > 0) {
        GTIOButton *buttonForRow = (GTIOButton *)[self.tableData objectAtIndex:(indexPath.section * self.sections.count) + indexPath.row];
        
        if ([buttonForRow.name isEqualToString:kGTIOCustomHeartsCell]) {
            buttonForRow.text = @"my     \u2019s";
            [cell setHasHeart:YES];
        } else if ([buttonForRow.name isEqualToString:kGTIOCustomToggleCell]) {
            self.indexOfPrivateToggle = indexPath;
            [cell setHasToggle:YES];
            [cell setToggleState:![buttonForRow.value boolValue]];
            [cell setIndexPath:indexPath];
            [cell setToggleDelegate:self];
        }
        [cell setHasChevron:[buttonForRow.chevron boolValue]];
        [cell.textLabel setText:buttonForRow.text];
    }
    
    return cell;

}

- (void)updateSwitchAtIndexPath:(NSIndexPath *)indexPath
{

    GTIOMeTableViewCell *cell = (GTIOMeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    GTIOSwitch *switchView = (GTIOSwitch *)cell.accessoryView;
       
    if (switchView.isOn){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:kGTIOAlertForTurningPrivateOn delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:kGTIOAlertForTurningPrivateOff delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", nil];
        [alert show];
    }    
}

#pragma mark - GTIOMeTableHeaderViewDelegate Methods

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:kGTIOAlertForLogout]){
            if (buttonIndex == 0) {
                [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
                [[GTIOUser currentUser] logOutWithLogoutHandler:^(RKResponse *response) {
                    [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                    if (response) {
                        GTIOSignInViewController *signInViewController = (GTIOSignInViewController *)self.viewControllerToRouteTo;
                        [signInViewController setLoginHandler:^(GTIOUser *user, NSError *error) {
                            // need to wait for the janrain screen to fade away before dismissing
                            double delayInSeconds = 0.25;
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                [self.navigationController dismissModalViewControllerAnimated:YES];
                                [self.tableView setUserInteractionEnabled:YES];
                                [self refreshScreenLayout];
                                [self.profileHeaderView refreshUserData];
                            });
                        }];
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signInViewController];
                        [self.navigationController presentModalViewController:navigationController animated:YES];
                    }
                }];
            } else {
                [self.tableView setUserInteractionEnabled:YES];
            }
    } else if ([alertView.message isEqualToString:kGTIOAlertForTurningPrivateOn]) {
       
        // YES!
        if (buttonIndex == 0){
            [[GTIOUser currentUser] updateCurrentUserWithFields:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [NSNumber numberWithBool:NO], @"public", nil]
                                        withTrackingInformation:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 @"mymanagement", @"screen", nil]
                                                andLoginHandler:nil];
            
        } else {
            GTIOMeTableViewCell *cell = (GTIOMeTableViewCell *)[self.tableView cellForRowAtIndexPath:self.indexOfPrivateToggle];
            [cell setToggleState:NO];
        }
    } else if ([alertView.message isEqualToString:kGTIOAlertForTurningPrivateOff]) {
        // YES!
        if (buttonIndex == 1){
            [[GTIOUser currentUser] updateCurrentUserWithFields:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [NSNumber numberWithBool:YES], @"public", nil]
                                        withTrackingInformation:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 @"mymanagement", @"screen", nil]
                                                andLoginHandler:nil];
            
        } else {
            GTIOMeTableViewCell *cell = (GTIOMeTableViewCell *)[self.tableView cellForRowAtIndexPath:self.indexOfPrivateToggle];
            [cell setToggleState:YES];
        }

        
    }
       

    
}

@end
