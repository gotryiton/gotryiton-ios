//
//  GTIOProductInformationBox.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/17/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductInformationBox.h"

static CGFloat const kGTIOProductNameLabelLeftMargin = 10.0;
static CGFloat const kGTIOProductNameLabelTopMargin = 10.0;
static CGFloat const kGTIOProductNameLabelWidth = 240.0;
static CGFloat const kGTIOProductNameLabelHeight = 38.0;
static CGFloat const kGTIOProductBrandLabelVerticalPadding = 1.0;
static CGFloat const kGTIOProductPriceLabelWidth = 50.0;
static CGFloat const kGTIOProductPriceLabelHeight = 22.0;
static CGFloat const kGTIOProductPriceLabelRightMargin = 13.0;
static CGFloat const kGTIOProductPriceLabelBottomMargin = 3.0;
static CGFloat const kGTIOProductBrandsLabelHeight = 14.0;
static CGFloat const kGTIOProductChevronRightPadding = 14.0;
static CGFloat const kGTIOProductChevronYPosition = 12.0;

@interface GTIOProductInformationBox()

@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *productBrandsLabel;
@property (nonatomic, strong) UILabel *productPriceLabel;
@property (nonatomic, strong) UIImageView *chevron;

@end

@implementation GTIOProductInformationBox

@synthesize productNameLabel = _productNameLabel, productBrandsLabel = _productBrandsLabel, productName = _productName, productBrands = _productBrands, productPrice = _productPrice, productPriceLabel = _productPriceLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImage imageNamed:@"product.info.rounded.bg.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 5.0, 5.0, 5.0, 5.0 }];
        
        _productNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _productNameLabel.backgroundColor = [UIColor clearColor];
        _productNameLabel.textColor = [UIColor gtio_grayTextColor585858];
        _productNameLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBook size:15.0];
        _productNameLabel.numberOfLines = 0;
        _productNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:_productNameLabel];
        
        _productBrandsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _productBrandsLabel.backgroundColor = [UIColor clearColor];
        _productBrandsLabel.textColor = [UIColor gtio_grayTextColorBBBBBB];
        _productBrandsLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:12.0];
        [self addSubview:_productBrandsLabel];
        
        _productPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _productPriceLabel.backgroundColor = [UIColor clearColor];
        _productPriceLabel.textColor = [UIColor gtio_grayTextColor585858];
        _productPriceLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBold size:22.0];
        _productPriceLabel.textAlignment = UITextAlignmentRight;
        _productPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_productPriceLabel];

        _chevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general.chevron.png"]];
        [self addSubview:_chevron];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.productNameLabel sizeToFit];
    [self.productNameLabel setFrame:(CGRect){ kGTIOProductNameLabelLeftMargin, kGTIOProductNameLabelTopMargin, kGTIOProductNameLabelWidth, self.productNameLabel.bounds.size.height }];
    [self.productBrandsLabel setFrame:(CGRect){ kGTIOProductNameLabelLeftMargin, self.productNameLabel.frame.origin.y + self.productNameLabel.bounds.size.height + kGTIOProductBrandLabelVerticalPadding, self.productNameLabel.bounds.size.width, kGTIOProductBrandsLabelHeight }];
    [self.productPriceLabel setFrame:(CGRect){ self.bounds.size.width - kGTIOProductPriceLabelWidth - kGTIOProductPriceLabelRightMargin, self.bounds.size.height - kGTIOProductPriceLabelHeight - kGTIOProductPriceLabelBottomMargin, kGTIOProductPriceLabelWidth, kGTIOProductPriceLabelHeight }];

    [self.chevron setFrame:(CGRect){ self.bounds.size.width - kGTIOProductChevronRightPadding,  kGTIOProductChevronYPosition, self.chevron.bounds.size }];
}

- (void)setProductName:(NSString *)productName
{
    _productName = productName;
    self.productNameLabel.text = _productName;
    [self setNeedsLayout];
}

- (void)setProductBrands:(NSString *)productBrands
{
    _productBrands = [productBrands uppercaseString];
    self.productBrandsLabel.text = _productBrands;
}

- (void)setProductPrice:(NSString *)productPrice
{
    _productPrice = productPrice;
    self.productPriceLabel.text = _productPrice;
}

@end
