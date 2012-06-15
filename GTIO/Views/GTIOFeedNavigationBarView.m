//
//  GTIOFeedNavigationBarView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/15/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFeedNavigationBarView.h"

@interface GTIOFeedNavigationBarView()

@property (nonatomic, strong) UIImageView *navigationBar;

@end

@implementation GTIOFeedNavigationBarView

@synthesize navigationBar = _navigationBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _navigationBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav.bar.bg.png"]];
    }
    return self;
}

@end
