//
//  GTIOShopThisLookViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOShopThisLookViewController.h"
#import "GTIOProduct.h"
#import <RestKit/RestKit.h>
#import "GTIOProductViewController.h"

static NSInteger const kGTIOEmailMeMyShoppingListAlert = 0;

@interface GTIOShopThisLookViewController ()

@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GTIOShopThisLookViewController

@synthesize products = _products, postID = _postID, tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _products = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"shop this look" italic:YES];
    [self useTitleView:navTitleView];
	
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = backButton;
    
    GTIOUIButton *emailMeMyListButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListEmailMyList tapHandler:^(id sender) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Would you like to email this list to yourself?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = kGTIOEmailMeMyShoppingListAlert;
        [alert show];
    }];
    self.rightNavigationButton = emailMeMyListButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height } style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self loadProducts];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
}

- (void)loadProducts
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/products/in-post/%i", self.postID.intValue] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.products removeAllObjects];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOProduct class]]) {
                    [self.products addObject:object];
                }
            }
            if (self.products.count > 0) {
                [self.tableView reloadData];
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (NSUInteger)indexOfProductWithId:(NSNumber *)productID
{
    return [self.products indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
       GTIOProduct *product = (GTIOProduct*)obj;
        return ([product.productID integerValue] == [productID integerValue]);
    }];
}

#pragma mark - GTIOProductTableViewCellDelegate Methods
- (void)productButtonTap:(GTIOButton *)button productID:(NSNumber *)productID;
{   
    __block typeof(self) blockSelf = self;
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOProduct class]]) {

                    // product button endpoints respond with a fresh object so just update it                   
                    GTIOProduct *newObject = (GTIOProduct *)object;
                    
                    [self.products replaceObjectAtIndex:[blockSelf indexOfProductWithId:newObject.productID] withObject: newObject];

                    NSArray *indexes = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:[blockSelf indexOfProductWithId:newObject.productID] inSection:0], nil];
                    [blockSelf.tableView reloadRowsAtIndexPaths:indexes withRowAnimation:NO];
                    
                }
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            

            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GTIOProduct *productAtIndexPath = (GTIOProduct *)[self.products objectAtIndex:indexPath.row];
    GTIOProductViewController *productViewController = [[GTIOProductViewController alloc] initWithProductID:productAtIndexPath.productID];
    [self.navigationController pushViewController:productViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isMemberOfClass:[GTIOProductTableViewCell class]]) {
        GTIOProductTableViewCell *productCell = (GTIOProductTableViewCell *)cell;
        GTIOProduct *product = (GTIOProduct *)[self.products objectAtIndex:indexPath.row];
        productCell.product = product;
        productCell.delegate = self;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 4.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    return nil;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ProductCellIdentifier";
    
    GTIOProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[GTIOProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier GTIOProductTableCellType:GTIOProductTableViewCellTypeShopThisLook];
    }
    
    return cell;
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kGTIOEmailMeMyShoppingListAlert && buttonIndex == 1) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/products/in-post/%@/email-to-me", self.postID] usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You should receive this list by email shortly." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            };
            loader.onDidFailWithError = ^(NSError *error) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"There was an error while emailing you your shopping list. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                NSLog(@"%@", [error localizedDescription]);
            };
        }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
