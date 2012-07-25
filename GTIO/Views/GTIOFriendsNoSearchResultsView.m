//
//  GTIOFriendsNoSearchResultsView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFriendsNoSearchResultsView.h"
#import "TTTAttributedLabel.h"
#import "GTIOFriendsViewController.h"

@interface GTIOFriendsNoSearchResultsView()

@property (nonatomic, strong) UIImageView *sadFaceImageView;


@end

@implementation GTIOFriendsNoSearchResultsView

@synthesize sadFaceImageView = _sadFaceImageView, delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sadFaceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.area.no.results.png"]];
        [self addSubview:_sadFaceImageView];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [self.sadFaceImageView setFrame:(CGRect){ self.bounds.size.width / 2 - _sadFaceImageView.bounds.size.width / 2, 137, _sadFaceImageView.bounds.size }];
    
    if ([self.delegate respondsToSelector:@selector(reloadTableData)]) {
        [self.delegate reloadTableData];
    }
}

- (CGFloat)height
{
    return self.sadFaceImageView.frame.origin.y + self.sadFaceImageView.bounds.size.height + 15;
}

// rt

@end
