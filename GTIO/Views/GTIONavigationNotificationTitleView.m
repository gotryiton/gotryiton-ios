//
//  GTIOMeTitleView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIONavigationNotificationTitleView.h"

#import "GTIONavigationTitleView.h"

@interface GTIONavigationNotificationTitleView()

@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) NSNumber *notificationCount;

@end

@implementation GTIONavigationNotificationTitleView

@synthesize bubbleImageView = _bubbleImageView, notificationCount = _notificationCount;
@synthesize tapHandler = _tapHandler;

- (id)initWithNotifcationCount:(NSNumber *)notificationCount tapHandler:(GTIONavTitleTapHandler)tapHandler
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.notificationCount = notificationCount;
        self.tapHandler = tapHandler;
        
        _bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav.counter.inactive.png"]];
        
        UIImageView *gtioTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav.logo.png"]];
        [gtioTextImageView setFrame:(CGRect){ { _bubbleImageView.image.size.width + 1, 0 }, gtioTextImageView.image.size }];
        [self addSubview:gtioTextImageView];
        
        [_bubbleImageView setFrame:(CGRect){ { gtioTextImageView.frame.origin.x + gtioTextImageView.bounds.size.width + 1, -5 }, _bubbleImageView.image.size }];
        [self addSubview:_bubbleImageView];
        
        [self updateBubbleImage:NO];
        
        UILabel *notificationCountLabel = [[UILabel alloc] initWithFrame:(CGRect){ 5, 7, _bubbleImageView.bounds.size.width - 5, 20 }];
        [notificationCountLabel setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBook size:14.0]];
        [notificationCountLabel setTextColor:[UIColor whiteColor]];
        [notificationCountLabel setText:[NSString stringWithFormat:@"%@",(([_notificationCount intValue] > 0) ? [NSString stringWithFormat:@"%i",[_notificationCount intValue]] : @"")]];
        [notificationCountLabel setTextAlignment:UITextAlignmentCenter];
        [notificationCountLabel setBackgroundColor:[UIColor clearColor]];
        [notificationCountLabel setAdjustsFontSizeToFitWidth:YES];
        [_bubbleImageView addSubview:notificationCountLabel];
        
        // Offset left side by notification bubble
        [self setFrame:(CGRect){ CGPointZero, { gtioTextImageView.frame.size.width + (gtioTextImageView.frame.origin.x * 2), gtioTextImageView.frame.size.height } }];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateBubbleImage:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateBubbleImage:NO];
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchLocation) && self.tapHandler) {
        self.tapHandler();
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateBubbleImage:NO];
}

- (void)updateBubbleImage:(BOOL)active
{
    UIImage *bubbleImage = [UIImage imageNamed:[NSString stringWithFormat:@"nav.counter.empty.%@active.png", active ? @"" : @"in"]];
    if ([self.notificationCount intValue] > 0) {
        bubbleImage = [UIImage imageNamed:[NSString stringWithFormat:@"nav.counter.%@active.png", active ? @"" : @"in"]];
    }
    [self.bubbleImageView setImage:bubbleImage];
}

@end
