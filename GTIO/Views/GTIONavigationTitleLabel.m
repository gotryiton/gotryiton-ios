//
//  GTIONavigationTitleLabel.m
//  GTIO
//
//  Created by Scott Penrose on 5/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIONavigationTitleLabel.h"

@implementation GTIONavigationTitleLabel

- (id)initWithTitle:(NSString *)title
{
    id label = [self initWithFrame:CGRectZero title:title];
    [label sizeToFit];
    return label;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:18.0]];
        [self setText:title];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

@end
