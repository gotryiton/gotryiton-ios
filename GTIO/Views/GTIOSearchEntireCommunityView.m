//
//  GTIOSearchEntireCommunityView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOSearchEntireCommunityView.h"
#import "TTTAttributedLabel.h"

@interface GTIOSearchEntireCommunityView()

@property (nonatomic, strong) UIImageView *magnifyingGlassImageView;
@property (nonatomic, strong) UILabel *searchEntireLabel;
@property (nonatomic, strong) UILabel *gtioCommunityLabel;

@end

@implementation GTIOSearchEntireCommunityView

@synthesize magnifyingGlassImageView = _magnifyingGlassImageView, searchEntireLabel = _searchEntireLabel, gtioCommunityLabel = _gtioCommunityLabel, delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _magnifyingGlassImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find.friends.search.empty.png"]];
        [self addSubview:_magnifyingGlassImageView];
        
        _searchEntireLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _searchEntireLabel.text = @"search through the entire";
        [self styleLabel:_searchEntireLabel fontSize:16.0];
        [self addSubview:_searchEntireLabel];
        
        _gtioCommunityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _gtioCommunityLabel.text = @"Go Try It On community";
        [self styleLabel:_gtioCommunityLabel fontSize:16.0];
        _gtioCommunityLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:16.0];
        [self addSubview:_gtioCommunityLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.magnifyingGlassImageView setFrame:(CGRect){ self.bounds.size.width / 2 - self.magnifyingGlassImageView.bounds.size.width / 2, 64, self.magnifyingGlassImageView.bounds.size }];
    [self.searchEntireLabel setFrame:(CGRect){ 9, self.magnifyingGlassImageView.frame.origin.y + self.magnifyingGlassImageView.bounds.size.height + 16, self.bounds.size.width - 18, 20 }];
    [self.gtioCommunityLabel setFrame:(CGRect){ 9, self.searchEntireLabel.frame.origin.y + self.searchEntireLabel.bounds.size.height, self.bounds.size.width - 18, 20 }];
    
    if ([self.delegate respondsToSelector:@selector(reloadTableData)]) {
        [self.delegate reloadTableData];
    }
}

- (void)styleLabel:(UILabel *)label fontSize:(CGFloat)size
{
    label.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:size];
    label.textColor = [UIColor gtio_grayTextColor8F8F8F];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
}

- (CGFloat)height
{
    return self.gtioCommunityLabel.frame.origin.y + self.gtioCommunityLabel.bounds.size.height + 15;
}

@end
