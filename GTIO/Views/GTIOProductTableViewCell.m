//
//  GTIOProductTableViewCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/18/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductTableViewCell.h"
#import "GTIOProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "GTIOUIButton.h"
#import "GTIOButton.h"
#import <RestKit/RestKit.h>

static CGFloat const kGTIOProductImageViewXPosition = 5.0;
static CGFloat const kGTIOProductImageViewYPosition = 1.0;
static CGFloat const kGTIOBackgroundImageViewXPosition = 3.0;
static CGFloat const kGTIOBackgroundImageViewYPosition = 0.0;
static CGFloat const kGTIOHeartButtonXPosition = 0.0;
static CGFloat const kGTIOHeartButtonYPosition = -4.0;
static CGFloat const kGTIOProductNameLabelWidth = 109.0;
static CGFloat const kGTIOProductNameLabelWidthWide = 130.0;
static CGFloat const kGTIOProductNameLabelMaxHeight = 95.0;
static CGFloat const kGTIOProductBrandLabelVerticalPadding = 2.0;
static CGFloat const kGTIOPriceLabelYPosition = 129.0;
static CGFloat const kGTIOEmailButtonXPosition = 222.0;
static CGFloat const kGTIOEmailButtonYPosition = 126.0;
static CGFloat const kGTIOBuyButtonRightMargin = 13.0;
static CGFloat const kGTIOBuyButtonBottomMargin = 13.0;
static CGFloat const kGTIODeleteButtonYPosition = 0.0;
static CGFloat const kGTIOProductNameLabelXPosition = 173.0;
static CGFloat const kGTIOProductNameLabelYPosition = 10.0;
static CGFloat const kGTIOCellButtonPadding = 6.0;

static CGFloat const kGTIOAddToShoppingListPopOverXOriginPadding = -20.0;
static CGFloat const kGTIOAddToShoppingListPopOverYOriginPadding = 4.0;

@interface GTIOProductTableViewCell()

@property (nonatomic, assign) GTIOProductTableCellType productTableCellType;

@property (nonatomic, strong) UIImageView *productImageView;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *backgroundImageInactive;
@property (nonatomic, strong) UIImage *backgroundImageActive;

@property (nonatomic, strong) GTIOUIButton *heartButton;
@property (nonatomic, strong) GTIOUIButton *buyButton;
@property (nonatomic, strong) GTIOUIButton *deleteButton;

@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIImageView *addToShoppingListPopOverView;


@end

@implementation GTIOProductTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier GTIOProductTableCellType:(GTIOProductTableCellType)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _productTableCellType = type;
        
        _productImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
        _productImageView.clipsToBounds = YES;
        [self.contentView addSubview:_productImageView];
        
        if (_productTableCellType == GTIOProductTableViewCellTypeShoppingList) {
            _backgroundImageInactive = [UIImage imageNamed:@"shop.list.cell.inactive.png"];
            _backgroundImageActive = [UIImage imageNamed:@"shop.list.cell.active.png"];
        } else if (_productTableCellType == GTIOProductTableViewCellTypeShopThisLook ||
                   _productTableCellType == GTIOProductTableViewCellTypeShoppingBrowse) {
            _backgroundImageInactive = [UIImage imageNamed:@"shop.cell.inactive.png"];
            _backgroundImageActive = [UIImage imageNamed:@"shop.cell.active.png"];
        }
        
        _backgroundImageView = [[UIImageView alloc] initWithImage:_backgroundImageInactive];
        [self.contentView addSubview:_backgroundImageView];
        
        _heartButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListHeart];
        [self.contentView addSubview:_heartButton];
        
        
        _productNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _productNameLabel.backgroundColor = [UIColor clearColor];
        _productNameLabel.textColor = [UIColor gtio_grayTextColor515152];
        _productNameLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:14.0];
        _productNameLabel.numberOfLines = 0;
        _productNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self.contentView addSubview:_productNameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor gtio_pinkTextColor];
        _priceLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLightItalic size:16.0];
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_priceLabel];
        
        _buyButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListBuy];
        [self.contentView addSubview:_buyButton];
        
        // Add To Shopping List Pop Over
        self.addToShoppingListPopOverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hearting-popup.png"]];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.productImageView setImageWithURL:nil];
    self.heartButton.selected = NO;
    self.heartButton.tapHandler = nil;
    self.productNameLabel.text = @"";
    self.priceLabel.text = @"";
    self.buyButton.tapHandler = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.productImageView setFrame:(CGRect){ kGTIOProductImageViewXPosition, kGTIOProductImageViewYPosition, 155, 154 }];
    [self.backgroundImageView setFrame:(CGRect){ kGTIOBackgroundImageViewXPosition, kGTIOBackgroundImageViewYPosition, self.bounds.size.width - kGTIOBackgroundImageViewXPosition * 2, 159 }];
    [self.heartButton setFrame:(CGRect){ kGTIOHeartButtonXPosition, kGTIOHeartButtonYPosition, self.heartButton.bounds.size }];
    CGSize productNameLabelSize = [self.productNameLabel sizeThatFits:(CGSize){ (self.productTableCellType == GTIOProductTableViewCellTypeShoppingList) ? kGTIOProductNameLabelWidth : kGTIOProductNameLabelWidthWide, CGFLOAT_MAX }];    
    [self.productNameLabel setFrame:(CGRect){ kGTIOProductNameLabelXPosition, kGTIOProductNameLabelYPosition, (self.productTableCellType == GTIOProductTableViewCellTypeShoppingList) ? kGTIOProductNameLabelWidth : kGTIOProductNameLabelWidthWide, (productNameLabelSize.height <= kGTIOProductNameLabelMaxHeight) ? productNameLabelSize.height : kGTIOProductNameLabelMaxHeight }];

    [self.priceLabel setFrame:(CGRect){ self.productNameLabel.frame.origin.x, self.productNameLabel.frame.origin.y + self.productNameLabel.bounds.size.height + kGTIOProductBrandLabelVerticalPadding, (self.productTableCellType == GTIOProductTableViewCellTypeShoppingList) ? kGTIOProductNameLabelWidth : kGTIOProductNameLabelWidthWide, 15 }];
    [self.buyButton setFrame:(CGRect){ self.bounds.size.width - self.buyButton.bounds.size.width - kGTIOBuyButtonRightMargin, self.bounds.size.height - self.buyButton.bounds.size.height - kGTIOBuyButtonBottomMargin, self.buyButton.bounds.size }];
    [self.deleteButton setFrame:(CGRect){ self.bounds.size.width - self.deleteButton.bounds.size.width, kGTIODeleteButtonYPosition, 26, 20 }];
    self.heartButton.enabled = YES;

}

