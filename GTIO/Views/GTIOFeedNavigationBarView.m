//
//  GTIONavigationBarView.m
//  GTIO
//
//  Created by Scott Penrose on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFeedNavigationBarView.h"

static CGFloat const kGTIOHorizontalPadding = 6.0f;
static CGFloat const kGTIOVerticalPadding = 7.0f;

@implementation GTIOFeedNavigationBarView

@synthesize friendsButton = _friendsButton, titleView = _titleView, backButton = _backButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green-pattern-nav-bar.png"]];
        [self addSubview:backgroundView];
        
        UIView *topShadow = [[UIView alloc] initWithFrame:(CGRect){ 0, frame.size.height, self.bounds.size.width, 3 }];
        [topShadow setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top-shadow.png"]]];
        [self addSubview:topShadow];
        
        _titleView = [[GTIONavigationNotificationTitleView alloc] initWithNotifcationCount:[NSNumber numberWithInt:10] tapHandler:nil];
        [_titleView setFrame:(CGRect){ { (self.frame.size.width - _titleView.frame.size.width) / 2, (self.frame.size.height - _titleView.frame.size.height) / 2 }, _titleView.frame.size }];
        [self addSubview:_titleView];
        
        _friendsButton = [GTIOUIButton gtio_navBarTopMarginWithText:@"friends" tapHandler:nil];
        [_friendsButton setFrame:(CGRect) { self.frame.size.width - _friendsButton.frame.size.width - kGTIOHorizontalPadding, kGTIOVerticalPadding, _friendsButton.frame.size} ];
        [self addSubview:_friendsButton];
        
        _backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackTopMargin tapHandler:nil];
        [_backButton setFrame:(CGRect) { kGTIOHorizontalPadding, kGTIOVerticalPadding, _backButton.bounds.size } ];
        _backButton.hidden = YES;
        [self addSubview:_backButton];
    }
    return self;
}

@end
