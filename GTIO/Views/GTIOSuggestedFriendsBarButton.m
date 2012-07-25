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
static int const maximumNumberOfSuggestedFriends = 5;

@interface GTIOSuggestedFriendsBarButton()

@property (nonatomic, strong) UILabel *suggestedFriendsLabel;
@property (nonatomic, strong) UIImageView *chevron;
@property (nonatomic, strong) UIImageView *magnifyingGlassIcon;
@property (nonatomic, strong) NSMutableArray *suggestedFriendsProfilePictures;
@property (nonatomic, strong) UIView *bottomBorder;

@end

@implementation GTIOSuggestedFriendsBarButton

@synthesize suggestedFriendsLabel = _suggestedFriendsLabel, chevron = _chevron, suggestedFriends = _suggestedFriends, suggestedFriendsProfilePictures = _suggestedFriendsProfilePictures, barTitle = _barTitle, hasGreenBackgroundColor = _hasGreenBackgroundColor, bottomBorder = _bottomBorder, routingURL = _routingURL, showMagnifyingGlassIcon = _showMagnifyingGlassIcon, magnifyingGlassIcon = _magnifyingGlassIcon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        _suggestedFriendsLabel = [[UILabel alloc] initWithFrame:(CGRect){ 9, 17, 110, 20 }];
        _suggestedFriendsLabel.backgroundColor = [UIColor clearColor];
        _suggestedFriendsLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:16.0];
        _suggestedFriendsLabel.text = @"suggested friends";
        _suggestedFriendsLabel.textColor = [UIColor gtio_grayTextColor9C9C9C];
        [self addSubview:_suggestedFriendsLabel];

        _chevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general.chevron.png"]];
        _chevron.alpha = 0.60;
        [self addSubview:_chevron];
        
        _bottomBorder = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBorder.backgroundColor = [UIColor gtio_groupedTableBorderColor];
        [self addSubview:_bottomBorder];
        
        _magnifyingGlassIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find.friends.item.icon.png"]];
        _magnifyingGlassIcon.hidden = YES;
        [self addSubview:_magnifyingGlassIcon];

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

    if (self.showMagnifyingGlassIcon){        
        [self.magnifyingGlassIcon setFrame:(CGRect){ self.suggestedFriendsLabel.frame.origin.x + [self sizeOfLabelText].width + 10 , self.bounds.size.height / 2 - self.magnifyingGlassIcon.bounds.size.height / 2, self.magnifyingGlassIcon.bounds.size }];
        self.magnifyingGlassIcon.hidden = NO;
    }
    
    [self.bottomBorder setFrame:(CGRect){ 0, self.bounds.size.height - 1, self.bounds.size.width, 1 }];
}

- (void)setSuggestedFriends:(NSArray *)suggestedFriends
{
    _suggestedFriends = suggestedFriends;
    for (GTIOSelectableProfilePicture *suggestedFriendProfilePicture in self.suggestedFriendsProfilePictures) {
        [suggestedFriendProfilePicture removeFromSuperview];
    }
    self.suggestedFriendsProfilePictures = [NSMutableArray array];
    
    [_suggestedFriends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == (maximumNumberOfSuggestedFriends - 1)) {
            *stop = YES;
        }
        GTIOUser *friend = (GTIOUser *)obj;
        GTIOSelectableProfilePicture *friendProfilePicture = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){ 0, 0, suggestedFriendsProfilePicturesWidth, suggestedFriendsProfilePicturesWidth } andImageURL:friend.icon];
        friendProfilePicture.isSelectable = NO;
        [self addSubview:friendProfilePicture];
        [self.suggestedFriendsProfilePictures addObject:friendProfilePicture];
    }];
    [self setNeedsLayout];
}

- (void)setBarTitle:(NSString *)barTitle
{
    _barTitle = barTitle;
    self.suggestedFriendsLabel.text = _barTitle;
}

- (void)setHasGreenBackgroundColor:(BOOL)hasGreenBackgroundColor
{
    _hasGreenBackgroundColor = hasGreenBackgroundColor;
    self.backgroundColor = (_hasGreenBackgroundColor) ? [UIColor gtio_friendsGreenCellColor] : [UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = (highlighted) ? [UIColor gtio_findMyFriendsTableCellActiveColor] : ((self.hasGreenBackgroundColor) ? [UIColor gtio_friendsGreenCellColor] : [UIColor whiteColor]);
}

- (CGSize)sizeOfLabelText{
    return [self.suggestedFriendsLabel.text sizeWithFont:self.suggestedFriendsLabel.font forWidth:400.0f lineBreakMode:UILineBreakModeTailTruncation];
}
@end
