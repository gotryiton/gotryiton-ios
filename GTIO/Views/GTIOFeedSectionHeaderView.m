//
//  GTIOFeedSectionHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/15/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFeedSectionHeaderView.h"
#import "GTIOSelectableProfilePicture.h"

#import <QuartzCore/QuartzCore.h>

@interface GTIOFeedSectionHeaderView()

@property (nonatomic, strong) GTIOSelectableProfilePicture *profilePicture;
@property (nonatomic, strong) UIView *profileBox;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *dateStampLabel;
@property (nonatomic, strong) UIImageView *accentLine;

@end

@implementation GTIOFeedSectionHeaderView

@synthesize profilePicture = _profilePicture, profileBox = _profileBox, nameLabel = _nameLabel, locationLabel = _locationLabel, dateStampLabel = _dateStampLabel, accentLine = _accentLine;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
        _profilePicture = [[GTIOSelectableProfilePicture alloc] initWithFrame:CGRectZero];
        [self addSubview:_profilePicture];
        _profileBox = [[UIView alloc] initWithFrame:CGRectZero];
        [_profileBox setBackgroundColor:[UIColor whiteColor]];
        [_profileBox setAlpha:0.50];
        [_profileBox.layer setCornerRadius:2.0f];
        [self addSubview:_profileBox];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.profilePicture setFrame:(CGRect){ 7, 8, 42, 42 }];
    [self.profileBox setFrame:(CGRect){ self.profilePicture.frame.origin.x + self.profilePicture.bounds.size.width + 7, 125, self.profilePicture.bounds.size.height }];
}

@end
