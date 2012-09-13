//
//  GTIOProductViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/16/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductViewController.h"
#import "GTIOPostALookViewController.h"

#import "GTIOFullScreenImageViewer.h"
#import "GTIORouter.h"

#import "GTIOProductHeartControl.h"
#import "GTIOProductInformationBox.h"

#import "GTIOButton.h"
#import "GTIOProduct.h"

#import "GTIOWebViewController.h"
#import "GTIOCameraViewController.h"
#import "GTIOAppDelegate.h"
#import "GTIOFilterManager.h"

#import <RestKit/RestKit.h>
#import "UIImageView+WebCache.h"

static CGFloat const kGTIOHeartControlLeftMargin = 4.0;
static CGFloat const kGTIOHeartControlTopMargin = 7.0;
static CGFloat const kGTIOHeartControlWidth = 89.0;
static CGFloat const kGTIOHeartControlHeight = 34.0;
static CGFloat const kGTIOProductBottomInformationBackgroundHeight = 130.0;
static CGFloat const kGTIOProductBottomInformationInnerBackgroundLeftMargin = 5.0;
static CGFloat const kGTIOProductBottomInformationInnerBackgroundTopMargin = 8.0;
static CGFloat const kGTIOProductBottomInformationInnerBackgroundWidth = 310.0;
static CGFloat const kGTIOProductBottomInformationInnerBackgroundHeight = 66.0;
static CGFloat const kGTIOProductPostButtonHeight = 46.0;
static CGFloat const kGTIOSocialShareButtonWidthHeight = 23.0;
static CGFloat const kGTIOSocialShareButtonTopMargin = 14.0;
static CGFloat const kGTIOTopRightRightPadding = 5.0;
static CGFloat const kGTIOProductNavigationBarTopStripeHeight = 4.0;

@interface GTIOProductViewController ()

@property (nonatomic, strong) GTIOProduct *product;
@property (nonatomic, strong) NSNumber *productID;

@property (nonatomic, strong) UIView *whiteBackground;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) GTIOFullScreenImageViewer *fullScreenImageViewer;

@property (nonatomic, strong) GTIOProductHeartControl *heartControl;
@property (nonatomic, strong) UIImageView *bottomInformationBackground;
@property (nonatomic, strong) GTIOProductInformationBox *productInformationBox;

@property (nonatomic, strong) GTIOUIButton *postThisButton;
@property (nonatomic, strong) GTIOUIButton *shoppingListButton;

@end

@implementation GTIOProductViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)initWithProductID:(NSNumber *)productID
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _productID = productID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductBack tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.leftNavigationButton = backButton;

    GTIOUIButton *openUrlButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductTopRightButton tapHandler:^(id sender) {
        [self tapToProductUrl];
    }];
    [self setRightNavigationButton:openUrlButton];

    
    self.whiteBackground = [[UIView alloc] initWithFrame:(CGRect){ 0, - self.navigationController.navigationBar.bounds.size.height , self.view.bounds.size.width, self.view.bounds.size.height  }];
    self.whiteBackground.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.whiteBackground];
    
    self.productImageView = [[UIImageView alloc] initWithFrame:self.whiteBackground.frame];
    self.productImageView.backgroundColor = [UIColor whiteColor];
    self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.productImageView.userInteractionEnabled = YES;
    self.productImageView.alpha = 0.0;
    [self.view addSubview:self.productImageView];
    
    UITapGestureRecognizer *productImageTapRecocgnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullScreenImage)];
    [self.productImageView addGestureRecognizer:productImageTapRecocgnizer];
    
    self.heartControl = [[GTIOProductHeartControl alloc] initWithFrame:(CGRect){ kGTIOHeartControlLeftMargin, kGTIOHeartControlTopMargin, kGTIOHeartControlWidth, kGTIOHeartControlHeight }];
    [self.view addSubview:self.heartControl];
    
    self.bottomInformationBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product.info.overlay.bg.png"]];
    [self.bottomInformationBackground setFrame:(CGRect){ 0, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - kGTIOProductBottomInformationBackgroundHeight, self.view.bounds.size.width, kGTIOProductBottomInformationBackgroundHeight }];
    [self.view addSubview:self.bottomInformationBackground];
    
    self.productInformationBox = [[GTIOProductInformationBox alloc] initWithFrame:(CGRect){ kGTIOProductBottomInformationInnerBackgroundLeftMargin, kGTIOProductBottomInformationInnerBackgroundTopMargin, kGTIOProductBottomInformationInnerBackgroundWidth, kGTIOProductBottomInformationInnerBackgroundHeight }];
    [self.bottomInformationBackground addSubview:self.productInformationBox];
    
    self.bottomInformationBackground.userInteractionEnabled = YES;
    UITapGestureRecognizer *productInfoTapRecocgnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToProductUrl)];
    [self.bottomInformationBackground addGestureRecognizer:productInfoTapRecocgnizer];

    self.postThisButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductPostThis];
    [self.postThisButton setFrame:(CGRect){ 5, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - kGTIOProductPostButtonHeight - 5, self.postThisButton.bounds.size }];
    self.postThisButton.alpha = 0.0;
    [self.view addSubview:self.postThisButton];
    
    if (self.productID) {
        [self refreshProduct];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"product.nav.bar.bg.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [GTIOProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.productImageView = nil;
    self.whiteBackground = nil;
    self.heartControl = nil;
    self.bottomInformationBackground = nil;
    self.productInformationBox = nil;
    self.postThisButton = nil;
    self.shoppingListButton = nil;
}

