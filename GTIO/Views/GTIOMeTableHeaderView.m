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
        [[GTIOUser currentUser] prepareForManagement];
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
        
        UIView *followingLabel = [self buttonWithText:@"following" frame:(CGRect){ _locationLabel.frame.origin.x, _locationLabel.frame.origin.y + _locationLabel.frame.size.height + 6, 53, 20 } dark:YES tapHandler:^(id sender) {
            NSLog(@"tapped following");
        }];
        [self addSubview:followingLabel];
        UIButton *followingCountLabel = [self buttonWithText:[numberFormatter stringFromNumber:[NSNumber numberWithInt:0]] frame:(CGRect){ followingLabel.frame.origin.x + followingLabel.frame.size.width, followingLabel.frame.origin.y, 30, 20 } dark:NO tapHandler:nil];
        [self addSubview:followingCountLabel];
        
        UIButton *followersLabel = [self buttonWithText:@"followers" frame:(CGRect){ followingCountLabel.frame.origin.x + followingCountLabel.frame.size.width + 8, followingCountLabel.frame.origin.y, 53, 20 } dark:YES tapHandler:^(id sender) {
            NSLog(@"tapped followers");
        }];
        [self addSubview:followersLabel];
        UIView *followerCountLabel = [self buttonWithText:[numberFormatter stringFromNumber:[NSNumber numberWithInt:0]] frame:(CGRect){ followersLabel.frame.origin.x + followersLabel.frame.size.width, followersLabel.frame.origin.y, 30, 20 } dark:NO tapHandler:nil];
        [self addSubview:followerCountLabel];
        
        UIButton *starsLabel = [self buttonWithText:@"" frame:(CGRect){ followerCountLabel.frame.origin.x + followerCountLabel.frame.size.width + 8, followerCountLabel.frame.origin.y, 23, 20 } dark:YES tapHandler:^(id sender) {
            NSLog(@"tapped stars");
        }];
        [self addSubview:starsLabel];
        UIImageView *star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.top.buttons.icon.star.png"]];
        [star setCenter:starsLabel.center];
        [self addSubview:star];
        UIView *starCountLabel = [self buttonWithText:[numberFormatter stringFromNumber:[NSNumber numberWithInt:0]] frame:(CGRect){ starsLabel.frame.origin.x + starsLabel.frame.size.width, starsLabel.frame.origin.y, 23, 20 } dark:NO tapHandler:nil];
        [self addSubview:starCountLabel];
        
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
    [[GTIOUser currentUser] prepareForManagement];
    GTIOUser *currentUser = [GTIOUser currentUser];
    [self.profileIcon setImageWithURL:currentUser.icon];
    [self.nameLabel setText:currentUser.name];
    [self.locationLabel setText:currentUser.location];
}

- (GTIOButton *)buttonWithText:(NSString *)text frame:(CGRect)frame dark:(BOOL)dark tapHandler:(GTIOButtonDidTapHandler)tapHandler
{
    GTIOButton *labelBackground = [self buttonBackgroundWithFrame:frame dark:dark tapHandler:tapHandler];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setFont:(dark) ? [UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:11.0] : [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:11.0]];
    [label setTextColor:(dark) ? [UIColor gtio_lightGrayTextColor] : [UIColor gtio_lightestGrayTextColor]];
    [label setText:text];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label sizeToFit];
    [label setFrame:(CGRect){ 0, 0, labelBackground.frame.size.width - 6, label.frame.size.height }];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setCenter:(CGPoint){ labelBackground.frame.size.width / 2, (frame.size.height / 2) + ((dark) ? 2 : 1) }];
    [labelBackground addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [labelBackground addSubview:label];
    if (!tapHandler) {
        [labelBackground setUserInteractionEnabled:NO];
    }
    return labelBackground;
}

- (GTIOButton *)buttonBackgroundWithFrame:(CGRect)frame dark:(BOOL)dark tapHandler:(GTIOButtonDidTapHandler)tapHandler
{
    GTIOButton *background = [[GTIOButton alloc] initWithFrame:frame];
    background.tapHandler = tapHandler;
    [background setBackgroundImage:[[UIImage imageNamed:(dark) ? @"inner.shadow.bg.png" : @"inner.shadow.bg.lighter.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
    return background;
}

- (void)buttonTapped:(id)sender
{
    GTIOButton *button = (GTIOButton *)sender;
    if (button.tapHandler) {
        button.tapHandler(button);
    }
}

@end
