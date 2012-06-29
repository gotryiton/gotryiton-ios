//
//  GTIOFindMyFriendsSearchBoxView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFindMyFriendsSearchBoxView.h"
#import "TTTAttributedLabel.h"
#import "NSString+GTIOAdditions.h"

@interface GTIOFindMyFriendsSearchBoxView()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) TTTAttributedLabel *followingFriendsLabel;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) BOOL shouldDisplayFollowers;

@end

@implementation GTIOFindMyFriendsSearchBoxView

@synthesize backgroundImageView = _backgroundImageView, followingFriendsLabel = _followingFriendsLabel, searchBar = _searchBar, searchBarDelegate = _searchBarDelegate, showFollowingLabel = _showFollowingLabel, searchBarPlaceholder = _searchBarPlaceholder, shouldDisplayFollowers = _shouldDisplayFollowers, subTitleText = _subTitleText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        _backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"search.area.background.shadow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)]];
        [self addSubview:_backgroundImageView];
        
        _followingFriendsLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _followingFriendsLabel.backgroundColor = [UIColor clearColor];
        _followingFriendsLabel.textColor = [UIColor gtio_grayTextColor];
        _followingFriendsLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:10.0];
        _followingFriendsLabel.shadowColor = [UIColor whiteColor];
        _followingFriendsLabel.shadowOffset = (CGSize){ 0, 1 };
        _followingFriendsLabel.shadowRadius = 1.0f;
        [self addSubview:_followingFriendsLabel];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.field.background.png"] forState:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"search.field.mag.icon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setPositionAdjustment:UIOffsetMake(0.0, -1.0) forSearchBarIcon:UISearchBarIconSearch];
        [_searchBar setPlaceholder:@"search through friends I follow"];
        // remove search bar default background / set custom font
        for (UIView *view in _searchBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
            }
            if ([view isKindOfClass:NSClassFromString(@"UITextField")]) {
                UITextField *textField = (UITextField *)view;
                [textField setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:14.0]];
                [textField setTextColor:[UIColor gtio_grayTextColor]];
            }
        }

        [self addSubview:_searchBar];
        _showFollowingLabel = YES;
        _shouldDisplayFollowers = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [self.backgroundImageView setFrame:(CGRect){ 0, 0, self.bounds.size }];
    [self.followingFriendsLabel setFrame:(CGRect){ 9, 6, self.bounds.size.width - 16, (self.showFollowingLabel) ? 15 : 0 }];
    [self.searchBar setFrame:(CGRect){ 0, self.followingFriendsLabel.frame.origin.y + self.followingFriendsLabel.bounds.size.height + 7, self.bounds.size.width, 31 }];
}

- (void)setSubTitleText:(NSString *)subTitleText
{
    _subTitleText = [subTitleText uppercaseString];
    __block typeof(_subTitleText) blockSubTitleText = _subTitleText;
    [_followingFriendsLabel setText:blockSubTitleText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSArray *boldRanges = [blockSubTitleText rangesOfHTMLBoldedText];
        for (NSValue *value in boldRanges) {
            NSRange boldRange = [value rangeValue];
            UIFont *boldSystemFont = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:10.0];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                CFRelease(font);
            }
        }
        // remove HTML bold tags
        for (NSValue *value in boldRanges) {
            [mutableAttributedString deleteCharactersInRange:[[mutableAttributedString string] rangeOfString:@"<B>"]];
            [mutableAttributedString deleteCharactersInRange:[[mutableAttributedString string] rangeOfString:@"</B>"]];
        }
        return mutableAttributedString;
    }];
}

- (void)setSearchBarPlaceholder:(NSString *)searchBarPlaceholder
{
    _searchBarPlaceholder = searchBarPlaceholder;
    [self.searchBar setPlaceholder:_searchBarPlaceholder];
}

- (void)setSearchBarDelegate:(id<UISearchBarDelegate>)searchBarDelegate
{
    _searchBarDelegate = searchBarDelegate;
    [self.searchBar setDelegate:_searchBarDelegate];
}

- (void)setShowFollowingLabel:(BOOL)showFollowingLabel
{
    _showFollowingLabel = showFollowingLabel;
    [self setNeedsLayout];
}


@end
