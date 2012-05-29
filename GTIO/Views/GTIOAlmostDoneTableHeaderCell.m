//
//  GTIOAlmostDoneTableHeaderCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAlmostDoneTableHeaderCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface GTIOAlmostDoneTableHeaderCell()

@property (nonatomic, strong) UIImageView *profilePicture;

@end

@implementation GTIOAlmostDoneTableHeaderCell

@synthesize profilePicture = _profilePicture;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.layer.shadowColor = [[UIColor grayColor] CGColor];
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOpacity = 0.5f;
        CGRect shadowFrame = (CGRect){ 14, 80, self.layer.bounds.size.width - 28, 5 };
        CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
        self.layer.shadowPath = shadowPath;
        [self.layer setOpaque:YES];
        
        _profilePicture = [[UIImageView alloc] initWithFrame:(CGRect){ 22, 15, 59, 59 }];
        [_profilePicture setBackgroundColor:[UIColor clearColor]];
        [_profilePicture.layer setBorderColor:[UIColor gtio_profilePictureBorderColor].CGColor];
        [_profilePicture.layer setBorderWidth:2.0f];
        [_profilePicture.layer setCornerRadius:5.0f];
        [_profilePicture.layer setOpaque:YES];
        [_profilePicture.layer setMasksToBounds:YES];
        [self addSubview:_profilePicture];
        
        UILabel *editProfilePictureTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [editProfilePictureTitle setText:@"edit profile picture?"];
        [editProfilePictureTitle setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:14.0]];
        [editProfilePictureTitle setTextColor:[UIColor gtio_darkGrayTextColor]];
        [editProfilePictureTitle sizeToFit];
        [editProfilePictureTitle setFrame:(CGRect){ _profilePicture.frame.origin.x + _profilePicture.frame.size.width + 10, _profilePicture.frame.origin.y + (_profilePicture.frame.size.height / 2 - editProfilePictureTitle.frame.size.height / 2), editProfilePictureTitle.frame.size}];
        [self addSubview:editProfilePictureTitle];
        
        UIImageView *chevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general.chevron.png"]];
        [chevron setFrame:(CGRect){ self.frame.size.width - chevron.frame.size.width - 18, editProfilePictureTitle.frame.origin.y + 2, chevron.frame.size }];
        [chevron setAlpha:0.70];
        [self addSubview:chevron];
    }
    return self;
}

- (void)setProfilePictureWithURL:(NSURL *)profilePicture
{
    [_profilePicture setImageWithURL:profilePicture];
}

@end
