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

@end

@implementation GTIOReviewsPicture

@synthesize innerShadow = _innerShadow;

- (id)initWithFrame:(CGRect)frame imageURL:(NSURL *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImageWithURL:url];
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        _innerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviews.top.avatar.overlay.png"]];
        [_innerShadow setFrame:(CGRect){ 0, 0, frame.size }];
        [self addSubview:_innerShadow];
    }
    return self;
}

@end
