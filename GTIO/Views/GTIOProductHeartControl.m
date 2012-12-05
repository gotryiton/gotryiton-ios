//
//  GTIOProductHeartControl.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/17/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductHeartControl.h"

static CGFloat const kGTIOHeartControlRightPadding = 6.0;
static CGFloat const kGTIOHeartCountTopMargin = 2.0;
static CGFloat const kGTIOAddToShoppingListPopOverXOriginPadding = 0.0;
static CGFloat const kGTIOAddToShoppingListPopOverYOriginPadding = 0.0;

@interface GTIOProductHeartControl()

@property (nonatomic, strong) UIImageView *controlBackground;
@property (nonatomic, strong) UILabel *controlCountLabel;

@property (nonatomic, strong) GTIOUIButton *heartButton;
@property (nonatomic, strong) GTIOUIButton *countButton;

@property (nonatomic, strong) UIImageView *addToShoppingListPopOverView;

@end

@implementation GTIOProductHeartControl

@synthesize heartCount = _heartCount, heartState = _heartState, controlBackground = _controlBackground, controlCountLabel = _controlCountLabel, heartTapHandler = _heartTapHandler, countTapHandler = _countTapHandler, heartButton = _heartButton, countButton = _countButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _controlBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
        _controlBackground.image = [UIImage imageNamed:@"product.heart.inactive.png"];
        _controlBackground.userInteractionEnabled = YES;
        [self addSubview:_controlBackground];
        
        _heartButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeMask];
        __block typeof(self) blockSelf = self;
        _heartButton.touchDownHandler = ^(id sender) { [blockSelf updateHeartImageActive]; };
        _heartButton.touchDragExitHandler = ^(id sender) { [blockSelf updateHeartImageInActive]; };
        [self addSubview:_heartButton];
        
        _controlCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _controlCountLabel.backgroundColor = [UIColor clearColor];
        _controlCountLabel.textColor = [UIColor gtio_grayTextColor585858];
        _controlCountLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBold size:15.0];
        _controlCountLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_controlCountLabel];
        
        // Add To Shopping List Pop Over
        self.addToShoppingListPopOverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hearting-popup.png"]];
    
        _countButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeMask];
        [self addSubview:_countButton];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.controlBackground sizeToFit];
    [self.controlCountLabel setFrame:(CGRect){ self.controlBackground.bounds.size.width / 2, kGTIOHeartCountTopMargin, (self.controlBackground.bounds.size.width / 2) - kGTIOHeartControlRightPadding, self.controlBackground.bounds.size.height - kGTIOHeartCountTopMargin }];
    
    [self.heartButton setFrame:(CGRect){ 0, 0, self.controlBackground.bounds.size.width / 2, self.controlBackground.bounds.size.height }];
    [self.countButton setFrame:(CGRect){ self.controlCountLabel.frame.origin.x, 0, self.heartButton.bounds.size }];

    [self showAddToShoppingListPopOverView];

}

- (void)setHeartCount:(NSNumber *)heartCount
{
    _heartCount = heartCount;
    self.controlCountLabel.text = [NSString stringWithFormat:@"%i", _heartCount.intValue];
}

- (void)setHeartState:(NSNumber *)heartState
{
    _heartState = heartState;
    [self updateHeartImageInActive];
}

- (void)setHeartTapHandler:(GTIOButtonDidTapHandler)heartTapHandler
{
    _heartTapHandler = [heartTapHandler copy];
    self.heartButton.tapHandler = _heartTapHandler;
}

- (void)setCountTapHandler:(GTIOButtonDidTapHandler)countTapHandler
{
    _countTapHandler = [countTapHandler copy];
    self.countButton.tapHandler = _countTapHandler;
}

- (void)updateHeartImageActive
{
    if (_heartState.intValue == 1) {
        self.controlBackground.image = [UIImage imageNamed:@"product.heart.highlight.active.png"];
    }
    if (_heartState.intValue == 0) {
        self.controlBackground.image = [UIImage imageNamed:@"product.heart.active.png"];
    }
}

- (void)updateHeartImageInActive
{
    if (_heartState.intValue == 1) {
        self.controlBackground.image = [UIImage imageNamed:@"product.heart.highlight.png"];
    }
    if (_heartState.intValue == 0) {
        self.controlBackground.image = [UIImage imageNamed:@"product.heart.inactive.png"];
    }
}



- (void)showAddToShoppingListPopOverView
{
    int viewsOfAddToShoppingListPopOverView = [[NSUserDefaults standardUserDefaults] integerForKey:kGTIOAddToShoppingListViewFlag];
    if (viewsOfAddToShoppingListPopOverView < 1) {
        viewsOfAddToShoppingListPopOverView++;
        [[NSUserDefaults standardUserDefaults] setInteger:viewsOfAddToShoppingListPopOverView forKey:kGTIOAddToShoppingListViewFlag];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.addToShoppingListPopOverView setAlpha:1.0f];
        [self.addToShoppingListPopOverView setFrame:(CGRect){ { self.controlBackground.frame.origin.x + self.controlBackground.frame.size.width + kGTIOAddToShoppingListPopOverXOriginPadding, kGTIOAddToShoppingListPopOverYOriginPadding }, self.addToShoppingListPopOverView.image.size }];
        [self addSubview:self.addToShoppingListPopOverView];
        
        [UIView animateWithDuration:1.5f delay:1.75f options:0 animations:^{
            [self.addToShoppingListPopOverView setFrame:CGRectOffset(self.addToShoppingListPopOverView.frame, 24.0f, 0)];
            [self.addToShoppingListPopOverView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.addToShoppingListPopOverView removeFromSuperview];
        }];
    }
}
@end
