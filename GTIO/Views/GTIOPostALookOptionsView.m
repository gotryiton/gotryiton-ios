//
//  GTIOPostALookOptionsView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostALookOptionsView.h"

@interface GTIOPostALookOptionsView()

@end

@implementation GTIOPostALookOptionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"toggle-containers.png"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:(CGRect){ 0, 0, backgroundImage.size }];
        [backgroundView setImage:backgroundImage];
        [self addSubview:backgroundView];
    }
    return self;
}

@end
