//
//  GTIOMeTableHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMeTableHeaderView.h"
#import "GTIOUser.h"
#import "UIImageView+WebCache.h"
#import "GTIOSelectableProfilePicture.h"
#import <QuartzCore/QuartzCore.h>
#import "GTIOEditProfilePictureViewController.h"
#import "GTIOMeTableHeaderViewLabel.h"

@interface GTIOMeTableHeaderView()

@property (nonatomic, strong) GTIOSelectableProfilePicture *profileIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation GTIOMeTableHeaderView

@synthesize profileIcon = _profileIcon, nameLabel = _nameLabel, locationLabel = _locationLabel;

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        GTIOUser *currentUser = [GTIOUser currentUser];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"profile.top.bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:10.0]];
        [backgroundImageView setFrame:(CGRect){ 0, 0, frame.size }];
        [self addSubview:backgroundImageView];
        
        _profileIcon = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){ 8, 8, 55, 55 } andImageURL:currentUser.icon];
        [_profileIcon setIsSelectable:NO];
        [self addSubview:_profileIcon];
        
        GTIOButton *profileIconButton = [[GTIOButton alloc] initWithFrame:_profileIcon.frame];
        [profileIconButton setTapHandler:^(id sender) {
            if ([_delegate respondsToSelector:@selector(pushEditProfilePictureViewController)]) {
                [_delegate pushEditProfilePictureViewController];
            }
        }];
        [profileIconButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:profileIconButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:(CGRect){ _profileIcon.frame.origin.x + _profileIcon.frame.size.width + 7, _profileIcon.frame.origin.y, 224, 21 }];
        [_nameLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:16.0]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel setText:currentUser.name];
        [self addSubview:_nameLabel];
        
        _locationLabel = [[UILabel alloc] initWithFrame:(CGRect){ _nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height - 5, 224, 13 }];
        [_locationLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0]];
        [_locationLabel setTextColor:[UIColor gtio_lightGrayTextColor]];
        [_locationLabel setText:[currentUser.location uppercaseString]];
        [_locationLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_locationLabel];
        
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        // following / followers / stars labels

        GTIOMeTableHeaderViewLabel *followingLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:(CGRect){ _locationLabel.frame.origin.x, _locationLabel.frame.origin.y + _locationLabel.frame.size.height + 6, 53, 20 }];
        [followingLabel setText:@"following"];
        [self addSubview:followingLabel];
        
        GTIOMeTableHeaderViewLabel *followingCountLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:(CGRect){ followingLabel.frame.origin.x + followingLabel.frame.size.width, followingLabel.frame.origin.y, 30, 20 }];
        [followingCountLabel setUsesLightColors:YES];
        [followingCountLabel setText:[NSString stringWithFormat:@"%i", [[NSNumber numberWithInt:0] intValue]]];
        [self addSubview:followingCountLabel];
        
        GTIOMeTableHeaderViewLabel *followersLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:(CGRect){ followingCountLabel.frame.origin.x + followingCountLabel.frame.size.width + 8, followingCountLabel.frame.origin.y, 53, 20 }];
        [followersLabel setText:@"followers"];
        [self addSubview:followersLabel];
        
        GTIOMeTableHeaderViewLabel *followerCountLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:(CGRect){ followersLabel.frame.origin.x + followersLabel.frame.size.width, followersLabel.frame.origin.y, 30, 20 }];
        [followerCountLabel setUsesLightColors:YES];
        [followerCountLabel setText:[NSString stringWithFormat:@"%i", [[NSNumber numberWithInt:0] intValue]]];
        [self addSubview:followerCountLabel];
        
        GTIOMeTableHeaderViewLabel *starsLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:(CGRect){ followerCountLabel.frame.origin.x + followerCountLabel.frame.size.width + 8, followerCountLabel.frame.origin.y, 23, 20 }];
        [starsLabel setUsesStar:YES];
        [self addSubview:starsLabel];
        
        GTIOMeTableHeaderViewLabel *starCountLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:(CGRect){ starsLabel.frame.origin.x + starsLabel.frame.size.width, starsLabel.frame.origin.y, 23, 20 }];
        [starCountLabel setUsesLightColors:YES];
        [starCountLabel setText:[NSString stringWithFormat:@"%i", [[NSNumber numberWithInt:0] intValue]]];
        [self addSubview:starCountLabel];
        
        // following / followers / stars buttons
        
        GTIOButton *followingButton = [[GTIOButton alloc] initWithFrame:(CGRect){ followingLabel.frame.origin, followingLabel.bounds.size.width + followingCountLabel.bounds.size.width, followingLabel.bounds.size.height }];
        followingButton.tapHandler = ^(id sender) {
            NSLog(@"tapped following");
        };
        [followingButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:followingButton];
        
        GTIOButton *followersButton = [[GTIOButton alloc] initWithFrame:(CGRect){ followersLabel.frame.origin, followersLabel.bounds.size.width + followerCountLabel.bounds.size.width, followersLabel.bounds.size.height }];
        followersButton.tapHandler = ^(id sender) {
            NSLog(@"tapped followers");
        };
        [followersButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:followersButton];
        
        GTIOButton *starButton = [[GTIOButton alloc] initWithFrame:(CGRect){ starsLabel.frame.origin, starsLabel.bounds.size.width + starCountLabel.bounds.size.width, starsLabel.bounds.size.height }];
        starButton.tapHandler = ^(id sender) {
            NSLog(@"tapped stars");
        };
        [starButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:starButton];
        
        UIImage *editPencil = [UIImage imageNamed:@"profile.top.icon.edit.png"];
        GTIOButton *editButton = [[GTIOButton alloc] initWithFrame:(CGRect){ self.bounds.size.width - editPencil.size.width, 3, editPencil.size }];
        [editButton setImage:editPencil forState:UIControlStateNormal];
        [editButton setTapHandler:^(id sender) {
            if ([_delegate respondsToSelector:@selector(pushEditProfileViewController)]) {
                [_delegate pushEditProfileViewController];
            }
        }];
        [editButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:editButton];
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
}

- (void)refreshData
{
    GTIOUser *currentUser = [GTIOUser currentUser];
    [self.profileIcon setImageWithURL:currentUser.icon];
    [self.nameLabel setText:currentUser.name];
    [self.locationLabel setText:currentUser.location];
}

- (void)buttonTapped:(id)sender
{
    GTIOButton *button = (GTIOButton *)sender;
    if (button.tapHandler) {
        button.tapHandler(button);
    }
}

@end
