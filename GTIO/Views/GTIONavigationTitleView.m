//
//  GTIONavigationTitleView.m
//  GTIO
//
//  Created by Scott Penrose on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIONavigationTitleView.h"

@interface GTIONavigationTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GTIONavigationTitleView

@synthesize titleLabel = _titleLabel;
@synthesize italic = _italic, title = _title;

- (id)initWithTitle:(NSString*)title italic:(BOOL)italic
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _title = title;
        _italic = italic;
        
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    [self.titleLabel setText:self.title];
    if (self.italic) {
        [self.titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:18.0]];
    } else {
        [self.titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLight size:18.0]];
    }
    
    [self.titleLabel setTextColor:[UIColor gtio_reallyDarkGrayTextColor]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel sizeToFit];
    
    // need to shift the label down a bit because of the design
    [self.titleLabel setFrame:(CGRect){ 0, 9, self.titleLabel.bounds.size }];
    [self setFrame:(CGRect){ CGPointZero, { self.titleLabel.frame.size.width, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y } }];
    
    [self addSubview:self.titleLabel];
}

#pragma mark - Properties

- (void)setItalic:(BOOL)italic
{
    _italic = italic;
    [self setupView];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setupView];
}

@end
