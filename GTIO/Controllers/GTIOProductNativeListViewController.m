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
#import "GTIORouter.h"
#import "DTCoreText.h"

static CGFloat const kGTIONavigationBarHeight = 44.0f;
static CGFloat const kGTIOTabBarHeight = 49.0f;
static CGFloat const kGTIOFooterXPadding = 10.0f;
static CGFloat const kGTIOFooterTopPadding = 6.0f;
static CGFloat const kGTIOFooterBottomPadding = 3.0f;
static NSString * const kGTIOFooterCss = @"CollectionFooter";

@interface GTIOProductNativeListViewController () <DTAttributedTextContentViewDelegate>

@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GTIOCollection *collection;
@property (nonatomic, strong) GTIOActionSheet *actionSheet;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *footerNotice;

@property (nonatomic, strong) DTAttributedTextView *footerTextView;
@property (nonatomic, strong) NSDictionary *footerAttributeTextOptions;

@property (nonatomic, strong) GTIOFullScreenImageViewer *fullScreenImageViewer;

@end

@implementation GTIOProductNativeListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
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
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.bounds.size.width, self.view.bounds.size.height - kGTIONavigationBarHeight } } style:UITableViewStylePlain];
    [self.tableView setContentInset:(UIEdgeInsets){ 0, 0, kGTIOTabBarHeight, 0 }];
    [self.tableView setScrollIndicatorInsets:(UIEdgeInsets){ 0, 0, kGTIOTabBarHeight, 0 }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    NSLog(@"view size %@", NSStringFromCGRect(self.view.frame));
    self.footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.footerNotice = [[UILabel alloc] initWithFrame: CGRectZero];
    [self.footerNotice setBackgroundColor:[UIColor clearColor]];
    [self.footerNotice setTextAlignment:UITextAlignmentCenter];
    [self.footerNotice setNumberOfLines:0];
    [self.footerNotice setLineBreakMode:UILineBreakModeWordWrap];

    [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
    self.footerTextView = [[DTAttributedTextView alloc] initWithFrame:CGRectZero];
    self.footerTextView.textDelegate = self;
    self.footerTextView.contentView.edgeInsets = (UIEdgeInsets) { -7, 0, 0, 0 };
    self.footerTextView.contentView.clipsToBounds = NO;
    [self.footerTextView setScrollEnabled:NO];
    [self.footerTextView setScrollsToTop:NO];
    [self.footerTextView setBackgroundColor:[UIColor clearColor]];
    [self.footerView addSubview:self.footerTextView];
    [self.tableView setTableFooterView:self.footerView];   

    NSString *filePath = [[NSBundle mainBundle] pathForResource:kGTIOFooterCss ofType:@"css"];  
    NSData *cssData = [NSData dataWithContentsOfFile:filePath];
    NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
    DTCSSStylesheet *defaultDTCSSStylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];

    self.footerAttributeTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor gtio_grayTextColor232323], DTDefaultTextColor,
                                            [NSNumber numberWithFloat:1.2], DTDefaultLineHeightMultiplier,
                                            [UIColor gtio_pinkTextColor], DTDefaultLinkColor,
                                            [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                            defaultDTCSSStylesheet, DTDefaultStyleSheet,
                                            nil];

    [self loadProducts];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetStatusBarBackground];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Load Data

- (void)loadProducts
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/collection/%i", self.collectionID.intValue] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            [GTIOProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.products removeAllObjects];
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOProduct class]]) {
                    [self.products addObject:object];
                }
                if ([object isMemberOfClass:[GTIOCollection class]]) {
                    self.collection = (GTIOCollection *)object;
                }
                
            }
            
            if (self.collection.footerText) {
                
                NSData *data = [self.collection.footerText dataUsingEncoding:NSUTF8StringEncoding];
    
                NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:self.footerAttributeTextOptions documentAttributes:NULL];
                self.footerTextView.attributedString = string;

                CGFloat footerWidth = self.tableView.frame.size.width - (2 * kGTIOFooterXPadding);
                CGSize expectedLabelSize = CGSizeMake(footerWidth,[self heightWithText:self.collection.footerText width:footerWidth]);
                
                // [self.footerNotice setText:self.collection.footerText];
                // [self.footerNotice setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11.0]];
                
                
                // [self.footerNotice setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
                
                
                
                [self.footerTextView setFrame:(CGRect){self.footerTextView.frame.origin.x, kGTIOFooterTopPadding, footerWidth, expectedLabelSize.height}];
                [self.footerView setFrame:(CGRect){kGTIOFooterXPadding, self.footerView.frame.origin.y, footerWidth , expectedLabelSize.height + kGTIOFooterBottomPadding + kGTIOFooterTopPadding}];

     
            }

            
            if (self.products.count > 0) {
                [self.tableView reloadData];
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            [GTIOProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:^(GTIORetryHUD *retryHUD) {
                [self loadProducts];
            }];
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
    NSLog(@"productButtonTap: %@ with productID = %@",button.action.endpoint, productID );
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

#pragma mark - Properties

- (void)setCollectionID:(NSNumber *)collectionID
{
    _collectionID = collectionID;
    [self loadProducts];
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
        [bannerImageDownloader setImageWithURL:_collection.bannerImage.imageURL success:^(UIImage *image, BOOL cached) {
            [bannerHeader setImage:image forState:UIControlStateNormal];
            bannerHeader.tapHandler = ^(id sender) {
                [self handleUrl:[NSURL URLWithString:_collection.bannerImage.action.destination]];
            };
            self.tableView.tableHeaderView = bannerHeader;
        } failure:nil];
    }
}


- (CGFloat)heightWithText:(NSString *)text width:(CGFloat)width
{
    [DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
    DTAttributedTextView *attributedTextView = [[DTAttributedTextView alloc] initWithFrame:(CGRect){ CGPointZero, { width, 0 } }];
    attributedTextView.contentView.edgeInsets = (UIEdgeInsets) { -7, 0, 0, 0 };
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kGTIOFooterCss ofType:@"css"];  
    NSData *cssData = [NSData dataWithContentsOfFile:filePath];
    NSString *cssString = [[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding];
    DTCSSStylesheet *stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:cssString];
    
    NSDictionary *attributedTextOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithBool:NO], DTDefaultLinkDecoration,
                                                      [NSNumber numberWithFloat:1.2], DTDefaultLineHeightMultiplier,
                                                      stylesheet, DTDefaultStyleSheet,
                                                      nil];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:attributedTextOptions documentAttributes:NULL];
    attributedTextView.attributedString = string;
    
    CGSize textSize = [attributedTextView.contentView sizeThatFits:(CGSize){ width, CGFLOAT_MAX }];
    
    return textSize.height;
}


#pragma mark Custom Views on Text

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame
{
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = url;
    button.minimumHitSize = CGSizeMake(20, 20); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark Actions

- (void)linkPushed:(DTLinkButton *)button
{
    [self handleUrl:button.URL];
}

- (void)handleUrl:(NSURL *)url
{
    UIViewController *viewController = [[GTIORouter sharedRouter] viewControllerForURL:url];
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([GTIORouter sharedRouter].fullScreenImageURL) {
        self.fullScreenImageViewer = [[GTIOFullScreenImageViewer alloc] initWithPhotoURL:[GTIORouter sharedRouter].fullScreenImageURL];
        [self.fullScreenImageViewer show];
    }
}

@end
