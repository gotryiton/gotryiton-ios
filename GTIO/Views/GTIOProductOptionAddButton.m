//
//  GTIOProductOptionAddButton.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductOptionAddButton.h"
#import "GTIOUIButton.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "GTIOButton.h"
#import <RestKit/RestKit.h>

@interface GTIOProductOptionAddButton()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) GTIOUIButton *maskButton;
@property (nonatomic, strong) UIImageView *plusSignActiveView;

@end

@implementation GTIOProductOptionAddButton

@synthesize iconView = _iconView, maskButton = _maskButton, productOption = _productOption, plusSignActiveView = _plusSignActiveView, delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconView = [[UIImageView alloc] initWithFrame:self.bounds];
        _iconView.layer.cornerRadius = 3.0;
        _iconView.layer.masksToBounds = YES;
        [self addSubview:_iconView];
        
        _maskButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeProductShoppingListProductOption];
        [_maskButton setFrame:(CGRect){ -5, -5, self.bounds.size.width + 10, self.bounds.size.height + 10 }];
        _maskButton.touchDownHandler = ^(id sender) {
            self.plusSignActiveView.hidden = NO;
        };
        _maskButton.touchDragExitHandler = ^(id sender) {
            self.plusSignActiveView.hidden = YES;
        };
        [self addSubview:_maskButton];
        
        _plusSignActiveView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopping.bottom.plus.active.png"]];
        [_plusSignActiveView setFrame:(CGRect){ self.bounds.size.width - _plusSignActiveView.bounds.size.width + 7, -_plusSignActiveView.bounds.size.height + 15, _plusSignActiveView.bounds.size }];
        _plusSignActiveView.hidden = YES;
        [self addSubview:_plusSignActiveView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)setProductOption:(GTIOProductOption *)productOption
{
    _productOption = productOption;
    
    if (_productOption) {
        [_iconView setImageWithURL:_productOption.photo.mainImageURL];
        
        self.maskButton.tapHandler = ^(id sender) {
            self.plusSignActiveView.hidden = YES;
            
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:_productOption.action.endpoint usingBlock:^(RKObjectLoader *loader) {
                loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
                    if ([self.delegate respondsToSelector:@selector(refreshScreenData)]) {
                        [self.delegate refreshScreenData];
                    }
                };
                loader.onDidFailWithError = ^(NSError *error) {
                    NSLog(@"%@", [error localizedDescription]);
                };
            }];
        };
    } else {
        _maskButton.hidden = YES;
        [_iconView setImage:[UIImage imageNamed:@"shopping.bottom.add.png"]];
        [_iconView setFrame:(CGRect){ -2, -2, self.bounds.size.width + 4, self.bounds.size.height + 4 }];
    }
}

@end
