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

static CGFloat const kGTIOAddToShoppingListPopOverXOriginPadding = 65.0;
static CGFloat const kGTIOAddToShoppingListPopOverYOriginPadding = -2.0;

@interface GTIOProductViewController ()

@property (nonatomic, strong) GTIOProduct *product;
@property (nonatomic, strong) NSNumber *productID;

@property (nonatomic, strong) UIView *whiteBackground;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) GTIOFullScreenImageViewer *fullScreenImageViewer;

@property (nonatomic, strong) GTIOProductHeartControl *heartControl;
@property (nonatomic, strong) UIImageView *bottomInformationBackground;
@property (nonatomic, strong) GTIOProductInformationBox *productInformationBox;

@property (nonatomic, strong) GTIOUIButton *bigBuyButton;
@property (nonatomic, strong) GTIOUIButton *emailToMeButton;

@property (nonatomic, strong) UIImageView *addToShoppingListPopOverView;

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

    _emailToMeButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListEmailMyList tapHandler:nil];
    [self setRightNavigationButton:_emailToMeButton];

    
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
    

    self.bigBuyButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductBigBuyButton];
    [self.bigBuyButton setFrame:(CGRect){ 5, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - kGTIOProductPostButtonHeight - 5, self.bigBuyButton.bounds.size }];
    [self.view addSubview:self.bigBuyButton];
    
    // Add To Shopping List Pop Over
    self.addToShoppingListPopOverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hearting-popup.png"]];
    

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
    self.bigBuyButton = nil;
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

    __block typeof(self) blockSelf = self;
    
    if (_product.photo.mainImageURL.host.length == 0) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        self.productImageView.alpha = 1.0;
    } else {
        [self.productImageView setImageWithURL:_product.photo.mainImageURL success:^(UIImage *image, BOOL cached) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            [UIView animateWithDuration:0.25 animations:^{
                self.productImageView.alpha = 1.0;
            }];
        } failure:^(NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
    
    [self.self.bigBuyButton setTitle:[_product.retailerDomain lowercaseString] forState:UIControlStateNormal];
    self.bigBuyButton.tapHandler = ^(id sender) {
        [blockSelf tapToProductUrl];
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
        
    }
    
    self.productInformationBox.productName = _product.productName;
    self.productInformationBox.productPrice = _product.prettyPrice;

    [self.emailToMeButton setTapHandler:^(id sender) {
        self.emailToMeButton.enabled = NO;
        [GTIOProduct emailProductWithProductID:self.product.productID completionHandler:^(NSArray *loadedObjects, NSError *error) {
            self.emailToMeButton.enabled = YES;
            if (!error) {
              for (id object in loadedObjects) {
                  if ([object isMemberOfClass:[GTIOAlert class]]) {
                        [GTIOErrorController handleAlert:(GTIOAlert *)object showRetryInView:blockSelf.view retryHandler:nil];
                  }
              }
            } else {
              [GTIOErrorController handleError:error showRetryInView:blockSelf.view forceRetry:NO retryHandler:nil];
            }
        }];
    }];

    [self showAddToShoppingListPopOverView];
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


- (void)showAddToShoppingListPopOverView
{
   int viewsOfAddToShoppingListPopOverView = [[NSUserDefaults standardUserDefaults] integerForKey:kGTIOAddToShoppingListProductPageViewFlag];
   if (viewsOfAddToShoppingListPopOverView < 1) {
       viewsOfAddToShoppingListPopOverView++;
       [[NSUserDefaults standardUserDefaults] setInteger:viewsOfAddToShoppingListPopOverView forKey:kGTIOAddToShoppingListProductPageViewFlag];
       [[NSUserDefaults standardUserDefaults] synchronize];
       
        [self.addToShoppingListPopOverView setAlpha:1.0f];
        [self.addToShoppingListPopOverView setUserInteractionEnabled:YES];
        [self.addToShoppingListPopOverView setFrame:(CGRect){ { self.heartControl.frame.origin.x + kGTIOAddToShoppingListPopOverXOriginPadding, self.heartControl.frame.origin.y + kGTIOAddToShoppingListPopOverYOriginPadding }, self.addToShoppingListPopOverView.image.size }];
        [self.view addSubview:self.addToShoppingListPopOverView];
        
        UITapGestureRecognizer *closeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAddToShoppingListPopOverView)];
        [self.addToShoppingListPopOverView addGestureRecognizer:closeRecognizer];

   }
}

- (void)removeAddToShoppingListPopOverView
{
    [self.addToShoppingListPopOverView setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.75f delay:0 options:0 animations:^{
        [self.addToShoppingListPopOverView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self.addToShoppingListPopOverView removeFromSuperview];
    }];
}


@end
