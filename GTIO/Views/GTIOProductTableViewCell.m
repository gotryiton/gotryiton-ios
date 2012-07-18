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

@interface GTIOProductTableViewCell()

@property (nonatomic, assign) GTIOProductTableCellType productTableCellType;

@property (nonatomic, strong) UIImageView *productImageView;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *backgroundImageInactive;
@property (nonatomic, strong) UIImage *backgroundImageActive;

@property (nonatomic, strong) GTIOUIButton *heartButton;
@property (nonatomic, strong) GTIOUIButton *emailButton;
@property (nonatomic, strong) GTIOUIButton *buyButton;

@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation GTIOProductTableViewCell

@synthesize product = _product, indexPath = _indexPath, delegate = _delegate;
@synthesize productTableCellType = _productTableCellType, productImageView = _productImageView, backgroundImageView = _backgroundImageView, backgroundImageInactive = _backgroundImageInactive, backgroundImageActive = _backgroundImageActive, heartButton = _heartButton, productNameLabel = _productNameLabel, brandLabel = _brandLabel, priceLabel = _priceLabel, emailButton = _emailButton, buyButton = _buyButton;

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
        
        _emailButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListEmail];
        [self.contentView addSubview:_emailButton];
        
        _buyButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListBuy];
        [self.contentView addSubview:_buyButton];
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
    
    [self.productImageView setFrame:(CGRect){ 5, 2, 155, 154 }];
    [self.backgroundImageView setFrame:(CGRect){ 3, 0, self.bounds.size.width - 6, 159 }];
    [self.heartButton setFrame:(CGRect){ 12, 7, self.heartButton.bounds.size }];
    CGSize productNameLabelSize = [self.productNameLabel sizeThatFits:(CGSize){ 109, CGFLOAT_MAX }];
    [self.productNameLabel setFrame:(CGRect){ 173, 10, 109, (productNameLabelSize.height <= 95) ? productNameLabelSize.height : 95 }];
    [self.brandLabel setFrame:(CGRect){ self.productNameLabel.frame.origin.x, self.productNameLabel.frame.origin.y + self.productNameLabel.bounds.size.height, 109, 15 }];
    [self.priceLabel setFrame:(CGRect){ self.productNameLabel.frame.origin.x, 129, 45, 20 }];
    [self.emailButton setFrame:(CGRect){ 222, 126, self.emailButton.bounds.size }];
    [self.buyButton setFrame:(CGRect){ self.emailButton.frame.origin.x + self.emailButton.bounds.size.width + 7, self.emailButton.frame.origin.y, self.buyButton.bounds.size }];
}

- (void)setProduct:(GTIOProduct *)product
{
    _product = product;
    
    if (!self.productImageView.image) {
        self.productImageView.alpha = 0.0;
        __block typeof(self) blockSelf = self;
        [self.productImageView setImageWithURL:_product.photo.squareThumbnailURL success:^(UIImage *image) {
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
                self.heartButton.enabled = NO;
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
                    loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                        for (id object in loadedObjects) {
                            if ([object isMemberOfClass:[GTIOProduct class]]) {
                                self.product = (GTIOProduct *)object;
                                self.heartButton.enabled = YES;
                            }
                        }
                    };
                    loader.onDidFailWithError = ^(NSError *error) {
                        self.heartButton.selected = !self.heartButton.selected;
                        self.product.hearted = !self.product.hearted;
                        self.heartButton.enabled = YES;
                    };
                }];
            };
        }
    }
    
    self.emailButton.tapHandler = ^(id sender) {
        self.emailButton.enabled = NO;
        [GTIOProduct emailProductWithProductID:_product.productID completionHandler:^(NSArray *loadedObjects, NSError *error) {
          self.emailButton.enabled = YES;
          if (!error) {
              for (id object in loadedObjects) {
                  if ([object isMemberOfClass:[GTIOProduct class]]) {
                      GTIOProduct *emailedProduct = (GTIOProduct *)object;
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"You should receive an email shortly about %@", emailedProduct.productName] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                      [alert show];
                  }
              }
          } else {
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"There was an error while emailing you that product. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
              [alert show];
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
    
    self.productNameLabel.text = _product.productName;
    self.brandLabel.text = [_product.brands uppercaseString];
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
