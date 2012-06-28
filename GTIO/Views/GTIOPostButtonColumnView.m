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

static CGFloat const kGTIOTopButtonPadding = 4.0f;
static CGFloat const kGTIOButtonOriginX = 0.75f;

@interface GTIOPostButtonColumnView ()

@property (nonatomic, strong) UIImageView *accentLine;

@property (nonatomic, strong) GTIOPostSideButton *reviewButton;
@property (nonatomic, strong) GTIOPostSideButton *shopbagButton;

@property (nonatomic, strong) GTIOButton *reviewButtonModel;
@property (nonatomic, strong) GTIOButton *shopbagButtonModel;
@property (nonatomic, strong) NSArray *dotdotdotButtonModel;

@end

@implementation GTIOPostButtonColumnView

@synthesize post = _post;
@synthesize accentLine = _accentLine;
@synthesize reviewButton = _reviewButton, dotdotdotButton = _dotdotdotButton, shopbagButton = _shopbagButton;
@synthesize dotdotdotButtonTapHandler = _dotdotdotButtonTapHandler;
@synthesize reviewButtonModel = _reviewButtonModel, dotdotdotButtonModel = _dotdotdotButtonModel, shopbagButtonModel = _shopbagButtonModel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _accentLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line.png"]];
        [self addSubview:_accentLine];
        
        _reviewButton = [GTIOPostSideButton gtio_postSideButtonType:GTIOPostSideButtonTypeReview tapHandler:nil];
        [self addSubview:_reviewButton];
        
        _shopbagButton = [GTIOPostSideButton gtio_postSideButtonType:GTIOPostSideButtonTypeShopping tapHandler:nil];
        [self addSubview:_shopbagButton];
        
        _dotdotdotButton = [GTIOPostSideButton gtio_postSideButtonType:GTIOPostSideButtonTypeDotDotDot tapHandler:nil];
        [self addSubview:_dotdotdotButton];
    }
    return self;
}

- (void)prepareForReuse
{
    self.reviewButtonModel = nil;
    self.shopbagButtonModel = nil;
    self.dotdotdotButtonModel = nil;
}

#pragma mark - Properties

- (void)setPost:(GTIOPost *)post 
{
    _post = post;
    
    // Button models
    for (GTIOButton *button in _post.buttons) {
        if ([button.name isEqualToString:kGTIOPostSideReviewsButton]) {
            self.reviewButtonModel = button;
        } else if ([button.name isEqualToString:kGTIOPostSideShopButton]) {
            self.shopbagButtonModel = button;
        }
    }
    self.dotdotdotButtonModel = _post.dotOptionsButtons;
    
    // Buttons
    CGFloat topButtonOriginY = kGTIOTopButtonPadding;
    
    // Review button
    if (self.reviewButtonModel) {
        [self.reviewButton setFrame:(CGRect){ { kGTIOButtonOriginX, topButtonOriginY }, self.reviewButton.frame.size }];
        [self.reviewButton setTitle:[NSString stringWithFormat:@"%@", [self.reviewButtonModel.count intValue] > 0 ? self.reviewButtonModel.count : @""] forState:UIControlStateNormal];
        [self.reviewButton setTapHandler:^(id sender){
            NSLog(@"Review button tapped");
        }];
        topButtonOriginY += self.reviewButton.frame.size.height;
        [self.reviewButton setHidden:NO];
    } else {
        [self.reviewButton setHidden:YES];
    }
    
    // Shopping button
    if (self.shopbagButtonModel) {
        [self.shopbagButton setFrame:(CGRect){ { kGTIOButtonOriginX, topButtonOriginY }, self.reviewButton.frame.size }];
        [self.shopbagButton setTapHandler:^(id sender){
            NSLog(@"Shopbag button tapped");
        }];
        [self.shopbagButton setHidden:NO];
    } else {
        [self.shopbagButton setHidden:YES];
    }
    
    // ... button
    if ([_post.dotOptionsButtons count] > 0) {
        CGSize scaledPhotoSize = [GTIOPostFrameView scalePhotoSize:(CGSize){ [_post.photo.width floatValue], [_post.photo.height floatValue]} ];
        [self.dotdotdotButton setFrame:(CGRect){ { kGTIOButtonOriginX, kGTIOTopButtonPadding + 6 + scaledPhotoSize.height - self.dotdotdotButton.frame.size.height }, self.dotdotdotButton.frame.size }];
        
        [self.dotdotdotButton setTapHandler:self.dotdotdotButtonTapHandler];
        [self.dotdotdotButton setHidden:NO];
    } else {
        [self.dotdotdotButton setHidden:YES];
    }
}

- (void)setDotdotdotButtonTapHandler:(GTIOButtonDidTapHandler)dotdotdotButtonTapHandler
{
    _dotdotdotButtonTapHandler = dotdotdotButtonTapHandler;
    [self.dotdotdotButton setTapHandler:_dotdotdotButtonTapHandler];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.accentLine setFrame:(CGRect){ { frame.size.width - kGTIOAccentLinePixelsFromRightSizeOfScreen, 0 }, { self.accentLine.image.size.width, frame.size.height } }];
}

@end
