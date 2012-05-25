//
//  GTIOSwitch.m
//  GTIO
//
//  Created by Scott Penrose on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOSwitch.h"

#import <QuartzCore/QuartzCore.h>

NSInteger const kKnobXOffset = -2;
CGFloat const kAnimationDuration = 0.25;

@interface GTIOSwitch ()

@property (nonatomic, strong) UIImageView *trackOnImageView;
@property (nonatomic, strong) UIImageView *trackOffImageView;
@property (nonatomic, strong) UIImageView *knobImageView;

- (CGFloat)value;

@end

@implementation GTIOSwitch

@synthesize trackOn = _trackOn, trackOff = _trackOff, knob = _knob, knobOn = _knobOn, knobOff = _knobOff;
@synthesize trackOnImageView = _trackOnImageView, trackOffImageView = _trackOffImageView, knobImageView = _knobImageView;
@synthesize on = _on;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _trackOnImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        CALayer *trackOnMaskLayer = [CALayer layer];
        trackOnMaskLayer.frame = self.bounds;
        trackOnMaskLayer.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f].CGColor;
        trackOnMaskLayer.contents = (id)[[UIImage imageNamed:@"black_bar.png"]CGImage];
        _trackOnImageView.layer.mask = trackOnMaskLayer;
        
        _trackOffImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        CALayer *trackOffMaskLayer = [CALayer layer];
        trackOffMaskLayer.frame = self.bounds;
        trackOffMaskLayer.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f].CGColor;
        trackOffMaskLayer.contents = (id)[[UIImage imageNamed:@"black_bar.png"]CGImage];
        trackOffMaskLayer.contentsRect = self.bounds;
        _trackOnImageView.layer.mask = trackOffMaskLayer;
        
        
        _knobImageView = [[UIImageView alloc] init];
        [_knobImageView setUserInteractionEnabled:YES];
        
        [self addSubview:_trackOffImageView];
        [self addSubview:_trackOnImageView];
        [self addSubview:_knobImageView];
        
        UIPanGestureRecognizer *knobPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleKnobPanGesture:)];
        [knobPanGestureRecognizer setMinimumNumberOfTouches:1];
        [_knobImageView addGestureRecognizer:knobPanGestureRecognizer];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGestureRecognizer];

        [self bringSubviewToFront:_knobImageView];        
    }
    return self;
}

- (void)setTrackOn:(UIImage *)trackOn
{
    _trackOn = trackOn;
    [_trackOnImageView setImage:_trackOn];
//    [self setNeedsLayout];
}

- (void)setTrackOff:(UIImage *)trackOff
{
    _trackOff = trackOff;
    [_trackOffImageView setImage:_trackOff];
//    [self setNeedsLayout];
}

- (void)setKnob:(UIImage *)knob
{
    _knob = knob;
    [_knobImageView setImage:_knob];
    [_knobImageView setFrame:(CGRect){ { kKnobXOffset, 0 }, _knob.size }];
//    [self setNeedsLayout];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//}

- (void)setOn:(BOOL)on
{
    // handle setting on and off
}

- (CGFloat)value
{
    if (self.frame.size.width == 0) {
        NSLog(@"Can't divide by zero");
        return 0;
    }
    CGFloat halfOfKnob = self.knobImageView.frame.size.width / 2;
    CGFloat centerX = [self.knobImageView center].x;
    if (centerX < self.frame.size.width / 2) {
        centerX -= halfOfKnob + kKnobXOffset;
    } else if (centerX > self.frame.size.width / 2) {
        centerX += halfOfKnob + kKnobXOffset;
    } else {
        return 0.5;
    }
    return centerX / self.frame.size.width;
}

- (void)animateToEnd:(CGFloat)value
{
    CGFloat distanceOfTravel = fabsf(value - [self value]);
    CGFloat animationDuration = kAnimationDuration * distanceOfTravel;
    CGFloat newKnobXOrigin = self.knobImageView.center.x;
    
    if (value <= 0.5) { // OFF
        newKnobXOrigin = (self.knobImageView.frame.size.width / 2) + kKnobXOffset;
    } else { // ON
        newKnobXOrigin = self.frame.size.width - ((self.knobImageView.frame.size.width / 2) + kKnobXOffset);
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.knobImageView setCenter:(CGPoint){ newKnobXOrigin, self.knobImageView.center.y }];
    } completion:^(BOOL finished) {
        // TODO change images here to end ones
    }];
}

- (void)masking:(CGFloat)centerOfKnobXOrigin
{
    [self.trackOffImageView.layer.mask setFrame:(CGRect){ 0, 0, centerOfKnobXOrigin, self.frame.size.height }];
    [self.trackOnImageView.layer.mask setFrame:(CGRect){ centerOfKnobXOrigin, 0, self.frame.size.width - centerOfKnobXOrigin, self.frame.size.height}];
}

#pragma mark - GestureRecognizer

- (void)handleKnobPanGesture:(UIPanGestureRecognizer *)gesture
{
    UIView *knobImageView = [gesture view];
    
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:[knobImageView superview]];
        
        // Don't move past start or end
        CGFloat newX = [knobImageView center].x + translation.x;
        if (newX < (knobImageView.frame.size.width / 2) + kKnobXOffset) { // start
            newX = (knobImageView.frame.size.width / 2) + kKnobXOffset;
        } else if (newX > self.frame.size.width - ((knobImageView.frame.size.width / 2) + kKnobXOffset)) { // End
            newX = self.frame.size.width - ((knobImageView.frame.size.width / 2) + kKnobXOffset);
        }
        
        [knobImageView setCenter:CGPointMake(newX, [knobImageView center].y)];
        [gesture setTranslation:CGPointZero inView:[knobImageView superview]];
        
        [self masking:newX];
        
    } else if ([gesture state] == UIGestureRecognizerStateEnded) {
        [self animateToEnd:[self value]];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    NSLog(@"Tap gesture");
    if ([self value] <= 0.5) {
        [self animateToEnd:1.0f];
    } else if ([self value] > 0.5f) {
        [self animateToEnd:0.0f];
    }
}

@end
