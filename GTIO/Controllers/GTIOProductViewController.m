//
//  GTIOProductViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/16/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductViewController.h"
#import "GTIOFullScreenImageViewer.h"
#import "GTIOProduct.h"

#import "UIImageView+WebCache.h"

@interface GTIOProductViewController ()

@property (nonatomic, strong) GTIOProduct *product;
@property (nonatomic, strong) NSNumber *productID;

@property (nonatomic, strong) UIView *whiteBackground;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) GTIOFullScreenImageViewer *fullScreenImageViewer;

@end

@implementation GTIOProductViewController

@synthesize product = _product, productID = _productID, productImageView = _productImageView, fullScreenImageViewer = _fullScreenImageViewer, whiteBackground = _whiteBackground;

- (id)initWithProductID:(NSNumber *)productID
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _productID = productID;
        self.hidesBottomBarWhenPushed = YES;
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
    
    self.whiteBackground = [[UIView alloc] initWithFrame:(CGRect){ 0, -40, self.view.bounds.size.width, self.view.bounds.size.height - 4 }];
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
    
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [GTIOProduct loadProductWithProductID:self.productID completionHandler:^(NSArray *loadedObjects, NSError *error) {
        if (!error) {
            for (id object in loadedObjects) {
                if ([object isMemberOfClass:[GTIOProduct class]]) {
                    self.product = (GTIOProduct *)object;
                }
            }
        } else {
            NSLog(@"%@", [error localizedDescription]);
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
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
}

- (void)setProduct:(GTIOProduct *)product
{
    _product = product;
    
    [self.productImageView setImageWithURL:_product.photo.mainImageURL success:^(UIImage *image) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.productImageView.alpha = 1.0;
        }];
    } failure:^(NSError *error) {
        [GTIOProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)showFullScreenImage
{
    self.fullScreenImageViewer = [[GTIOFullScreenImageViewer alloc] initWithPhotoURL:self.product.photo.mainImageURL];
    [self.fullScreenImageViewer show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
