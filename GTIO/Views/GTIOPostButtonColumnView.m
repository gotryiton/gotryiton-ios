//
//  GTIOPostButtonColumnView.m
//  GTIO
//
//  Created by Scott Penrose on 6/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostButtonColumnView.h"

#import "GTIOPostFrameView.h"
#import "GTIOPostHeaderView.h"
#import "GTIOPopOverView.h"
#import "GTIOProduct.h"
#import "GTIOProductFeedButton.h"

#import "GTIOReviewsViewController.h"

static CGFloat const kGTIOTopButtonPadding = 4.0f;
static CGFloat const kGTIOButtonOriginX = 0.75f;

static CGFloat const kGTIOAccentLineGap = 36.0f;
static CGFloat const kGTIOProductIconMargin = -1.0f;
static CGFloat const kGTIOProductIconSize = 32.0f;
static int const kGTIOProductLimit = 3;

@interface GTIOPostButtonColumnView ()

@property (nonatomic, strong) UIImageView *accentLine;
@property (nonatomic, strong) UIImageView *continuedAccentLine;

@property (nonatomic, strong) GTIOPostSideButton *reviewButton;

@property (nonatomic, strong) GTIOButton *reviewButtonModel;
@property (nonatomic, strong) NSArray *ellipsisButtonModel;

@property (nonatomic, strong) GTIOProductFeedButton *productIconOne;
@property (nonatomic, strong) GTIOProductFeedButton *productIconTwo;
@property (nonatomic, strong) GTIOProductFeedButton *productIconThree;
@property (nonatomic, strong) GTIOUIButton *shopThisLookHeaderButton;
@property (nonatomic, strong) UIImageView *bottomAccentLineCap;

@end

@implementation GTIOPostButtonColumnView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _accentLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line.png"]];
        [self addSubview:_accentLine];

        _continuedAccentLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line.png"]];
        [self addSubview:_continuedAccentLine];
        
        _reviewButton = [GTIOPostSideButton gtio_postSideButtonType:GTIOPostSideButtonTypeReview tapHandler:nil];
        [self addSubview:_reviewButton];
        
        _ellipsisButton = [GTIOPostSideButton gtio_postSideButtonType:GTIOPostSideButtonTypeEllipsis tapHandler:nil];
        [self addSubview:_ellipsisButton];

        _productIconOne = [GTIOProductFeedButton gtio_productFeedButton];
        [self addSubview:_productIconOne];
        
        _productIconTwo = [GTIOProductFeedButton gtio_productFeedButton];
        [self addSubview:_productIconTwo];

        _productIconThree = [GTIOProductFeedButton gtio_productFeedButton];
        [self addSubview:_productIconThree];

        _shopThisLookHeaderButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeShopThisLookHeaderButton];
        [self addSubview:_shopThisLookHeaderButton];

        _bottomAccentLineCap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line-separator-bottom.png"]];
        [self addSubview:_bottomAccentLineCap];

    }
    return self;
}

- (void)prepareForReuse
{
    [self resetProducts];
    [self resetAccentLine];
    
    self.reviewButtonModel = nil;
    self.ellipsisButtonModel = nil;
}

- (void)layoutSubviews 
{
    [self setUpShopThisLook];

}

#pragma mark - Properties

- (void)setPost:(GTIOPost *)post 
{
    _post = post;
    
    [self resetProducts];
    [self resetAccentLine];
    
    // Button models
    for (GTIOButton *button in _post.buttons) {
        if ([button.name isEqualToString:kGTIOPostSideReviewsButton]) {
            self.reviewButtonModel = button;
        } 
    }
    self.ellipsisButtonModel = _post.dotOptionsButtons;
    
    // Buttons
    CGFloat topButtonOriginY = kGTIOTopButtonPadding;
    
    // Review button
    if (self.reviewButtonModel) {
        [self.reviewButton setFrame:(CGRect){ { kGTIOButtonOriginX, topButtonOriginY }, self.reviewButton.frame.size }];
        [self.reviewButton setTitle:[NSString stringWithFormat:@"%@", [self.reviewButtonModel.count intValue] > 0 ? self.reviewButtonModel.count : @""] forState:UIControlStateNormal];
        if (self.post.reviewsButtonTapHandler) {
            [self.reviewButton setTapHandler:self.post.reviewsButtonTapHandler];
        }
        topButtonOriginY += self.reviewButton.frame.size.height;
        [self.reviewButton setHidden:NO];
    } else {
        [self.reviewButton setHidden:YES];
    }
    

     // ... button
    if ([_post.dotOptionsButtons count] > 0) {
        
        [self.ellipsisButton setFrame:(CGRect){ { kGTIOButtonOriginX, topButtonOriginY }, self.ellipsisButton.frame.size }];
        
        [self.ellipsisButton setHidden:NO];
    } else {
        [self.ellipsisButton setHidden:YES];
    }

    [self setUpShopThisLook];
    

}