- (void)setProduct:(GTIOProduct *)product
{
    _product = product;
    
    if (!self.productImageView.image) {
        self.productImageView.alpha = 0.0;
        __block typeof(self) blockSelf = self;
        [self.productImageView setImageWithURL:_product.photo.squareThumbnailURL success:^(UIImage *image, BOOL cached) {
            [UIView animateWithDuration:0.25 animations:^{
                blockSelf.productImageView.alpha = 1.0;
            }];
        } failure:^(NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
    
    self.heartButton.selected = _product.hearted;

    for (GTIOButton *button in self.product.buttons) {
        if ([button.name isEqualToString:kGTIOProductHeartButton]) {
            self.heartButton.tapHandler = ^(id sender) {
                self.heartButton.selected = !self.heartButton.selected;
                self.product.hearted = !self.product.hearted;
                //self.heartButton.enabled = NO;

                if ([self.delegate respondsToSelector:@selector(productButtonTap:productID:)]) {
                    [self.delegate productButtonTap:button productID:self.product.productID];
                }

            };
        }
    }
    __block typeof(self) blockSelf = self;
    
    [self.buyButton setTitle:product.retailerDomain forState:UIControlStateNormal];
    self.buyButton.tapHandler = ^(id sender) {
        if (_product.buyURL.host.length > 0) {
            if ([self.delegate respondsToSelector:@selector(loadWebViewControllerWithURL:)]) {
                [self.delegate loadWebViewControllerWithURL:_product.buyURL];
            }
        }
    };
    
    self.deleteButton.tapHandler = ^(id sender) {
        if ([self.delegate respondsToSelector:@selector(removeProduct:)]) {
            [self.delegate removeProduct:self.product];
        }
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%i/remove-from-my-shopping-list", self.product.productID.intValue] usingBlock:^(RKObjectLoader *loader) {
            loader.onDidFailWithError = ^(NSError *error) {
                [GTIOErrorController handleError:error showRetryInView:blockSelf forceRetry:NO retryHandler:nil];
                NSLog(@"%@", [error localizedDescription]);
            };
        }];
    };
    
    self.productNameLabel.text = _product.productName;
    self.priceLabel.text = _product.prettyPrice;

    if (self.productTableCellType != GTIOProductTableViewCellTypeShoppingList){
        [self showAddToShoppingListPopOverView];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        [_backgroundImageView setImage:_backgroundImageActive];
    } else {
        [_backgroundImageView setImage:_backgroundImageInactive];
    }
}



- (void)showAddToShoppingListPopOverView
{
    int viewsOfAddToShoppingListPopOverView = [[NSUserDefaults standardUserDefaults] integerForKey:kGTIOAddToShoppingListViewFlag];
    if (viewsOfAddToShoppingListPopOverView < 1) {
        viewsOfAddToShoppingListPopOverView++;
        [[NSUserDefaults standardUserDefaults] setInteger:viewsOfAddToShoppingListPopOverView forKey:kGTIOAddToShoppingListViewFlag];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self.addToShoppingListPopOverView setAlpha:1.0f];
        [self.addToShoppingListPopOverView setFrame:(CGRect){ { self.heartButton.frame.origin.x + self.heartButton.frame.size.width + kGTIOAddToShoppingListPopOverXOriginPadding, kGTIOAddToShoppingListPopOverYOriginPadding }, self.addToShoppingListPopOverView.image.size }];
        [self addSubview:self.addToShoppingListPopOverView];
        
        [UIView animateWithDuration:1.5f delay:1.75f options:0 animations:^{
            [self.addToShoppingListPopOverView setFrame:CGRectOffset(self.addToShoppingListPopOverView.frame, 24.0f, 0)];
            [self.addToShoppingListPopOverView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.addToShoppingListPopOverView removeFromSuperview];
        }];
    }
}

@end
