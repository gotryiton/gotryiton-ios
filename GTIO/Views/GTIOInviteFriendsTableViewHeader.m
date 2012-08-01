//
//  GTIOInviteFriendsTableViewHeader.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOInviteFriendsTableViewHeader.h"

static CGFloat const kGTIOPadding = 7.0;
static CGFloat const kGTIOTitleLableYPosition = 7.0;
static CGFloat const kGTIOSMSButtonVerticalOffset = 3.0;

@interface GTIOInviteFriendsTableViewHeader()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *phoneOptionTopBorder;
@property (nonatomic, strong) UIView *phoneOptionBackground;
@property (nonatomic, strong) UIView *phoneOptionBottomBorder;
@property (nonatomic, strong) UILabel *phoneOptionLabel;

@end

@implementation GTIOInviteFriendsTableViewHeader


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"dark.overlay.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 7.0, 7.0, 7.0, 7.0 }]];
        [_backgroundImageView setFrame:(CGRect){ 0, 0, frame.size.width, 70 }];
        [self addSubview:_backgroundImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ kGTIOPadding, kGTIOTitleLableYPosition, frame.size.width - kGTIOPadding * 2, 20 }];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBook size:14.0];
        _titleLabel.text = @"send an invitation via...";
        [self addSubview:_titleLabel];
        
        _smsButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeInviteFriendsSMS];
        [_smsButton setFrame:(CGRect){ kGTIOPadding, _titleLabel.frame.origin.y + _titleLabel.bounds.size.height + kGTIOSMSButtonVerticalOffset, _smsButton.bounds.size }];
        [self addSubview:_smsButton];
        
        _emailButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeInviteFriendsEmail];
        [_emailButton setFrame:(CGRect){ _smsButton.frame.origin.x + _smsButton.bounds.size.width + kGTIOPadding, _smsButton.frame.origin.y, _emailButton.bounds.size }];
        [self addSubview:_emailButton];
        
        _twitterButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeInviteFriendsTwitter];
        [_twitterButton setFrame:(CGRect){ _emailButton.frame.origin.x + _emailButton.bounds.size.width + kGTIOPadding, _emailButton.frame.origin.y, _twitterButton.bounds.size }];
        [self addSubview:_twitterButton];
        
        _phoneOptionTopBorder = [[UIView alloc] initWithFrame:(CGRect){ 0, _backgroundImageView.frame.origin.y + _backgroundImageView.bounds.size.height, frame.size.width, 1 }];
        _phoneOptionTopBorder.backgroundColor = [UIColor whiteColor];
        [self addSubview:_phoneOptionTopBorder];
        
        _phoneOptionBackground = [[UIView alloc] initWithFrame:(CGRect){ 0, _phoneOptionTopBorder.frame.origin.y + _phoneOptionTopBorder.bounds.size.height, frame.size.width, 28 }];
        _phoneOptionBackground.backgroundColor = [UIColor gtio_greenCellColor];
        [self addSubview:_phoneOptionBackground];
        
        _phoneOptionLabel = [[UILabel alloc] initWithFrame:(CGRect){ kGTIOPadding, 5, frame.size.width - kGTIOPadding * 2, 20 }];
        _phoneOptionLabel.backgroundColor = [UIColor clearColor];
        _phoneOptionLabel.textColor = [UIColor gtio_grayTextColor8F8F8F];
        _phoneOptionLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:14.0];
        _phoneOptionLabel.shadowColor = [UIColor whiteColor];
        _phoneOptionLabel.shadowOffset = (CGSize){ 0, 1 };
        _phoneOptionLabel.text = @"...or choose a phone contact";
        [_phoneOptionBackground addSubview:_phoneOptionLabel];
        
        _phoneOptionBottomBorder = [[UIView alloc] initWithFrame:(CGRect){ 0, _phoneOptionBackground.frame.origin.y + _phoneOptionBackground.bounds.size.height, frame.size.width, 1 }];
        _phoneOptionBottomBorder.backgroundColor = [UIColor gtio_groupedTableBorderColor];
        [self addSubview:_phoneOptionBottomBorder];
    }
    return self;
}

@end
