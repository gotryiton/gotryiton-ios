//
//  GTIOTagsSearchBoxView.m
//  GTIO
//
//  Created by Scott Penrose on 7/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTagsSearchBoxView.h"

#import "TTTAttributedLabel.h"
#import "NSString+GTIOAdditions.h"

static CGFloat const kGTIOSearchBarOriginX = 7.0f;

@implementation GTIOTagsSearchBoxView

@synthesize searchBar = _searchBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"search.area.background.shadow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)]];
        [backgroundImageView setFrame:self.bounds];
        [self addSubview:backgroundImageView];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:(CGRect){ { 0, kGTIOSearchBarOriginX }, { self.frame.size.width, 31 } }];
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.field.background.png"] forState:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"search.field.mag.icon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setPositionAdjustment:UIOffsetMake(0.0, -1.0) forSearchBarIcon:UISearchBarIconSearch];
        [_searchBar setPlaceholder:@"search brands or hashtags"];
        [self addSubview:_searchBar];
        
        // remove search bar default background / set custom font
        for (UIView *view in _searchBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
            }
            if ([view isKindOfClass:NSClassFromString(@"UITextField")]) {
                UITextField *textField = (UITextField *)view;
                [textField setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:14.0]];
                [textField setTextColor:[UIColor gtio_grayTextColor8F8F8F]];
            }
        }
    }
    return self;
}

@end
