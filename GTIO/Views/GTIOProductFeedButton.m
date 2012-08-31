//
//  GTIOProductFeedButton.m
//  GTIO
//
//  Created by Simon Holroyd on 8/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductFeedButton.h"
#import "UIImageView+WebCache.h"

static CGFloat const kGTIOProductIconSize = 32.0f;

@interface GTIOProductFeedButton () 

@property (nonatomic, strong) UIImageView *productImage;
@property (nonatomic, strong) UIImageView *overlay;

@end

@implementation GTIOProductFeedButton


+ (id)gtio_productFeedButton
{
    GTIOProductFeedButton *button = [self buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];

    button.overlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop-this-look-thumb-overlay.png"]];
    
    button.productImage = [[UIImageView alloc] initWithImage:nil];
    
    [button addSubview:button.productImage];   
    [button.productImage.layer setMasksToBounds:YES];
    
    button.productImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [button addSubview:button.overlay];

    [button setFrame:(CGRect){{0,0},button.overlay.image.size}];

    [button setHidden:YES];

    return button;
}

-(void) setWithImageUrl:(NSURL *)url{
    [self.productImage setImageWithURL:url success:nil failure:nil];
    [self.productImage setFrame:(CGRect){ (self.frame.size.width-kGTIOProductIconSize)/2,(self.frame.size.width-kGTIOProductIconSize)/2,kGTIOProductIconSize, kGTIOProductIconSize}];
}


@end
