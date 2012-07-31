//
//  GTIOInviteFriendsSectionHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOInviteFriendsSectionHeaderView.h"

@implementation GTIOInviteFriendsSectionHeaderView

@synthesize titleLabel = _titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *background = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, 320, 29 }];
        background.backgroundColor = [UIColor gtio_toolbarBGColor];
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 10, 4, 300, 20 }];
        _titleLabel.textColor = [UIColor gtio_grayTextColor8F8F8F];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:14.0];
        [background addSubview:_titleLabel];
        UIView *bottomBorder = [[UIView alloc] initWithFrame:(CGRect){ 0, 28, 320, 1 }];
        bottomBorder.backgroundColor = [UIColor gtio_groupedTableBorderColor];
        [background addSubview:bottomBorder];
        [self addSubview:background];
    }
    return self;
}

@end
