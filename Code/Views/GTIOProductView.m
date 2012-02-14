//
//  GTIOProductView.m
//  GTIO
//
//  Created by Joshua Johnson on 2/7/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import "GTIOProductView.h"
#import "GTIOProduct.h"

const CGFloat kGTIOMaxProductImageWidth = 60.0;
const CGFloat kGTIOMaxProductImageHeight = 80.0;
const CGFloat kGTIOProductLabelSpacer = 4.0;

@interface GTIOProductView () {
    TTImageView *_productImageView;
    UILabel *_suggestionLabel;
    UILabel *_productNameLabel;
    UILabel *_productBrandLabel;
    UILabel *_productPriceLabel;
}
@end

@implementation GTIOProductView

#pragma mark - synth

@synthesize product = _product, suggestionText = _suggestionText;

#pragma mark - lifecycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setClipsToBounds:YES];

        _productImageView = [[TTImageView alloc] initWithFrame:CGRectZero];
        [_productImageView setDelegate:self];
        [_productImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_productImageView];
        [_productImageView setClipsToBounds:YES];
        
        _suggestionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_suggestionLabel setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
        [_suggestionLabel setTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0]];
        [_suggestionLabel setFont:kGTIOFontBoldHelveticaNeueOfSize(9)];
        [_suggestionLabel setTextAlignment:UITextAlignmentCenter];
        [self addSubview:_suggestionLabel];
        
        _productNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_productNameLabel setBackgroundColor:[UIColor clearColor]];
        [_productNameLabel setTextColor:[UIColor colorWithRed:232/255.0 green:19/255.0 blue:154/255.0 alpha:1.0]];
        [_productNameLabel setFont:kGTIOFontBoldHelveticaNeueOfSize(12)];
        [_productNameLabel setTextAlignment:UITextAlignmentLeft];
        [self addSubview:_productNameLabel];
        
        _productBrandLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_productBrandLabel setBackgroundColor:[UIColor clearColor]];
        [_productBrandLabel setTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0]];
        [_productBrandLabel setFont:kGTIOFontHelveticaNeueOfSize(12)];
        [_productBrandLabel setTextAlignment:UITextAlignmentLeft];
        [self addSubview:_productBrandLabel];

        _productPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_productPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_productPriceLabel setTextColor:[UIColor darkGrayColor]];
        [_productPriceLabel setFont:kGTIOFontHelveticaNeueOfSize(12)];
        [_productPriceLabel setTextAlignment:UITextAlignmentLeft];
        [self addSubview:_productPriceLabel];
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_product);
    TT_RELEASE_SAFELY(_suggestionText);
    TT_RELEASE_SAFELY(_productImageView);
    TT_RELEASE_SAFELY(_suggestionLabel);
    TT_RELEASE_SAFELY(_productNameLabel);
    TT_RELEASE_SAFELY(_productBrandLabel);
    TT_RELEASE_SAFELY(_productPriceLabel);
    [super dealloc];
}

#pragma mark - property override to force layout update

- (void)setProduct:(GTIOProduct *)product {
    if (_product != product) {
        [_product release];
        _product = [product retain];
        [_productImageView setUrlPath:_product.smallThumbnail];
        [self setNeedsLayout];
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    CGRect viewRect = self.frame;
    CGFloat verticalOffset = 6.0;
    CGFloat horizontalOffset = 72.0;
    
    [_suggestionLabel setText:_suggestionText];
    CGSize suggestionLabelSize = [_suggestionText sizeWithFont:kGTIOFontBoldHelveticaNeueOfSize(9)];
    [_suggestionLabel setFrame:(CGRect){horizontalOffset - 4, verticalOffset, suggestionLabelSize.width + 6, suggestionLabelSize.height}];
    
    verticalOffset += suggestionLabelSize.height + kGTIOProductLabelSpacer + 2; // Add 2 px spacing as per Matt V. Story #24361445
    
    [_productNameLabel setText:_product.productName];
    CGSize constraint = (CGSize){self.frame.size.width - horizontalOffset, 20};
    CGSize productLabelSize = [_product.productName sizeWithFont:kGTIOFontHelveticaNeueOfSize(12) constrainedToSize:constraint];
    [_productNameLabel setFrame:(CGRect){horizontalOffset, verticalOffset, self.frame.size.width - horizontalOffset, productLabelSize.height}];
    
    verticalOffset += productLabelSize.height + kGTIOProductLabelSpacer;
    
    [_productBrandLabel setText:_product.brand];
    CGSize brandLabelSize = [_product.brand sizeWithFont:kGTIOFontHelveticaNeueOfSize(12)];
    [_productBrandLabel setFrame:(CGRect){horizontalOffset, verticalOffset, brandLabelSize.width + 12, brandLabelSize.height}];
    
    verticalOffset += brandLabelSize.height + kGTIOProductLabelSpacer;
    
    if (_product.prettyPrice) {
        [_productPriceLabel setText:_product.prettyPrice];
        CGSize priceLabelSize = [[_productPriceLabel text] sizeWithFont:kGTIOFontHelveticaNeueOfSize(12)];
        [_productPriceLabel setFrame:(CGRect){horizontalOffset, verticalOffset, priceLabelSize.width + 12, priceLabelSize.height}];
        verticalOffset += priceLabelSize.height + kGTIOProductLabelSpacer;
    }
    
    float vOffset = [[self class] productViewHeightForProduct:_product];
    viewRect.size.height = MAX(kGTIOMaxProductImageHeight, vOffset);
    
    [self setFrame:viewRect];
}

#pragma mark - TTImageViewDelegate

- (void)imageView:(TTImageView *)imageView didLoadImage:(UIImage *)image {
    CGRect imageRect = (CGRect){CGPointZero, image.size};
    if (image.size.width > kGTIOMaxProductImageWidth) {
        CGFloat ratio = image.size.width * 1.0 / image.size.height;
        imageRect.size.width = kGTIOMaxProductImageWidth;
        imageRect.size.height = MIN(kGTIOMaxProductImageHeight, kGTIOMaxProductImageWidth / ratio);
    }
    [imageView setFrame:imageRect];
}

#pragma mark - class methods

+ (CGFloat)productViewHeightForProduct:(GTIOProduct *)product {
    CGFloat verticalOffset = 18.0;
    verticalOffset += kGTIOProductLabelSpacer + 2;

    CGSize productLabelSize = [product.productName sizeWithFont:kGTIOFontHelveticaNeueOfSize(12)];
    verticalOffset += productLabelSize.height + kGTIOProductLabelSpacer;
    
    CGSize brandLabelSize = [product.brand sizeWithFont:kGTIOFontHelveticaNeueOfSize(12)];
    verticalOffset += brandLabelSize.height + kGTIOProductLabelSpacer;
    
    CGSize priceLabelSize = [product.prettyPrice sizeWithFont:kGTIOFontHelveticaNeueOfSize(12)];
    verticalOffset += priceLabelSize.height + kGTIOProductLabelSpacer;

    return MAX(kGTIOMaxProductImageHeight, verticalOffset);
}

@end
