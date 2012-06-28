//
//  GTIOFriendsNoSearchResultsView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFriendsNoSearchResultsView.h"
#import "TTTAttributedLabel.h"

@interface GTIOFriendsNoSearchResultsView()

@property (nonatomic, strong) UIImageView *sadFaceImageView;
@property (nonatomic, strong) TTTAttributedLabel *couldNotFindLabel;
@property (nonatomic, strong) UILabel *doYouWantLabel;
@property (nonatomic, strong) UIButton *searchCommunityButton;
@property (nonatomic, strong) UIView *searchCommunityUnderline;

@end

@implementation GTIOFriendsNoSearchResultsView

@synthesize failedQuery = _failedQuery, sadFaceImageView = _sadFaceImageView, couldNotFindLabel = _couldNotFindLabel, doYouWantLabel = _doYouWantLabel, searchCommunityButton = _searchCommunityButton, searchCommunityUnderline = _searchCommunityUnderline;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sadFaceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.no.results.empty.sadface.png"]];
        [self addSubview:_sadFaceImageView];
        
        _couldNotFindLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [self styleLabel:_couldNotFindLabel fontSize:16.0];
        [self addSubview:_couldNotFindLabel];
        
        _doYouWantLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self styleLabel:_doYouWantLabel fontSize:14.0];
        _doYouWantLabel.text = @"do you want to try";
        [self addSubview:_doYouWantLabel];
        
        _searchCommunityButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _searchCommunityButton.titleLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:14.0];
        [_searchCommunityButton setTitleColor:[UIColor gtio_linkColor] forState:UIControlStateNormal];
        [_searchCommunityButton setTitle:@"searching the community?" forState:UIControlStateNormal];
        [_searchCommunityButton addTarget:self action:@selector(searchCommunityButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_searchCommunityButton];
        
        _searchCommunityUnderline = [[UIView alloc] initWithFrame:CGRectZero];
        _searchCommunityUnderline.backgroundColor = [UIColor gtio_linkColor];
        _searchCommunityUnderline.alpha = 0.50;
        [self addSubview:_searchCommunityUnderline];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.sadFaceImageView setFrame:(CGRect){ self.bounds.size.width / 2 - _sadFaceImageView.bounds.size.width / 2, 46, _sadFaceImageView.bounds.size }];
    [self.couldNotFindLabel setFrame:(CGRect){ 9, self.sadFaceImageView.frame.origin.y + self.sadFaceImageView.bounds.size.height + 41, self.bounds.size.width - 18, 20 }];
    [self.doYouWantLabel setFrame:(CGRect){ 9, self.couldNotFindLabel.frame.origin.y + self.couldNotFindLabel.bounds.size.height + 15, self.bounds.size.width - 18, 20 }];
    [self.searchCommunityButton setFrame:(CGRect){ 9, self.doYouWantLabel.frame.origin.y + self.doYouWantLabel.bounds.size.height - 3, self.bounds.size.width - 18, 20 }];
    [self.searchCommunityUnderline setFrame:(CGRect){ self.searchCommunityButton.frame.origin.x + self.searchCommunityButton.titleLabel.frame.origin.x, self.searchCommunityButton.frame.origin.y + self.searchCommunityButton.bounds.size.height - 3, self.searchCommunityButton.titleLabel.bounds.size.width, 0.50 }];
}

- (void)setFailedQuery:(NSString *)failedQuery
{
    _failedQuery = failedQuery;
    [self.couldNotFindLabel setText:[NSString stringWithFormat:@"couldn't find %@", failedQuery] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange boldRange = [[mutableAttributedString string] rangeOfString:failedQuery options:NSCaseInsensitiveSearch];
        UIFont *boldSystemFont = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:16.0];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
}

- (void)styleLabel:(UILabel *)label fontSize:(CGFloat)size
{
    label.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:size];
    label.textColor = [UIColor gtio_grayTextColor];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
}

- (CGFloat)height
{
    return self.searchCommunityUnderline.frame.origin.y + self.searchCommunityUnderline.bounds.size.height + 15;
}

- (void)searchCommunityButtonTapped:(id)sender
{
    NSLog(@"go to screen 6.4");
}

@end
