//
//  GTIOProductNativeListViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductNativeListViewController.h"
#import <RestKit/RestKit.h>
#import "GTIOProduct.h"
#import "GTIOProductViewController.h"
#import "GTIOShoppingListViewController.h"
#import "GTIOCollection.h"
#import "GTIOActionSheet.h"
#import "UIImageView+WebCache.h"
#import "GTIOFullScreenImageViewer.h"

@interface GTIOProductNativeListViewController ()

@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GTIOCollection *collection;
@property (nonatomic, strong) GTIOActionSheet *actionSheet;

@property (nonatomic, strong) GTIOFullScreenImageViewer *fullScreenImageViewer;

@end

@implementation GTIOProductNativeListViewController

@synthesize products = _products, tableView = _tableView, collectionID = _collectionID, collection = _collection, actionSheet = _actionSheet, fullScreenImageViewer = _fullScreenImageViewer;

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
	
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = backButton;
    
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
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/collection/%i", self.collectionID.intValue] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [self.products removeAllObjects];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOProduct class]]) {
                    [self.products addObject:object];
                }
                if ([object isMemberOfClass:[GTIOCollection class]]) {
                    self.collection = (GTIOCollection *)object;
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

- (void)setCollection:(GTIOCollection *)collection
{
    _collection = collection;
    
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:_collection.name italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *actionSheetButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListNav tapHandler:^(id sender) {
        GTIOActionSheet *actionSheet = [[GTIOActionSheet alloc] initWithButtons:_collection.dotOptions buttonTapHandler:nil];
        [actionSheet show];
    }];
    self.rightNavigationButton = actionSheetButton;
    
    if (_collection.bannerImage) {
        GTIOUIButton *bannerHeader = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeMask];
        [bannerHeader setFrame:(CGRect){ 0, 0, _collection.bannerImage.width.floatValue, _collection.bannerImage.height.floatValue }];
        UIImageView *bannerImageDownloader = [[UIImageView alloc] initWithFrame:CGRectZero];
        [bannerImageDownloader setImageWithURL:_collection.bannerImage.imageURL success:^(UIImage *image) {
            [bannerHeader setImage:image forState:UIControlStateNormal];
            bannerHeader.tapHandler = ^(id sender) {
                self.fullScreenImageViewer = [[GTIOFullScreenImageViewer alloc] initWithPhotoURL:_collection.bannerImage.imageURL];
                [self.fullScreenImageViewer show];
            };
            self.tableView.tableHeaderView = bannerHeader;
        } failure:nil];
    }
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
    NSLog(@"productButtonTap: %@ with productID = %@",button.action.endpoint, productID );
    __block typeof(self) blockSelf = self;
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOProduct class]]) {

                    // product button endpoints respond with a fresh object so just update it                    
                    GTIOProduct *newObject = (GTIOProduct *)object;
                    
                    [self.products replaceObjectAtIndex:[blockSelf indexOfProductWithId:newObject.productID] withObject: newObject];

                    [blockSelf.tableView reloadData];
                    [blockSelf.tableView layoutSubviews];
                }
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [blockSelf.tableView reloadData];
            [blockSelf.tableView layoutSubviews];

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
        cell = [[GTIOProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier GTIOProductTableCellType:GTIOProductTableViewCellTypeShoppingBrowse];
    }
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
