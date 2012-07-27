//
//  GTIOTagsSectionHeader.m
//  GTIO
//
//  Created by Scott Penrose on 7/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTagsSectionHeader.h"

static CGFloat const kGTIOTitleOriginX = 6.0f;
static CGFloat const kGTIOTitleOriginY = 5.0f;

@interface GTIOTagsSectionHeader ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GTIOTagsSectionHeader

@synthesize title = _title;
@synthesize titleLabel = _titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ { kGTIOTitleOriginX, kGTIOTitleOriginY }, { self.frame.size.width - 2 * kGTIOTitleOriginX, 12 } }];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:10.0f]];
        [_titleLabel setTextColor:[UIColor gtio_grayTextColor8F8F8F]];
        [_titleLabel setShadowColor:[UIColor whiteColor]];
        [_titleLabel setShadowOffset:(CGSize){ 0, 1 }];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef greenColor = [UIColor gtio_greenCellColor].CGColor;
    CGColorRef grayBorderColor = [UIColor gtio_grayBorderColorD9D7CE].CGColor;
    
    // Background
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, greenColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
    // Border
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, grayBorderColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, 0 + 0.5, rect.size.height - 0.5);
    CGContextAddLineToPoint(context, rect.size.width + 0.5, rect.size.height - 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    // Text
    CGContextSaveGState(context);
    
    CGContextRestoreGState(context);
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.titleLabel setText:_title];
//    [self setNeedsDisplay];
}

@end
