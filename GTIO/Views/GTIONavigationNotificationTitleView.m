//
//  GTIOMeTitleView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIONavigationNotificationTitleView.h"

#import "GTIONotificationManager.h"

#import "GTIONavigationTitleView.h"

static CGFloat const kGTIONofiticationLabelOriginX = 4.5f;
static CGFloat const kGTIONotificationLabelOriginY = 8.0f;

@interface GTIONavigationNotificationTitleView()

@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UILabel *notificationCountLabel;
@property (nonatomic, assign) NSInteger notificationCount;

@end

@implementation GTIONavigationNotificationTitleView

@synthesize bubbleImageView = _bubbleImageView, notificationCountLabel = _notificationCountLabel;
@synthesize notificationCount = _notificationCount;
@synthesize tapHandler = _tapHandler;

- (id)initWithTapHandler:(GTIONavTitleTapHandler)tapHandler
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.tapHandler = tapHandler;
        
        _notificationCount = [[GTIONotificationManager sharedManager] unreadNotificationCount];
        
        _bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav.counter.inactive.png"]];
        
        UIImageView *gtioTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav.logo.png"]];
        [gtioTextImageView setFrame:(CGRect){ { _bubbleImageView.image.size.width + 1, 0 }, gtioTextImageView.image.size }];
        [self addSubview:gtioTextImageView];
        
        [_bubbleImageView setFrame:(CGRect){ { gtioTextImageView.frame.origin.x + gtioTextImageView.bounds.size.width + 1, -5 }, _bubbleImageView.image.size }];
        [self addSubview:_bubbleImageView];
        
        [self updateBubbleImage:NO];
        
        _notificationCountLabel = [[UILabel alloc] initWithFrame:(CGRect){ kGTIONofiticationLabelOriginX, kGTIONotificationLabelOriginY, _bubbleImageView.bounds.size.width - 5, 20 }];
        [_notificationCountLabel setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBook size:14.0]];
        [_notificationCountLabel setTextColor:[UIColor whiteColor]];
        [_notificationCountLabel setTextAlignment:UITextAlignmentCenter];
        [_notificationCountLabel setBackgroundColor:[UIColor clearColor]];
        [_notificationCountLabel setAdjustsFontSizeToFitWidth:YES];
        [_bubbleImageView addSubview:_notificationCountLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCountUpdated:) name:kGTIONotificationCountNofitication object:nil];
        
        [self updateCountLabel];
        
        // Offset left side by notification bubble
        [self setFrame:(CGRect){ CGPointZero, { gtioTextImageView.frame.size.width + (gtioTextImageView.frame.origin.x * 2), gtioTextImageView.frame.size.height } }];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateCountLabel
{
    [self.notificationCountLabel setText:[NSString stringWithFormat:@"%@",((self.notificationCount > 0) ? [NSString stringWithFormat:@"%i", self.notificationCount] : @"")]];
    [self updateBubbleImage:NO];
}

#pragma mark - UITouch

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

#pragma mark -

- (void)updateBubbleImage:(BOOL)active
{
    UIImage *bubbleImage = [UIImage imageNamed:[NSString stringWithFormat:@"nav.counter.empty.%@active.png", active ? @"" : @"in"]];
    if (self.notificationCount > 0) {
        bubbleImage = [UIImage imageNamed:[NSString stringWithFormat:@"nav.counter.%@active.png", active ? @"" : @"in"]];
    }
    [self.bubbleImageView setImage:bubbleImage];
}

#pragma mark - NSNotification

- (void)notificationCountUpdated:(NSNotification *)notification
{
    self.notificationCount = [[notification.userInfo objectForKey:kGTIONotificationUnreadCountUserInfo] integerValue];
    [self updateCountLabel];
}

@end