- (void)refreshProduct
{
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [GTIOProduct loadProductWithProductID:self.productID completionHandler:^(NSArray *loadedObjects, NSError *error) {
        if (!error) {
            [self refreshProductFromLoadedObjects:loadedObjects];
        } else {
            NSLog(@"%@", [error localizedDescription]);
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)refreshProductFromLoadedObjects:(NSArray *)loadedObjects
{
    BOOL updated = NO;
    for (id object in loadedObjects) {
        if ([object isMemberOfClass:[GTIOProduct class]]) {
            if (![(GTIOProduct *)object isEqual:self.product]) {
                self.product = (GTIOProduct *)object;
                updated = YES;
            }
        }
    }
    if (!updated) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)setProduct:(GTIOProduct *)product
{
    _product = product;
    
    if (_product.photo.mainImageURL.host.length == 0) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        self.productImageView.alpha = 1.0;
        self.postThisButton.alpha = 1.0;
        self.shoppingListButton.alpha = 1.0;
    } else {
        [self.productImageView setImageWithURL:_product.photo.mainImageURL success:^(UIImage *image) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [UIView animateWithDuration:0.25 animations:^{
                self.productImageView.alpha = 1.0;
                self.postThisButton.alpha = 1.0;
                self.shoppingListButton.alpha = 1.0;
            }];
        } failure:^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
    
    self.postThisButton.tapHandler = ^(id sender) {
        NSDictionary *userInfo = @{ kGTIOChangeSelectedTabToUserInfo : @(GTIOTabBarCamera) };
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOChangeSelectedTabNotification object:nil userInfo:userInfo];
        
        NSDictionary *photoUserInfo = @{
            @"originalPhoto": self.productImageView.image,
            @"filteredPhoto": self.productImageView.image,
            @"filterName": GTIOFilterTypeName[GTIOFilterTypeOriginal],
            @"productID": self.productID
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOPhotoAcceptedNotification object:nil userInfo:photoUserInfo];
    };
    
    for (GTIOButton *button in self.product.buttons) {
        if ([button.name isEqualToString:kGTIOProductHeartButton]) {
            self.heartControl.heartState = button.state;
            
            self.heartControl.heartTapHandler = ^(id sender) {
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
                    loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                        [self refreshProductFromLoadedObjects:loadedObjects];
                    };
                    loader.onDidFailWithError = ^(NSError *error) {
                        NSLog(@"%@", [error localizedDescription]);
                    };
                }];
            };
        }
        if ([button.name isEqualToString:kGTIOProductWhoHeartedButton]) {
            self.heartControl.heartCount = button.count;
            
            self.heartControl.countTapHandler = ^(id sender) {
                UIViewController *viewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.action.destination];
                [self.navigationController pushViewController:viewController animated:YES];
            };
        }
        if ([button.name isEqualToString:kGTIOProductShoppingListButton]) {
            [self.shoppingListButton removeFromSuperview];
            if (button.state.intValue == 0) {
                self.shoppingListButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingList];
                self.shoppingListButton.tapHandler = ^(id sender) {
                    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
                        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                            [self refreshProductFromLoadedObjects:loadedObjects];
                        };
                        loader.onDidFailWithError = ^(NSError *error) {
                            NSLog(@"%@", [error localizedDescription]);
                        };
                    }];
                };
            } else if (button.state.intValue == 1) {
                self.shoppingListButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListChecked];
                self.shoppingListButton.tapHandler = ^(id sender) {
                    UIViewController *viewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.action.destination];
                    [self.navigationController pushViewController:viewController animated:YES];
                };
            }
            [self.shoppingListButton setFrame:(CGRect){ self.postThisButton.frame.origin.x + self.postThisButton.bounds.size.width + 5, self.postThisButton.frame.origin.y, self.shoppingListButton.bounds.size }];
            if (!self.productImageView.image) {
                self.shoppingListButton.alpha = 0.0;
            }
            [self.view addSubview:self.shoppingListButton];
        }
    }
    
    self.productInformationBox.productName = _product.productName;
    self.productInformationBox.productBrands = _product.brand;
    self.productInformationBox.productPrice = _product.prettyPrice;
}

- (void)showFullScreenImage
{
    self.fullScreenImageViewer = [[GTIOFullScreenImageViewer alloc] initWithPhotoURL:self.product.photo.mainImageURL];
    self.fullScreenImageViewer.useAnimation = NO;
    [self.fullScreenImageViewer show];
}

- (void)tapToProductUrl
{
    UIViewController *viewController = [[GTIOWebViewController alloc] initWithNibName:nil bundle:nil];
    [((GTIOWebViewController *)viewController) setURL:self.product.buyURL];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
