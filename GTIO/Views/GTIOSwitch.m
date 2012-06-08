//
//  GTIOSwitch.m
//  GTIO
//
//  Created by Scott Penrose on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOSwitch.h"

#import <QuartzCore/QuartzCore.h>

CGFloat const kAnimationDuration = 0.25;

@interface GTIOSwitch ()

@property (nonatomic, strong) UIImageView *trackImageView;
@property (nonatomic, strong) UIImageView *trackFrameImageView;
@property (nonatomic, strong) UIImageView *knobImageView;

- (CGFloat)value;

@end

@implementation GTIOSwitch

@synthesize track = _track, trackFrame = _trackFrame, trackFrameMask = _trackFrameMask, knob = _knob, knobOn = _knobOn, knobOff = _knobOff;
@synthesize trackImageView = _trackImageView, trackFrameImageView = _trackFrameImageView, knobImageView = _knobImageView;
@synthesize on = _on;
@synthesize changeHandler = _changeHandler;
@synthesize knobXOffset = _knobXOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _trackImageView = [[UIImageView alloc] init];
        _trackFrameImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        _knobImageView = [[UIImageView alloc] init];
        [_knobImageView setUserInteractionEnabled:YES];
        
        [self addSubview:_trackImageView];
        [self addSubview:_trackFrameImageView];
        [self addSubview:_knobImageView];
        
        [self bringSubviewToFront:_knobImageView];
        [self setClipsToBounds:YES];
        
        _on = NO;
        _knobXOffset = 0;
        
        UIPanGestureRecognizer *knobPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleKnobPanGesture:)];
        [knobPanGestureRecognizer setMinimumNumberOfTouches:1];
        [_knobImageView addGestureRecognizer:knobPanGestureRecognizer];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)setTrack:(UIImage *)track
{
    _track = track;
    [_trackImageView setImage:_track];
    [_trackImageView setFrame:(CGRect){ CGPointZero, _track.size }];
}

- (void)setTrackFrame:(UIImage *)trackFrame
{
    _trackFrame = trackFrame;
    [_trackFrameImageView setImage:_trackFrame];
}

- (void)setTrackFrameMask:(UIImage *)trackFrameMask
{
    _trackFrameMask = trackFrameMask;
    
    CALayer *trackOffMaskLayer = [CALayer layer];
    trackOffMaskLayer.frame = self.bounds;
    trackOffMaskLayer.contents = (id)[_trackFrameMask CGImage];
    self.layer.mask = trackOffMaskLayer;
}

- (void)setKnob:(UIImage *)knob
{
    _knob = knob;
    [_knobImageView setImage:_knob];
    [_knobImageView setFrame:(CGRect){ { self.knobXOffset, 0 }, _knob.size }];
}

- (void)setKnobXOffset:(NSInteger)knobXOffset
{
    _knobXOffset = knobXOffset;
    [self setKnob:self.knob];
}

- (void)setOn:(BOOL)on
{
    _on = on;
    // animate
    if (on) {
        [self animateToEnd:1.0f];
    } else {
        [self animateToEnd:0.0f];
    }
    
    if (self.changeHandler) {
        self.changeHandler(_on);
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.trackImageView setCenter:self.knobImageView.center];
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
        centerX -= halfOfKnob + self.knobXOffset;
    } else if (centerX > self.frame.size.width / 2) {
        centerX += halfOfKnob + self.knobXOffset;
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
        newKnobXOrigin = (self.knobImageView.frame.size.width / 2) + self.knobXOffset;
    } else { // ON
        newKnobXOrigin = self.frame.size.width - ((self.knobImageView.frame.size.width / 2) + self.knobXOffset);
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.knobImageView setCenter:(CGPoint){ newKnobXOrigin, self.knobImageView.center.y }];
        [self.trackImageView setCenter:(CGPoint){ newKnobXOrigin, self.trackImageView.center.y }];
    }];
}

#pragma mark - GestureRecognizer

- (void)handleKnobPanGesture:(UIPanGestureRecognizer *)gesture
{
    UIView *knobImageView = [gesture view];
    
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:[knobImageView superview]];
        
        // Don't move past start or end
        CGFloat newX = [knobImageView center].x + translation.x;
        if (newX < (knobImageView.frame.size.width / 2) + self.knobXOffset) { // start
            newX = (knobImageView.frame.size.width / 2) + self.knobXOffset;
        } else if (newX > self.frame.size.width - ((knobImageView.frame.size.width / 2) + self.knobXOffset)) { // End
            newX = self.frame.size.width - ((knobImageView.frame.size.width / 2) + self.knobXOffset);
        }
        
        [knobImageView setCenter:CGPointMake(newX, [knobImageView center].y)];
        [self.trackImageView setCenter:(CGPoint){ newX, self.trackImageView.center.y}];
        [gesture setTranslation:CGPointZero inView:[knobImageView superview]];
        [gesture setTranslation:CGPointZero inView:[self.trackImageView superview]];
        
    } else if ([gesture state] == UIGestureRecognizerStateEnded) {        
        if ([self value] <= 0.5f) {
            self.on = NO;
        } else {
            self.on = YES;
        }
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if ([self value] <= 0.5f) {
        self.on = YES;
    } else if ([self value] > 0.5f) {
        self.on = NO;
    }
}

- (void)handleExteriorTapGesture
{
    [self handleTapGesture:nil];
}

@end
