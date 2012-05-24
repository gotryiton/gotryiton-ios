//
//  GTIOPhotoToolbarView.m
//  GTIO
//
//  Created by Scott Penrose on 5/23/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoToolbarView.h"

@implementation GTIOPhotoToolbarView

@synthesize closeButton = _closeButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ frame.origin, { frame.size.width, 53 } }];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ 0, -5, frame.size.width, 58 }];
        [backgroundImageView setImage:[[UIImage imageNamed:@"upload.bottom.bar.bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
        [self addSubview:backgroundImageView];
        
    }
    return self;
}

@end