- (void)setUpShopThisLook 
{
    if ([self.post.products count]>0){

        self.shopThisLookHeaderButton.hidden = NO;
        if (self.post.shopTheLookButtonTapHandler) {
            [self.shopThisLookHeaderButton setTapHandler:self.post.shopTheLookButtonTapHandler];
        }

        CGSize scaledPhotoSize = [GTIOPostFrameView scalePhotoSize:(CGSize){ [self.post.photo.width floatValue], [self.post.photo.height floatValue]} ];
        CGFloat YPositionForProducts = kGTIOTopButtonPadding + 7 + scaledPhotoSize.height;
        CGFloat centerLine = self.frame.size.width - kGTIOAccentLinePixelsFromRightSizeOfScreen ;
        
        for (int i=0; i<kGTIOProductLimit; i++){
            
            GTIOProductFeedButton *productIconButton;
            
            switch(i){
                case 0:
                    productIconButton = self.productIconOne;
                    break;
                case 1:
                    productIconButton = self.productIconTwo;
                    break;
                case 2:
                    productIconButton = self.productIconThree;
                    break;
            }
            if (i<self.post.products.count){
                GTIOProduct *product = [self.post.products objectAtIndex:i];   

                [productIconButton setWithImageUrl:product.photo.smallSquareThumbnailURL];
            
                YPositionForProducts -= productIconButton.frame.size.height;
                [productIconButton setFrame:(CGRect){ centerLine - productIconButton.frame.size.width/2 +1, YPositionForProducts , productIconButton.bounds.size}];

                productIconButton.hidden = NO;
                YPositionForProducts -= kGTIOProductIconMargin; 

                if (self.post.shopTheLookButtonTapHandler) {
                    [productIconButton setTapHandler:self.post.shopTheLookButtonTapHandler];
                }

            } else {

                productIconButton.hidden = YES;
                [productIconButton setTapHandler:nil];
            }   
            
        }
        
        CGFloat YPositionForShopBanner = YPositionForProducts - 3;
        
        [self.accentLine setFrame:(CGRect){ {centerLine, 0 }, { self.accentLine.image.size.width, YPositionForShopBanner - kGTIOAccentLineGap } }];
        
        [self.continuedAccentLine setFrame:(CGRect){ { centerLine, YPositionForShopBanner }, { self.accentLine.image.size.width, self.frame.size.height - YPositionForShopBanner  } }];
        
        YPositionForShopBanner -= self.bottomAccentLineCap.image.size.height;
        [self.bottomAccentLineCap setFrame:(CGRect){ { self.accentLine.frame.origin.x - ((self.bottomAccentLineCap.image.size.width - 2) / 2), YPositionForShopBanner }, self.bottomAccentLineCap.image.size }];
        
        YPositionForShopBanner = YPositionForShopBanner - kGTIOAccentLineGap + 2 + ((kGTIOAccentLineGap-self.shopThisLookHeaderButton.bounds.size.height)/2);
        [self.shopThisLookHeaderButton setFrame:(CGRect){ {self.accentLine.frame.origin.x - ((self.shopThisLookHeaderButton.bounds.size.width - 2) / 2), YPositionForShopBanner }, self.shopThisLookHeaderButton.bounds.size}];
        
        
    } else {
        [super setFrame:self.frame];
        [self resetProducts];
    }
}
    
- (void)setEllipsisButtonTapHandler:(GTIOButtonDidTapHandler)ellipsisButtonTapHandler
{
    _ellipsisButtonTapHandler = [ellipsisButtonTapHandler copy];
    [self.ellipsisButton setTapHandler:_ellipsisButtonTapHandler];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetAccentLine];
    
}
- (void)resetAccentLine
{
    [self.accentLine setFrame:(CGRect){ { self.frame.size.width - kGTIOAccentLinePixelsFromRightSizeOfScreen, 0 }, { self.accentLine.image.size.width, self.frame.size.height } }];
    [self.bottomAccentLineCap setFrame:CGRectZero];
    [self.continuedAccentLine setFrame:CGRectZero];
}

- (void)resetProducts
{

    self.shopThisLookHeaderButton.hidden = YES;
    [self.shopThisLookHeaderButton setTapHandler:nil];

    self.productIconOne.hidden = YES;
    [self.productIconOne setTapHandler:nil];
    self.productIconTwo.hidden = YES;
    [self.productIconTwo setTapHandler:nil];
    self.productIconThree.hidden = YES;
    [self.productIconThree setTapHandler:nil];
}
@end
