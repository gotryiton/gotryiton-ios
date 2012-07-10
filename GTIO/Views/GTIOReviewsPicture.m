//
//  GTIOReviewsPicture.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOReviewsPicture.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface GTIOReviewsPicture()

@property (nonatomic, strong) UIImageView *innerShadow;
@property (nonatomic, strong) GTIOUIButton *invisiButton;

@end

@implementation GTIOReviewsPicture

@synthesize innerShadow = _innerShadow, hasInnerShadow = _hasInnerShadow, invisiButton = _invisiButton, invisiButtonTapHandler = _invisiButtonTapHandler;

- (id)initWithFrame:(CGRect)frame imageURL:(NSURL *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setImageWithURL:url];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.alpha = 0.0;
        
        _innerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviews.top.avatar.overlay.png"]];
        [_innerShadow setFrame:(CGRect){ 0, 0, frame.size }];
        _innerShadow.hidden = YES;
        [self addSubview:_innerShadow];
        
        _invisiButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeMask];
        [_invisiButton setFrame:(CGRect){ 0, 0, frame.size }];
        [self addSubview:_invisiButton];
    }
    return self;
}

- (void)setHasInnerShadow:(BOOL)hasInnerShadow
{
    _hasInnerShadow = hasInnerShadow;
    _innerShadow.hidden = !_hasInnerShadow;
}

- (void)proxySetImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url success:^(UIImage *image) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
        }];
    } failure:^(NSError *error) {
        self.alpha = 1.0;
    }];
}

- (void)setInvisiButtonTapHandler:(GTIOButtonDidTapHandler)invisiButtonTapHandler
{
    _invisiButtonTapHandler = invisiButtonTapHandler;
    self.invisiButton.tapHandler = _invisiButtonTapHandler;
}

@end
