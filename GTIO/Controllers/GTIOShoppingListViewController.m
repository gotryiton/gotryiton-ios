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
#import "GTIOButton.h"
#import "GTIOProgressHUD.h"
#import "GTIOProductOption.h"
#import <RestKit/RestKit.h>
#import "GTIOProductListEmptyStateView.h"
#import "GTIOProductViewController.h"
#import "GTIOAppDelegate.h"

static NSInteger const kGTIOEmailMeMyShoppingListAlert = 0;
static CGFloat const kGTIOOffsetForShadowOnProductOptionsBackground = 3.0;
static CGFloat const kGTIOEmptyStateViewVerticalCenterOffset = -8.0;

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
        GTIOAlertView *alert = [[GTIOAlertView alloc] initWithTitle:nil message:@"Would you like to email your shopping list to yourself?" delegate:self cancelButtonTitle:@"no" otherButtonTitles:@"yes", nil];
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
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, self.productOptionsBackground.bounds.size.height - kGTIOOffsetForShadowOnProductOptionsBackground, 0.0);
    
    self.emptyStateView = [[GTIOProductListEmptyStateView alloc] initWithFrame:(CGRect){ 0, 0, 210, 55 } title:@"heart products to save them \nto your shopping list!" linkText:@"" linkTapHandler:nil];
    self.emptyStateView.center = (CGPoint){ self.view.bounds.size.width / 2, (self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - self.emptyStateView.frame.size.height) / 2 + kGTIOEmptyStateViewVerticalCenterOffset };
    self.emptyStateView.hidden = YES;
    [self.view addSubview:self.emptyStateView];
      
    [self loadShoppingList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
    self.productOptionsBackground = nil;
    self.emptyStateView = nil;
}

- (void)refreshScreenData
{
    [self loadShoppingList];
}

- (void)loadShoppingList
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/products/in-my-shopping-list" usingBlock:^(RKObjectLoader *loader) {
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
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                [self loadShoppingList];
            }];
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

- (NSUInteger)indexOfProductWithId:(NSNumber *)productID
{
    return [self.products indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
       GTIOProduct *product = (GTIOProduct*)obj;
       return ([product.productID integerValue] == [productID integerValue]);
    }];
}

#pragma mark - GTIOProductTableViewCellDelegate Methods
- (void)productButtonTap:(GTIOButton*)button productID:(NSNumber *)productID;
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
                    
                } else if ([object isMemberOfClass:[GTIOAlert class]]) {
                    [GTIOErrorController handleAlert:(GTIOAlert *)object showRetryInView:self.view retryHandler:nil];
                }
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:nil];
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
    GTIOProductViewController *viewController = [[GTIOProductViewController alloc] initWithProductID:productAtIndexPath.productID];
    [self.navigationController pushViewController:viewController animated:YES];
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

#pragma mark - GTIOAlertViewDelegate Methods

- (void)alertView:(GTIOAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kGTIOEmailMeMyShoppingListAlert && buttonIndex == 1) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/products/shopping-list/email-to-me" usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                
                for (id object in loadedObjects) {
                    if ([object isMemberOfClass:[GTIOAlert class]]) {
                       [GTIOErrorController handleAlert:(GTIOAlert *)object showRetryInView:self.view retryHandler:nil];
                    }
                }
            };
            loader.onDidFailWithError = ^(NSError *error) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:nil];
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
