//
//  GTIOShoppingListViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/18/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOShoppingListViewController.h"
#import "GTIOWebViewController.h"
#import "GTIOProduct.h"
#import "GTIOProgressHUD.h"
#import "GTIOProductOption.h"
#import <RestKit/RestKit.h>
#import "GTIOProductListEmptyStateView.h"

static NSInteger const kGTIOEmailMeMyShoppingListAlert = 0;

@interface GTIOShoppingListViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) NSMutableArray *productOptions;

@property (nonatomic, strong) UIScrollView *productOptionsBackground;
@property (nonatomic, strong) GTIOProductListEmptyStateView *emptyStateView;

@end

@implementation GTIOShoppingListViewController

@synthesize tableView = _tableView, products = _products, productOptions = _productOptions, productOptionsBackground = _productOptionsBackground, emptyStateView = _emptyStateView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        _products = [NSMutableArray array];
        _productOptions = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"shopping list" italic:YES];
    [self useTitleView:navTitleView];
	
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = backButton;
    
    GTIOUIButton *emailMeMyListButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListEmailMyList tapHandler:^(id sender) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Would you like to email your shopping list to yourself?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
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
    
    UIImage *productOptionsBackgroundImage = [UIImage imageNamed:@"shopping.bottom.bg.png"];
    self.productOptionsBackground = [[UIScrollView alloc] initWithFrame:(CGRect){ 0, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - productOptionsBackgroundImage.size.height, productOptionsBackgroundImage.size }];
    self.productOptionsBackground.backgroundColor = [UIColor colorWithPatternImage:productOptionsBackgroundImage];
    self.productOptionsBackground.alpha = 0.0;
    [self.view addSubview:self.productOptionsBackground];
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, self.productOptionsBackground.bounds.size.height - 3, 0.0);
    
    self.emptyStateView = [[GTIOProductListEmptyStateView alloc] initWithFrame:(CGRect){ 0, 0, 210, 55 } title:@"browse, discover and add items to your shopping list to save them for later!" linkText:@"browse" linkTapHandler:^(id sender) {
        NSLog(@"browse!");
    }];
    self.emptyStateView.center = (CGPoint){ self.view.bounds.size.width / 2, (self.view.bounds.size.height / 2) - self.navigationController.navigationBar.bounds.size.height - 15 };
    self.emptyStateView.hidden = YES;
    [self.view addSubview:self.emptyStateView];
      
    [self loadShoppingList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
}

- (void)refreshScreenData
{
    [self loadShoppingList];
}

- (void)loadShoppingList
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/products/in-my-shopping-list" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadResponse = ^(RKResponse *response) {
            NSLog(@"%@", [response bodyAsString]);
        };
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.products removeAllObjects];
            [self.productOptions removeAllObjects];
            self.emptyStateView.hidden = YES;
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOProduct class]]) {
                    [self.products addObject:object];
                }
                if ([object isMemberOfClass:[GTIOProductOption class]]) {
                    [self.productOptions addObject:object];
                }
            }
            if (self.productOptions.count > 0) {
                [self layoutProductOptions];
            } else {
                [self.productOptionsBackground removeFromSuperview];
                self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            }
            if (self.products.count > 0) {
                [self.tableView reloadData];
            } else {
                self.emptyStateView.hidden = NO;
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

- (void)layoutProductOptions
{
    [UIView animateWithDuration:0.25 animations:^{
        self.productOptionsBackground.alpha = 1.0;
    }];
    
    for (UIView *subview in self.productOptionsBackground.subviews) {
        [subview removeFromSuperview];
    }
    CGFloat productOptionAddButtonXPos = 5.0;
    GTIOProductOptionAddButton *productOptionAddButton = [[GTIOProductOptionAddButton alloc] initWithFrame:(CGRect){ productOptionAddButtonXPos, 13, 55, 55 }];
    productOptionAddButton.productOption = nil;
    [self.productOptionsBackground addSubview:productOptionAddButton];
    for (GTIOProductOption *productOption in self.productOptions) {
        productOptionAddButtonXPos += 55 + 10;
        GTIOProductOptionAddButton *productOptionAddButton = [[GTIOProductOptionAddButton alloc] initWithFrame:(CGRect){ productOptionAddButtonXPos, 13, 55, 55 }];
        productOptionAddButton.productOption = productOption;
        productOptionAddButton.delegate = self;
        [self.productOptionsBackground addSubview:productOptionAddButton];
    }
    productOptionAddButtonXPos += 55 + 10;
    [self.productOptionsBackground setContentSize:(CGSize){ productOptionAddButtonXPos - 5, self.productOptionsBackground.bounds.size.height }];
}

#pragma mark - GTIOProductTableViewCellDelegate Methods

- (void)removeProduct:(GTIOProduct *)product
{
    NSUInteger indexOfProduct = [self.products indexOfObject:product];
    [self.products removeObjectAtIndex:indexOfProduct];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexOfProduct inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)loadWebViewControllerWithURL:(NSURL *)url
{
    GTIOWebViewController *webViewController = [[GTIOWebViewController alloc] initWithNibName:nil bundle:nil];
    webViewController.URL = url;
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 && self.productOptions.count > 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && self.productOptions.count > 0) {
        return self.productOptionsBackground.bounds.size.height;
    }
    return 0.0;
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
        cell = [[GTIOProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier GTIOProductTableCellType:GTIOProductTableViewCellTypeShoppingList];
    }
    
    return cell;
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kGTIOEmailMeMyShoppingListAlert && buttonIndex == 1) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/products/shopping-list/email-to-me" usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your shopping list has been emailed to you!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
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