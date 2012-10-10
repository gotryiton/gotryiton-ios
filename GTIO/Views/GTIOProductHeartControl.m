//
//  GTIOProductHeartControl.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/17/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductHeartControl.h"

static CGFloat const kGTIOHeartControlRightPadding = 7.0;
static CGFloat const kGTIOHeartCountTopMargin = 2.0;

@interface GTIOProductHeartControl()

@property (nonatomic, strong) UIImageView *controlBackground;
@property (nonatomic, strong) UILabel *controlCountLabel;

@property (nonatomic, strong) GTIOUIButton *heartButton;
@property (nonatomic, strong) GTIOUIButton *countButton;

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

@end
