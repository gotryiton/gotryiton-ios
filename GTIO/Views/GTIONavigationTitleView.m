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
@property (nonatomic, strong) UIFont *font;

@end

@implementation GTIONavigationTitleView

@synthesize titleLabel = _titleLabel;
@synthesize italic = _italic, title = _title, font = _font;

- (id)initWithTitle:(NSString*)title italic:(BOOL)italic
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = title;
        _italic = italic;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setTextColor:[UIColor gtio_reallyDarkGrayTextColor]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_titleLabel];
        [self refreshView];
    }
    return self;
}

- (void)refreshView
{
    [self.titleLabel setText:self.title];
    if (!self.font) {
        if (self.italic) {
            [self.titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:16.0]];
        } else {
            [self.titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLight size:16.0]];
        }
    }
    [self.titleLabel sizeToFit];
    // need to shift the label down a bit because of the design
    [self.titleLabel setFrame:(CGRect){ 0, 9, self.titleLabel.bounds.size }];
    [self setFrame:(CGRect){ CGPointZero, { self.titleLabel.frame.size.width, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y } }];
}

- (void)useTitleFont:(UIFont *)font
{
    self.font = font;
    [self.titleLabel setFont:font];
    [self refreshView];
}

#pragma mark - Properties

- (void)setItalic:(BOOL)italic
{
    _italic = italic;
    [self refreshView];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self refreshView];
}

@end
