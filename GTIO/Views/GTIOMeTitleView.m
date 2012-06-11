//
//  GTIOMeTitleView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMeTitleView.h"

@interface GTIOMeTitleView()

@property (nonatomic, strong) GTIOButton *notificationBubble;
@property (nonatomic, strong) NSNumber *notificationCount;

@end

@implementation GTIOMeTitleView

@synthesize notificationBubble = _notificationBubble, notificationCount = _notificationCount;

- (id)initWithTapHandler:(GTIOButtonDidTapHandler)tapHandler notificationCount:(NSNumber *)notificationCount
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:18.0]];
        [titleLabel setText:@"GO TRY IT ON"];
        [titleLabel setTextColor:[UIColor gtio_reallyDarkGrayTextColor]];
        [titleLabel sizeToFit];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        // need to shift the label down a bit because of the design
        [self setFrame:(CGRect){ 0, 0, titleLabel.bounds.size.width, titleLabel.bounds.size.height + 9 }];
        [titleLabel setFrame:(CGRect){ 0, 9, titleLabel.bounds.size }];
        [self addSubview:titleLabel];
        
        _notificationCount = notificationCount;
        _notificationBubble = ([notificationCount intValue] > 0) ? [GTIOButton buttonWithGTIOType:GTIOButtonTypeNotificationBubble] : [GTIOButton buttonWithGTIOType:GTIOButtonTypeNotificationBubbleEmpty];
        [_notificationBubble setTapHandler:tapHandler];
        UILabel *notificationCountLabel = [[UILabel alloc] initWithFrame:(CGRect){ 6, 0, _notificationBubble.bounds.size.width - 7, _notificationBubble.bounds.size.height + 5 }];
        [notificationCountLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11.0]];
        [notificationCountLabel setTextColor:[UIColor whiteColor]];
        [notificationCountLabel setText:[NSString stringWithFormat:@"%@",(([_notificationCount intValue] > 0) ? [NSString stringWithFormat:@"%i",[_notificationCount intValue]] : @"")]];
        [notificationCountLabel setTextAlignment:UITextAlignmentCenter];
        [notificationCountLabel setBackgroundColor:[UIColor clearColor]];
        [notificationCountLabel setAdjustsFontSizeToFitWidth:YES];
        [_notificationBubble addSubview:notificationCountLabel];
        [_notificationBubble setFrame:(CGRect){ titleLabel.bounds.size.width + 2, 5, _notificationBubble.bounds.size }];
        [self addSubview:_notificationBubble];
        [self setClipsToBounds:NO];      
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ((point.x <= self.bounds.size.width + self.notificationBubble.bounds.size.width && point.x >= 0) &&
        (point.y <= self.bounds.size.height && point.y >= 0)) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

@end
