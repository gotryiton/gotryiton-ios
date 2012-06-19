//
//  GTIOMeTableHeaderViewLabel.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMeTableHeaderViewLabel.h"

@interface GTIOMeTableHeaderViewLabel()

@property (nonatomic, strong) UIImageView *shadowyBackground;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *star;

@end

@implementation GTIOMeTableHeaderViewLabel

@synthesize shadowyBackground = _shadowyBackground, textLabel = _textLabel, text = _text, usesLightColors = _usesLightColors, star = _star, usesStar = _usesStar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        
        _shadowyBackground = [[UIImageView alloc] init];
        [self addSubview:_shadowyBackground];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_textLabel setTextAlignment:UITextAlignmentCenter];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setAdjustsFontSizeToFitWidth:YES];
        [_shadowyBackground addSubview:_textLabel];
        
        _usesStar = NO;
        _star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.top.buttons.icon.star.png"]];
        [_star setFrame:CGRectZero];
        [_shadowyBackground addSubview:_star];
        
        _usesLightColors = NO;
        [self adjustColors];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.shadowyBackground setFrame:(CGRect){ 0, 0, self.bounds.size }];
    if (self.usesStar) {
        [self.star sizeToFit];
        [self.star setCenter:(CGPoint){ self.bounds.size.width / 2, self.bounds.size.height / 2 }];
        [self.textLabel setFrame:CGRectZero];
    } else {
        [self.star setFrame:CGRectZero];
        if (self.usesLightColors) {
            [self.textLabel setFrame:(CGRect){ 1.0, 0, self.bounds.size.width - 4.0, self.bounds.size.height }];
        } else {
            [self.textLabel setFrame:(CGRect){ 2.0, 1.0, self.bounds.size.width - 4.0, self.bounds.size.height }];
        }
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self.textLabel setText:self.text];
    [self setNeedsLayout];
}

- (void)setUsesLightColors:(BOOL)usesLightColors
{
    _usesLightColors = usesLightColors;
    [self adjustColors];
}

- (void)adjustColors
{
    if (self.usesLightColors) {
        [self.textLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:11.0]];
        [self.textLabel setTextColor:[UIColor gtio_lightestGrayTextColor]];
        [self.shadowyBackground setImage:[[UIImage imageNamed:@"profile.top.buttons.bg.right.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)]];
    } else {
        [self.textLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:11.0]];
        [self.textLabel setTextColor:[UIColor gtio_lightGrayTextColor]];
        [self.shadowyBackground setImage:[[UIImage imageNamed:@"profile.top.buttons.bg.left.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)]];
    }
}

@end
