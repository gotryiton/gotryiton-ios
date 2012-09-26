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

#import "GTIOProfileViewController.h"
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
@property (nonatomic, strong) GTIONavigationNotificationTitleView *titleView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) BOOL shouldRefreshAfterInactive;

@property (nonatomic, strong) GTIONotificationsViewController *notificationsViewController;

@end

@implementation GTIOMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnedFromInactive) name:kGTIOAppReturningFromInactiveStateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOFeedControllerShouldRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOAllControllersShouldRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUserProfile:) name:kGTIOShowProfileUserNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleView = [[GTIONavigationNotificationTitleView alloc] initWithTapHandler:^(void) {
        [self toggleNotificationView:YES];
    }];

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
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ { 0, self.profileHeaderView.bounds.size.height }, self.view.bounds.size.width, self.view.bounds.size.height - self.profileHeaderView.bounds.size.height - self.tabBarController.tabBar.frame.size.height } style:UITableViewStyleGrouped];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor gtio_groupedTableBorderColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.frame.size.height, 0 }];
    [self.tableView setContentInset:(UIEdgeInsets){ 0, 0, self.tabBarController.tabBar.bounds.size.height, 0 }];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.footerView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, self.tableView.bounds.size.width, 30 }];
    UILabel *footerNotice = [[UILabel alloc] initWithFrame:(CGRect){ 50, -8, self.tableView.bounds.size.width - 100, 40 }];
    [footerNotice setBackgroundColor:[UIColor clearColor]];
    [footerNotice setText:@"turn this option ON to require permission before someone can see what you post."];
    [footerNotice setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [footerNotice setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
    [footerNotice setTextAlignment:UITextAlignmentCenter];
    [footerNotice setNumberOfLines:0];
    [footerNotice setLineBreakMode:UILineBreakModeWordWrap];
    [self.footerView addSubview:footerNotice];
    
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
    
    [self useTitleView:self.titleView];
    [self.titleView forceUpdateCountLabel];
    [self.tableView setUserInteractionEnabled:YES];
    
    if (self.sections == nil){
        self.sections = [NSMutableDictionary dictionary];
    }
    if (self.tableData==nil){
        self.tableData = [NSMutableArray array];
        [self refreshScreenLayout];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fix for the tab bar going opaque when you go to a view that hides it and back to a view that has the tab bar
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOTabBarViewsResize object:nil];

    [self.profileHeaderView setUser:[GTIOUser currentUser]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self closeNotificationView:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - GTIONotificationViewDisplayProtocol methods

- (void)toggleNotificationView:(BOOL)animated
{
    if(self.notificationsViewController == nil) {
        self.notificationsViewController = [[GTIONotificationsViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    // if a child, remove it
    if([self.childViewControllers containsObject:self.notificationsViewController]) {
        [self closeNotificationView:YES];
    } else {
        [self openNotificationView:YES];
    }
}

- (void)closeNotificationView:(BOOL)animated
{
    if(self.notificationsViewController.parentViewController) {
        [self.notificationsViewController willMoveToParentViewController:nil];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.notificationsViewController.view setAlpha:0.0];
                         }
                         completion:^(BOOL finished) {
                             [self.notificationsViewController.view removeFromSuperview];
                             [self.notificationsViewController removeFromParentViewController];
                             [self.notificationsViewController didMoveToParentViewController:nil];
                         }];
    }
}

- (void)openNotificationView:(BOOL)animated
{
    if(self.notificationsViewController.parentViewController == nil) {
        [self.notificationsViewController willMoveToParentViewController:self];
        [self addChildViewController:self.notificationsViewController];
        [self.notificationsViewController.view setAlpha:0.0];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.view addSubview:self.notificationsViewController.view];
                             [self.notificationsViewController.view setAlpha:1.0];
                         }
                         completion:^(BOOL finished) {
                             [self.notificationsViewController didMoveToParentViewController:self];
                         }];
    }
}

#pragma mark - Refresh After Inactive

- (void)appReturnedFromInactive
{
    self.shouldRefreshAfterInactive = YES;
}

- (void)refreshAfterInactive
{
    if(self.shouldRefreshAfterInactive) {
        self.shouldRefreshAfterInactive = NO;
        [self refreshScreenLayout];
        // load all the rest here
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOAllControllersShouldRefresh object:nil];
    }
}

#pragma mark -

- (void)refreshScreenLayout
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [GTIOMyManagementScreen loadScreenLayoutDataWithCompletionHandler:^(NSArray *loadedObjects, NSError *error) {
        if (!error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            int numberOfRows = 0;
            int numberOfSections = 0;
            [self.tableData removeAllObjects];
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
                    [self.tableView setTableFooterView:self.footerView];
                    [self.tableView reloadData];
                    [self.tableView layoutSubviews];
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
            [[[UIAlertView alloc] initWithTitle:nil message:kGTIOAlertForLogout delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
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
        [[[UIAlertView alloc] initWithTitle:@"" message:kGTIOAlertForTurningPrivateOn delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"" message:kGTIOAlertForTurningPrivateOff delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil] show];
    }    
}

#pragma mark - GTIOMeTableHeaderViewDelegate Methods

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
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
            GTIOButton *privateButton = (GTIOButton *)[self.tableData objectAtIndex:(self.indexOfPrivateToggle.section * self.sections.count) + self.indexOfPrivateToggle.row];
            privateButton.value = [NSNumber numberWithInt:0];
            
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
            GTIOButton *privateButton = (GTIOButton *)[self.tableData objectAtIndex:(self.indexOfPrivateToggle.section * self.sections.count) + self.indexOfPrivateToggle.row];
            privateButton.value = [NSNumber numberWithInt:1];
        } else {
            GTIOMeTableViewCell *cell = (GTIOMeTableViewCell *)[self.tableView cellForRowAtIndexPath:self.indexOfPrivateToggle];
            [cell setToggleState:YES];
        }
    }
}

#pragma mark - Notifications

- (void)showUserProfile:(NSNotification *)notificaion
{
    NSString *userID = [[notificaion userInfo] objectForKey:kGTIOProfileUserIDUserInfo];
    if ([userID length] > 0) {
        GTIOProfileViewController *profileViewController = [[GTIOProfileViewController alloc] initWithNibName:nil bundle:nil];
        [profileViewController setUserID:userID];
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
}

@end
