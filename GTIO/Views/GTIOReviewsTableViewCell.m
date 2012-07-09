//
//  GTIOReviewsTableViewCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOReviewsTableViewCell.h"
#import "GTIOSelectableProfilePicture.h"
#import "GTIOUser.h"

static const double cellPaddingLeftRight = 12.0;
static const double cellPaddingTop = 12.0;
static const double cellPaddingBottom = 15.0;
static const double avatarWidthHeight = 27.0;

@interface GTIOReviewsTableViewCell()

@property (nonatomic, strong) UIImageView *background;

@property (nonatomic, strong) GTIOSelectableProfilePicture *userProfilePicture;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *postedAtLabel;

@end

@implementation GTIOReviewsTableViewCell

@synthesize background = _background, userProfilePicture = _userProfilePicture, userNameLabel = _userNameLabel, postedAtLabel = _postedAtLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _background = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"reviews.cell.bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 5.0, 7.0, 5.0)]];
        _background.opaque = YES;
        self.backgroundView = _background;
        
        _userProfilePicture = [[GTIOSelectableProfilePicture alloc] initWithFrame:CGRectZero andImageURL:[NSURL URLWithString:@"http://www.onlocationvacations.com/wp-content/uploads/2011/02/breaking-bad.jpg"]];
        [self.contentView addSubview:_userProfilePicture];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11.0];
        _userNameLabel.textColor = [UIColor gtio_pinkTextColor];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.text = @"Walter White";
        [self addSubview:_userNameLabel];
        
        _postedAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postedAtLabel.textColor = [UIColor gtio_grayTextColorBCBCBC];
        _postedAtLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:8.0];
        _postedAtLabel.backgroundColor = [UIColor clearColor];
        _postedAtLabel.text = @"5 HOURS AGO";
        [self addSubview:_postedAtLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.background setFrame:(CGRect){ 3, 0, self.bounds.size.width - 6, self.bounds.size.height - 5 }];
    [self.userProfilePicture setFrame:(CGRect){ self.background.frame.origin.x + cellPaddingLeftRight, self.background.frame.origin.y + self.background.bounds.size.height - avatarWidthHeight - cellPaddingBottom, avatarWidthHeight, avatarWidthHeight }];
    [self.userNameLabel setFrame:(CGRect){ self.userProfilePicture.frame.origin.x + self.userProfilePicture.bounds.size.width + 5, self.userProfilePicture.frame.origin.y, self.background.bounds.size.width - cellPaddingLeftRight * 2 - 5 - self.userProfilePicture.bounds.size.width, 15 }];
    [self.postedAtLabel setFrame:(CGRect){ self.userNameLabel.frame.origin.x, self.userNameLabel.frame.origin.y + self.userNameLabel.bounds.size.height - 2, self.userNameLabel.bounds.size.width, 15 }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    return;
}

@end
