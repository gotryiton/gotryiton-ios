//
//  GTIOPhotoShootTimerView.m
//  GTIO
//
//  Created by Scott Penrose on 5/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoShootTimerView.h"

@interface GTIOPhotoShootTimerView ()

@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, strong) NSTimer *updateTimer;

@property (nonatomic, strong) NSDate *startTime;

@end

@implementation GTIOPhotoShootTimerView

@synthesize duration = _duration, startTime = _startTime;
@synthesize animationTimer = _animationTimer, updateTimer = _updateTimer;
@synthesize progress = _progress;
@synthesize completionHandler = _completionHandler;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClearRect(context, rect);
    CGContextSetShouldAntialias(context, YES);
    
    // Outer circle
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, 36, 0, 2 * M_PI, 1);
    CGContextStrokePath(context);
    
    // Progress bar
    CGContextSetStrokeColorWithColor(context, [UIColor gtio_progressBarColor].CGColor);
    CGContextSetLineWidth(context, 6);
    CGFloat startPoint = (1.00000001 - self.progress) * 2 * M_PI - M_PI_2; // 1.00000001 so it doesn't go to full at end
    CGFloat endPoint = 2 * M_PI - M_PI_2; // End at top
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, 30, startPoint, endPoint, 1);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)startWithDuration:(NSTimeInterval)duration completionHandler:(GTIOPhotoShootTimerCompletionHandler)completionHandler;
{
    self.duration = duration;
    self.completionHandler = completionHandler;
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1/30 target:self selector:@selector(update) userInfo:nil repeats:YES];
    self.startTime = [NSDate date];
}

- (void)update
{    
    NSTimeInterval delta = fabs([self.startTime timeIntervalSinceNow]);
    
    if (delta > self.duration) {
        [self.updateTimer invalidate];
        self.progress = 1.0;
        if (self.completionHandler) {
            self.completionHandler(self);
        }
    } else {
        self.progress = delta / self.duration;
    }
    [self setNeedsDisplay];
}

@end
