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

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GTIORoundedView

@synthesize title = _title;
@synthesize titleLabel = _titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setBorderColor:[UIColor gtio_groupedTableBorderColor].CGColor];
        [self.layer setBorderWidth:1.0f];
        [self.layer setCornerRadius:10.0f];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 19, 18, 260, 20 }];
        [_titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:17.0]];
        [_titleLabel setTextColor:[UIColor gtio_pinkTextColor]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [_titleLabel setText:self.title];
}

@end
