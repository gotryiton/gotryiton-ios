//
//  GTIOFollowRequestAcceptBarView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFollowRequestAcceptBarView.h"
#import "GTIOButton.h"
#import "GTIOUser.h"

@interface GTIOFollowRequestAcceptBarView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GTIOUIButton *acceptButton;
@property (nonatomic, strong) GTIOUIButton *blockButton;

@end

@implementation GTIOFollowRequestAcceptBarView

@synthesize titleLabel = _titleLabel, acceptButton = _acceptButton, blockButton = _blockButton, followRequestAcceptBar = _followRequestAcceptBar, delegate = _delegate;

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
        [self addSubview:_titleLabel];
        
        _acceptButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeAccept];
        [self addSubview:_acceptButton];
        
        _blockButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBlock];
        [self addSubview:_blockButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel setFrame:(CGRect){ 12, 12, 183, 11 }];
    [self.acceptButton setFrame:(CGRect){ 200, 6, 55, 21 }];
    [self.blockButton setFrame:(CGRect){ 261, 6, 55, 21 }];
}

- (void)setFollowRequestAcceptBar:(GTIOFollowRequestAcceptBar *)followRequestAcceptBar
{
    _followRequestAcceptBar = followRequestAcceptBar;
    self.titleLabel.text = self.followRequestAcceptBar.text;
    for (GTIOButton *button in self.followRequestAcceptBar.buttons) {
        if ([button.name isEqualToString:kGTIOUserInfoButtonNameAcceptRelationship]) {
            __block typeof(self) blockSelf = self;
            if ([button.state intValue] == GTIOAcceptRelationshipButtonStateAccept) {
                [self.acceptButton setTitle:button.text forState:UIControlStateNormal];
                [self.acceptButton setTapHandler:^(id sender) {
                    [blockSelf hitEndpointForButton:button];
                }];
            }
            if ([button.state intValue] == GTIOAcceptRelationshipButtonStateBlock) {
                [self.blockButton setTitle:button.text forState:UIControlStateNormal];
                [self.blockButton setTapHandler:^(id sender) {
                    [blockSelf hitEndpointForButton:button];
                }];
            }
        }
    }
}

- (void)hitEndpointForButton:(GTIOButton *)button
{
    if ([self.delegate respondsToSelector:@selector(removeAcceptBar)]) {
        [self.delegate removeAcceptBar];
    }
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:button.action.endpoint usingBlock:nil];
}

@end
