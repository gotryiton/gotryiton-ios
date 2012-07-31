//
//  GTIOWhoHeartedThisViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOWhoHeartedThisViewController.h"
#import "GTIOUser.h"
#import "GTIOProgressHUD.h"
#import "GTIOProfileViewController.h"

@interface GTIOWhoHeartedThisViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) GTIOWhoHeartedThisViewControllerType controllerType;
@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation GTIOWhoHeartedThisViewController

@synthesize tableView = _tableView, controllerType = _controllerType, users = _users, itemID = _itemID;

- (id)initWithGTIOWhoHeartedThisViewControllerType:(GTIOWhoHeartedThisViewControllerType)controllerType
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _controllerType = controllerType;
        _users = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"who     \u2019d this" italic:YES];
    UIImageView *heartImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.hearts.navbar.icon.png"]];
    [heartImageView setFrame:(CGRect){ 29, 11, heartImageView.bounds.size }];
    [navTitleView addSubview:heartImageView];
    [self useTitleView:navTitleView];
	
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = backButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-shadow.png"]];
    [tableFooterView setFrame:(CGRect){ 0, 0, self.tableView.bounds.size.width, 5 }];
    self.tableView.tableFooterView = tableFooterView;
    [self.view addSubview:self.tableView];
    
    [self loadUsers];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
}

- (void)loadUsers
{
    NSString *resourcePath;
    if (self.controllerType == GTIOWhoHeartedThisViewControllerTypePost) {
        resourcePath = [NSString stringWithFormat:@"/users/who-hearted-post/%i", self.itemID.intValue];
    } else if (self.controllerType == GTIOWhoHeartedThisViewControllerTypeProduct) {
        resourcePath = [NSString stringWithFormat:@"/users/who-hearted-product/%i", self.itemID.intValue];
    }
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.users removeAllObjects];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOUser class]]) {
                    [self.users addObject:object];
                }
            }
            if (self.users.count > 0) {
                [self.tableView reloadData];
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

#pragma mark - GTIOFindMyFriendsTableViewCellDelegate Methods

- (void)updateDataSourceUser:(GTIOUser *)user withUser:(GTIOUser *)newUser
{
    NSUInteger indexForUser = [self.users indexOfObject:user];
    [self.users replaceObjectAtIndex:indexForUser withObject:newUser];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTIOUser *userForRow = [self.users objectAtIndex:indexPath.row];
    GTIOFindMyFriendsTableViewCell *customCell = (GTIOFindMyFriendsTableViewCell *)cell;
    customCell.user = userForRow;
    customCell.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GTIOUser *userForIndexPath = (GTIOUser *)[self.users objectAtIndex:indexPath.row];
    GTIOProfileViewController *profileViewController = [[GTIOProfileViewController alloc] initWithNibName:nil bundle:nil];
    profileViewController.userID = userForIndexPath.userID;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"WhoHeartedThisCell";
    
    GTIOFindMyFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[GTIOFindMyFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
