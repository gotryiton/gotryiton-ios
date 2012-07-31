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

static CGFloat kGTIOMaskButtonXPosition = -5.0;
static CGFloat kGTIOMaskButtonYPosition = -5.0;
static CGFloat kGTIOPlusSignActiveHorizontalOffset = 7.0;
static CGFloat kGTIOPlusSignActiveVerticalOffset = 15.0;
static CGFloat kGTIOIconViewXPosition = -2.0;
static CGFloat kGTIOIconViewYPosition = -2.0;

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
        [_maskButton setFrame:(CGRect){ kGTIOMaskButtonXPosition, kGTIOMaskButtonYPosition, self.bounds.size.width - kGTIOMaskButtonXPosition * 2, self.bounds.size.height - kGTIOMaskButtonYPosition * 2 }];
        _maskButton.touchDownHandler = ^(id sender) {
            self.plusSignActiveView.hidden = NO;
        };
        _maskButton.touchDragExitHandler = ^(id sender) {
            self.plusSignActiveView.hidden = YES;
        };
        [self addSubview:_maskButton];
        
        _plusSignActiveView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopping.bottom.plus.active.png"]];
        [_plusSignActiveView setFrame:(CGRect){ self.bounds.size.width - _plusSignActiveView.bounds.size.width + kGTIOPlusSignActiveHorizontalOffset, -_plusSignActiveView.bounds.size.height + kGTIOPlusSignActiveVerticalOffset, _plusSignActiveView.bounds.size }];
        _plusSignActiveView.hidden = YES;
        [self addSubview:_plusSignActiveView];
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}

- (void)setProductOption:(GTIOProductOption *)productOption
{
    _productOption = productOption;
    
    if (_productOption) {
        [_iconView setImageWithURL:_productOption.photo.smallSquareThumbnailURL];
        
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
        [_iconView setFrame:(CGRect){ kGTIOIconViewXPosition, kGTIOIconViewYPosition, self.bounds.size.width - kGTIOIconViewXPosition * 2, self.bounds.size.height - kGTIOIconViewYPosition * 2 }];
    }
}

@end
