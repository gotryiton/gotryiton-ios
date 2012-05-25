//
//  GTIORoundedView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIORoundedView.h"
#import <QuartzCore/QuartzCore.h>

@interface GTIORoundedView()
{
    @private
    UILabel *titleLabel;
}

@end

@implementation GTIORoundedView

@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setBorderColor:[UIColor gtio_lightGrayBorderColor].CGColor];
        [self.layer setBorderWidth:1.0f];
        [self.layer setCornerRadius:10.0f];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        titleLabel = [[UILabel alloc] initWithFrame:(CGRect){19,18,260,20}];
        [titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLight size:17.0]];
        [titleLabel setTextColor:[UIColor gtio_pinkTextColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [titleLabel setText:self.title];
}

@end
