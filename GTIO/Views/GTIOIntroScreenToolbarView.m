//
//  GTIOIntroScreenToolbarView.m
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOIntroScreenToolbarView.h"

NSInteger const kGTIOButtonPadding = 6;

@implementation GTIOIntroScreenToolbarView

@synthesize pageControl = _pageControl;
@synthesize signInButton = _signInButton, nextButton = _nextButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:(CGRect){ frame.origin, { frame.size.width, 44 } }];
    if (self) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ CGPointZero, frame.size }];
        [backgroundImageView setImage:[UIImage imageNamed:@"intro-bar-bg.png"]];
        [self addSubview:backgroundImageView];
        
        _signInButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeSignIn];
        [_signInButton setFrame:(CGRect){ { kGTIOButtonPadding, kGTIOButtonPadding } , _signInButton.frame.size }];
        [self addSubview:_signInButton];
        
        _nextButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeNext];
        [_nextButton setFrame:(CGRect){ { self.frame.size.width - _nextButton.frame.size.width - kGTIOButtonPadding, kGTIOButtonPadding } , _nextButton.frame.size }];
        [self addSubview:_nextButton];
        
        CGFloat pageControlPadding = fmaxf(_nextButton.frame.size.width, _signInButton.frame.size.width) + 2 * kGTIOButtonPadding;
        _pageControl = [[GTIOPageControl alloc] initWithFrame:(CGRect){ pageControlPadding, kGTIOButtonPadding, self.frame.size.width - 2 * pageControlPadding, self.frame.size.height - 2 * kGTIOButtonPadding }];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)hideButtons:(BOOL)hidden
{
    [self.signInButton setHidden:hidden];
    [self.nextButton setHidden:hidden];
}

@end
