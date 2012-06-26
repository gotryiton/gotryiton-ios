//
//  GTIOSuggestedFriendsBarButton.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOSuggestedFriendsBarButton.h"
#import "GTIOUser.h"
#import "GTIOSelectableProfilePicture.h"

static double const suggestedFriendsProfilePicturesWidth = 25.0;
static double const suggestedFriendsProfilePicutresSpacing = 6.0;

@interface GTIOSuggestedFriendsBarButton()

@property (nonatomic, strong) UILabel *suggestedFriendsLabel;
@property (nonatomic, strong) UIImageView *chevron;
@property (nonatomic, strong) NSMutableArray *suggestedFriendsProfilePictures;

@end

@implementation GTIOSuggestedFriendsBarButton

@synthesize suggestedFriendsLabel = _suggestedFriendsLabel, chevron = _chevron, suggestedFriends = _suggestedFriends, suggestedFriendsProfilePictures = _suggestedFriendsProfilePictures;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _suggestedFriendsLabel = [[UILabel alloc] initWithFrame:(CGRect){ 9, 17, 110, 20 }];
        _suggestedFriendsLabel.backgroundColor = [UIColor clearColor];
        _suggestedFriendsLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:16.0];
        _suggestedFriendsLabel.text = @"suggested friends";
        _suggestedFriendsLabel.textColor = [UIColor gtio_darkGrayTextColor];
        [self addSubview:_suggestedFriendsLabel];

        _chevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general.chevron.png"]];
        _chevron.alpha = 0.60;
        [self addSubview:_chevron];
        
        _suggestedFriendsProfilePictures = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.chevron setFrame:(CGRect){ self.bounds.size.width - self.chevron.bounds.size.width - 8, self.bounds.size.height / 2 - self.chevron.bounds.size.height / 2, self.chevron.bounds.size }];
    
    double suggestedFriendsProfilePicturesXPosition = self.chevron.frame.origin.x - suggestedFriendsProfilePicturesWidth - 9;
    for (GTIOSelectableProfilePicture *friendProfilePicture in self.suggestedFriendsProfilePictures) {
        [friendProfilePicture setFrame:(CGRect){ suggestedFriendsProfilePicturesXPosition, 12, suggestedFriendsProfilePicturesWidth, suggestedFriendsProfilePicturesWidth }];
        suggestedFriendsProfilePicturesXPosition -= suggestedFriendsProfilePicturesWidth + suggestedFriendsProfilePicutresSpacing;
    }
}

- (void)setSuggestedFriends:(NSArray *)suggestedFriends
{
    _suggestedFriends = suggestedFriends;
    for (GTIOUser *friend in _suggestedFriends) {
        GTIOSelectableProfilePicture *friendProfilePicture = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){ 0, 0, suggestedFriendsProfilePicturesWidth, suggestedFriendsProfilePicturesWidth } andImageURL:friend.icon];
        friendProfilePicture.isSelectable = NO;
        [self addSubview:friendProfilePicture];
        [self.suggestedFriendsProfilePictures addObject:friendProfilePicture];
    }
    [self setNeedsLayout];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = (highlighted) ? [UIColor gtio_findMyFriendsTableCellActiveColor] : [UIColor whiteColor];
}

@end
