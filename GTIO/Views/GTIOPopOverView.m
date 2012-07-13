//
//  GTIOPopOverView.m
//  GTIO
//
//  Created by Scott Penrose on 6/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPopOverView.h"

#import "GTIOButton.h"

static CGFloat const kGTIOButtonWidth = 164.0f;

@implementation GTIOPopOverView

@synthesize buttonModels = _buttonModels, tapHandler = _tapHandler;

- (id)initWithButtonModels:(NSArray *)buttonModels buttonType:(GTIOPopOverButtonType)buttonType
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _buttonModels = buttonModels;
        
        __block CGFloat yOrigin = 0.0f;
        [_buttonModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GTIOPopOverButton *button = nil;
            if (idx == 0) { // Top
                button = [GTIOPopOverButton gtio_popOverButtonWithButtonType:buttonType position:GTIOPopOverButtonPositionTop];
            } else if (idx == [_buttonModels count] - 1) { // bottom
                button = [GTIOPopOverButton gtio_popOverButtonWithButtonType:buttonType position:GTIOPopOverButtonPositionBottom];
            } else { // Middle
                button = [GTIOPopOverButton gtio_popOverButtonWithButtonType:buttonType position:GTIOPopOverButtonPositionMiddle];
            }
            [button setButtonModel:obj];
            [button setTapHandler:^(id sender) {
                GTIOPopOverButton *popOverButton = sender;
                if (self.tapHandler) {
                    self.tapHandler(popOverButton.buttonModel);
                }
            }];
            [button setFrame:(CGRect){ { 0, yOrigin }, button.frame.size }];
            [self addSubview:button];
            yOrigin += button.frame.size.height;
        }];
        
        [self setFrame:(CGRect){ CGPointZero, { kGTIOButtonWidth, yOrigin } }];
    }
    return self;
}

+ (id)popOverForPostDotDotDotWithButtonModels:(NSArray *)buttonModels
{
    return [[self alloc] initWithButtonModels:buttonModels buttonType:GTIOPopOverButtonTypeDot];
}

+ (id)popOverForCameraSources
{
    // Camera Roll
    GTIOButton *cameraRollButton = [[GTIOButton alloc] init];
    [cameraRollButton setName:@"camera roll"];
    
    GTIOButtonAction *cameraRollButtonAction = [[GTIOButtonAction alloc] init];
    [cameraRollButtonAction setDestination:@"gtio://camera-roll"];
    [cameraRollButton setAction:cameraRollButtonAction];
    
    // Hearted Products
    GTIOButton *heartedProductsButton = [[GTIOButton alloc] init];
    [heartedProductsButton setName:@"hearted products"];
    
    GTIOButtonAction *heartedProductsButtonAction = [[GTIOButtonAction alloc] init];
    [heartedProductsButtonAction setDestination:@"gtio://hearted-products"];
    [heartedProductsButton setAction:heartedProductsButtonAction];
    
    // Popular Products
    GTIOButton *popularProductsButton = [[GTIOButton alloc] init];
    [popularProductsButton setName:@"popular products"];
    
    GTIOButtonAction *popularProductsButtonAction = [[GTIOButtonAction alloc] init];
    [popularProductsButtonAction setDestination:@"gtio://popular-products"];
    [popularProductsButton setAction:popularProductsButtonAction];
    
    NSArray *buttonModels = [NSArray arrayWithObjects:cameraRollButton, heartedProductsButton, popularProductsButton, nil];
    
    return [[self alloc] initWithButtonModels:buttonModels buttonType:GTIOPopOverButtonTypeSource];
}

@end
