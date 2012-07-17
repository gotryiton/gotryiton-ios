//
//  GTIOProductInformationBox.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/17/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductInformationBox.h"

static CGFloat const kGTIOProductNameLabelLeftMargin = 10.0;
static CGFloat const kGTIOProductNameLabelTopMargin = 9.0;
static CGFloat const kGTIOProductNameLabelWidth = 240.0;
static CGFloat const kGTIOProductNameLabelHeight = 38.0;

@interface GTIOProductInformationBox()

@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *productBrandsLabel;
@property (nonatomic, strong) UILabel *productPriceLabel;

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
        _productNameLabel.numberOfLines = 2;
        _productNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:_productNameLabel];
        
        _productBrandsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _productBrandsLabel.backgroundColor = [UIColor clearColor];
        _productBrandsLabel.textColor = [UIColor gtio_grayTextColor];
        _productBrandsLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:12.0];
        [self addSubview:_productBrandsLabel];
        
        _productPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _productPriceLabel.backgroundColor = [UIColor clearColor];
        _productPriceLabel.textColor = [UIColor gtio_grayTextColor585858];
        _productPriceLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBold size:22.0];
        _productPriceLabel.textAlignment = UITextAlignmentRight;
        _productPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_productPriceLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.productNameLabel setFrame:(CGRect){ kGTIOProductNameLabelLeftMargin, kGTIOProductNameLabelTopMargin, kGTIOProductNameLabelWidth, kGTIOProductNameLabelHeight }];
    [self.productBrandsLabel setFrame:(CGRect){ kGTIOProductNameLabelLeftMargin, self.productNameLabel.frame.origin.y + self.productNameLabel.bounds.size.height, self.productNameLabel.bounds.size.width, 14 }];
    [self.productPriceLabel setFrame:(CGRect){ self.bounds.size.width - 50 - 10, self.bounds.size.height - 22 - 3, 50, 22 }];
}

- (void)setProductName:(NSString *)productName
{
    _productName = productName;
    self.productNameLabel.text = _productName;
}

- (void)setProductBrands:(NSString *)productBrands
{
    _productBrands = productBrands;
    self.productBrandsLabel.text = _productBrands;
}

- (void)setProductPrice:(NSString *)productPrice
{
    _productPrice = productPrice;
    self.productPriceLabel.text = _productPrice;
}

@end
