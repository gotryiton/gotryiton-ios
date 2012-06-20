//
//  GTIOWantsToFollowYouView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOWantsToFollowYouView.h"

@interface GTIOWantsToFollowYouView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GTIOButton *acceptButton;
@property (nonatomic, strong) GTIOButton *blockButton;

@end

@implementation GTIOWantsToFollowYouView

@synthesize titleLabel = _titleLabel, acceptButton = _acceptButton, blockButton = _blockButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        [self setBackgroundColor:[UIColor gtio_semiTransparentBackgroundColor]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setText:@"Blair S. wants to follow you!"];
        [self addSubview:_titleLabel];
        
        _acceptButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeAccept];
        [self addSubview:_acceptButton];
        
        _blockButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeBlock];
        [self addSubview:_blockButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.titleLabel setFrame:(CGRect){ 12, 12, 183, 11 }];
    [self.acceptButton setFrame:(CGRect){ 200, 6, 55, 21 }];
    [self.blockButton setFrame:(CGRect){ 261, 6, 55, 21 }];
}

@end
