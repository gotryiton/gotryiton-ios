//
//  GTIOPostMasonryEmptyStateView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostMasonryEmptyStateView.h"

@interface GTIOPostMasonryEmptyStateView()

@property (nonatomic, strong) TTTAttributedLabel *titleLabel;
@property (nonatomic, assign) BOOL displayLock;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UIImageView *titleBackground;

@end

@implementation GTIOPostMasonryEmptyStateView

@synthesize titleLabel = _titleLabel, displayLock = _displayLock, userName = _userName, lockImageView = _lockImageView, titleBackground = _titleBackground;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title userName:(NSString *)userName locked:(BOOL)locked
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleBackground = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"empty.message.container.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0]];
        [_titleBackground setFrame:CGRectZero];
        [self addSubview:_titleBackground];
        
        _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:14.0]];
        [_titleLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
        [_titleLabel setLineHeightMultiple:0.70];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:UILineBreakModeWordWrap];
        [_titleLabel setTextAlignment:UITextAlignmentCenter];
        [_titleLabel setText:title afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            if (userName.length > 0) {
                NSRange pinkRange = [[mutableAttributedString string] rangeOfString:userName options:NSCaseInsensitiveSearch];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor gtio_linkColor].CGColor range:pinkRange];
            }
            return mutableAttributedString;
        }];
        [_titleBackground addSubview:_titleLabel];
        
        _lockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-lock.png"]];
        [_lockImageView setFrame:CGRectZero];
        [self addSubview:_lockImageView];
        
        _displayLock = locked;
        
        [self layoutSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    double lockPadding = 0.0;
    if (self.displayLock) {
        [self.lockImageView sizeToFit];
        lockPadding = 15.0;
    } else {
        [self.lockImageView setFrame:CGRectZero];
    }
    [self.titleBackground sizeToFit];
    [self.titleBackground setFrame:(CGRect){ 0, self.lockImageView.bounds.size.height + lockPadding, self.titleBackground.bounds.size.width, self.titleBackground.bounds.size.height + ((self.displayLock) ? 20 : 10) }];
    [self.titleLabel setFrame:(CGRect){ 35, 0, self.titleBackground.bounds.size.width - 70, self.titleBackground.bounds.size.height }];
    [self setFrame:(CGRect){ self.frame.origin, self.titleBackground.bounds.size.width, self.lockImageView.frame.origin.y + self.lockImageView.bounds.size.height + lockPadding + self.titleBackground.bounds.size.height }];
    if (self.displayLock) {
        [self.lockImageView setFrame:(CGRect){ (self.bounds.size.width / 2) - (self.lockImageView.bounds.size.width / 2), 0, self.lockImageView.bounds.size }];
    }
}

@end
