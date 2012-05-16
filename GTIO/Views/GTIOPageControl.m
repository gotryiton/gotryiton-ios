//
//  GTIOPageControl.m
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOPageControl.h"

@interface GTIOPageControl ()

- (void)commonInit;
- (void)updateDots;

@end

@implementation GTIOPageControl

@synthesize currentDot = _currentDot, normalDot = _normalDot;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.currentDot = [UIImage imageNamed:@"intro-bar-page-ON.png"];
    self.normalDot = [UIImage imageNamed:@"intro-bar-page-OFF.png"];
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void) updateCurrentPageDisplay
{
    [super updateCurrentPageDisplay];
    [self updateDots];
}

/** Override to fix when dots are directly clicked */
- (void) endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event 
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    [self updateDots];
}

- (void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView *dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) {
            dot.image = self.currentDot;
        } else {
            dot.image = self.normalDot;
        }
    }
}

@end
