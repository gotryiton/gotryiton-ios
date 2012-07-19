//
//  GTIOProductListEmptyStateView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProductListEmptyStateView.h"
#import "TTTAttributedLabel.h"

@interface GTIOProductListEmptyStateView()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) TTTAttributedLabel *titleLabel;
@property (nonatomic, strong) GTIOUIButton *maskButton;

@end

@implementation GTIOProductListEmptyStateView

@synthesize backgroundImageView = _backgroundImageView, titleLabel = _titleLabel, maskButton = _maskButton;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title linkText:(NSString *)linkText linkTapHandler:(GTIOButtonDidTapHandler)tapHandler
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"empty.message.container.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0]];
        [_backgroundImageView setFrame:(CGRect){ 0, 0, frame.size }];
        [self addSubview:_backgroundImageView];
        
        _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:(CGRect){ 10, 7, _backgroundImageView.bounds.size.width - 20, _backgroundImageView.bounds.size.height - 14 }];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:11.0]];
        [_titleLabel setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        [_titleLabel setLineHeightMultiple:1.20];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:UILineBreakModeWordWrap];
        [_titleLabel setTextAlignment:UITextAlignmentCenter];
        [_titleLabel setText:title afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            if (linkText.length > 0) {
                NSRange pinkRange = [[mutableAttributedString string] rangeOfString:linkText options:NSCaseInsensitiveSearch];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor gtio_linkColor].CGColor range:pinkRange];
            }
            return mutableAttributedString;
        }];
        [self addSubview:_titleLabel];
        
        _maskButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeMask];
        [_maskButton setFrame:(CGRect){ 10, 12, 45, 20 }];
        _maskButton.tapHandler = tapHandler;
        [self addSubview:_maskButton];
        
        UIView *underline = [[UIView alloc] initWithFrame:(CGRect){ 17, 26, 32, 0.5 }];
        underline.backgroundColor = [UIColor gtio_linkColor];
        underline.alpha = 0.50;
        [self addSubview:underline];
    }
    return self;
}

@end
