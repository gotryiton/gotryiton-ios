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
static CGFloat const kGTIOBuyButtonLeftMargin = 7.0;
static CGFloat const kGTIODeleteButtonYPosition = 0.0;
static CGFloat const kGTIOProductNameLabelXPosition = 173.0;
static CGFloat const kGTIOProductNameLabelYPosition = 10.0;
static CGFloat const kGTIOCellButtonPadding = 6.0;

@interface GTIOProductTableViewCell()

@property (nonatomic, assign) GTIOProductTableCellType productTableCellType;

@property (nonatomic, strong) UIImageView *productImageView;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *backgroundImageInactive;
@property (nonatomic, strong) UIImage *backgroundImageActive;

@property (nonatomic, strong) GTIOUIButton *heartButton;
@property (nonatomic, strong) GTIOUIButton *emailButton;
@property (nonatomic, strong) GTIOUIButton *buyButton;
@property (nonatomic, strong) GTIOUIButton *deleteButton;

@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation GTIOProductTableViewCell

@synthesize product = _product, delegate = _delegate;
@synthesize productTableCellType = _productTableCellType, productImageView = _productImageView, backgroundImageView = _backgroundImageView, backgroundImageInactive = _backgroundImageInactive, backgroundImageActive = _backgroundImageActive, heartButton = _heartButton, productNameLabel = _productNameLabel, brandLabel = _brandLabel, priceLabel = _priceLabel, emailButton = _emailButton, buyButton = _buyButton, deleteButton = _deleteButton;

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
        _productNameLabel.textColor = [UIColor gtio_grayTextColor595155];
        _productNameLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:14.0];
        _productNameLabel.numberOfLines = 0;
        _productNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self.contentView addSubview:_productNameLabel];
        
        _brandLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandLabel.backgroundColor = [UIColor clearColor];
        _brandLabel.textColor = [UIColor gtio_grayTextColorBBBBBB];
        _brandLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:11.0];
        [self.contentView addSubview:_brandLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor gtio_pinkTextColor];
        _priceLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBold size:16.0];
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_priceLabel];
        
        
        if (_productTableCellType == GTIOProductTableViewCellTypeShoppingList) {
            _emailButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListEmail];
            [_emailButton setTapAreaPadding:kGTIOCellButtonPadding];
            [self.contentView addSubview:_emailButton];
            
            _buyButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListBuy];
            [_buyButton setTapAreaPadding:kGTIOCellButtonPadding];
            [self.contentView addSubview:_buyButton];
            
            _deleteButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListDelete];
            [_deleteButton setTapAreaPadding:kGTIOCellButtonPadding];
            [self.contentView addSubview:_deleteButton];
        }
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
    self.brandLabel.text = @"";
    self.priceLabel.text = @"";
    self.emailButton.tapHandler = nil;
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
    [self.brandLabel setFrame:(CGRect){ self.productNameLabel.frame.origin.x, self.productNameLabel.frame.origin.y + self.productNameLabel.bounds.size.height + kGTIOProductBrandLabelVerticalPadding, (self.productTableCellType == GTIOProductTableViewCellTypeShoppingList) ? kGTIOProductNameLabelWidth : kGTIOProductNameLabelWidthWide, 15 }];
    [self.priceLabel setFrame:(CGRect){ self.productNameLabel.frame.origin.x, kGTIOPriceLabelYPosition, 45, 20 }];
    [self.emailButton setFrame:(CGRect){ kGTIOEmailButtonXPosition, kGTIOEmailButtonYPosition, self.emailButton.bounds.size }];
    [self.buyButton setFrame:(CGRect){ self.emailButton.frame.origin.x + self.emailButton.bounds.size.width + kGTIOBuyButtonLeftMargin, self.emailButton.frame.origin.y, self.buyButton.bounds.size }];
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
    self.emailButton.tapHandler = ^(id sender) {
        self.emailButton.enabled = NO;
        [GTIOProduct emailProductWithProductID:_product.productID completionHandler:^(NSArray *loadedObjects, NSError *error) {
          self.emailButton.enabled = YES;
          if (!error) {
              for (id object in loadedObjects) {
                  if ([object isMemberOfClass:[GTIOAlert class]]) {
                        [GTIOErrorController handleAlert:(GTIOAlert *)object showRetryInView:blockSelf retryHandler:nil];
                  }
              }
          } else {
              [GTIOErrorController handleError:error showRetryInView:blockSelf forceRetry:NO retryHandler:nil];
          }
        }];
    };
    
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
    self.brandLabel.text = [_product.brand uppercaseString];
    self.priceLabel.text = _product.prettyPrice;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        [_backgroundImageView setImage:_backgroundImageActive];
    } else {
        [_backgroundImageView setImage:_backgroundImageInactive];
    }
}

@end
