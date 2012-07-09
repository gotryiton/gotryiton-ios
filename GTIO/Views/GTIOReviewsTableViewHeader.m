//
//  GTIOReviewsTableViewHeader.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOReviewsTableViewHeader.h"
#import "GTIOReviewsPicture.h"

@interface GTIOReviewsTableViewHeader()

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) GTIOReviewsPicture *postPicture;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *postedAtLabel;
@property (nonatomic, strong) UIButton *leaveACommentButton;

@end

@implementation GTIOReviewsTableViewHeader

@synthesize background = _background, postPicture = _postPicture, userNameLabel = _userNameLabel, postedAtLabel = _postedAtLabel, leaveACommentButton = _leaveACommentButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviews.top.bg.png"]];
        _background.frame = (CGRect){ 0, 0, frame.size };
        [self addSubview:_background];
        
        _postPicture = [[GTIOReviewsPicture alloc] initWithFrame:(CGRect){ 5, 6, 75, 75 } imageURL:[NSURL URLWithString:@"http://farm4.staticflickr.com/3663/3348176340_8a80fb162f.jpg"]];
        [self addSubview:_postPicture];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:(CGRect){ _postPicture.frame.origin.x + _postPicture.bounds.size.width + 8, _postPicture.frame.origin.y + 4, frame.size.width - _postPicture.frame.origin.x - _postPicture.frame.size.width - 10, 20 }];
        _userNameLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:16.0];
        _userNameLabel.textColor = [UIColor gtio_pinkTextColor];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.text = @"Vanessa Jackman";
        [self addSubview:_userNameLabel];
        
        _postedAtLabel = [[UILabel alloc] initWithFrame:(CGRect){ _userNameLabel.frame.origin.x + 1, _userNameLabel.frame.origin.y + _userNameLabel.bounds.size.height - 6, _userNameLabel.bounds.size.width - 1, 20 }];
        _postedAtLabel.textColor = [UIColor gtio_darkGrayTextColor];
        _postedAtLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0];
        _postedAtLabel.backgroundColor = [UIColor clearColor];
        _postedAtLabel.text = @"2 HOURS AGO";
        [self addSubview:_postedAtLabel];
        
        _leaveACommentButton = [[UIButton alloc] initWithFrame:(CGRect){ _userNameLabel.frame.origin.x - 3, _postedAtLabel.frame.origin.y + _postedAtLabel.bounds.size.height + 2, 230, 35 }];
        [_leaveACommentButton setBackgroundImage:[UIImage imageNamed:@"reviews.top.input.box.png"] forState:UIControlStateNormal];
        [_leaveACommentButton setBackgroundImage:[UIImage imageNamed:@"reviews.top.input.box.png"] forState:UIControlStateHighlighted];
        _leaveACommentButton.titleLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLightItalic size:14.0];
        [_leaveACommentButton setTitleColor:[UIColor gtio_grayTextColorB7B7B7] forState:UIControlStateNormal];
        [_leaveACommentButton setTitleEdgeInsets:(UIEdgeInsets){ -5, -125, 0, 0 }];
        [_leaveACommentButton setTitle:@"leave a comment!" forState:UIControlStateNormal];
        [self addSubview:_leaveACommentButton];
    }
    return self;
}

@end
