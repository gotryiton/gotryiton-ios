//
//  GTIOTabBar.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/17/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOTabBar.h"

@interface GTIOTab : UIButton {
}

- (void)setRelativePosition:(NSInteger)pos; // -1 for left, 0 for center, 1 for right;

@end

@implementation GTIOTab

- (void)setRelativePosition:(NSInteger)pos {
    NSString* unselectedImageName;
    NSString* selectedImageName;
    switch (pos) {
        case -1:
            unselectedImageName = @"tabs-recent-off.png";
            selectedImageName = @"tabs-recent-on.png";
            // set images for left tab
            break;
        case 0:
            unselectedImageName = @"tabs-popular-off.png";
            selectedImageName = @"tabs-popular-on.png";
            // set images for right tab
            break;
        default:
            unselectedImageName = @"tabs-search-off.png";
            selectedImageName = @"tabs-search-on.png";
            // set images for center tab
            break;
    }
    UIImage* unselectedImage = [[UIImage imageNamed:unselectedImageName] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage* selectedImage = [[UIImage imageNamed:selectedImageName] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:unselectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
}

@end

@implementation GTIOTabBar

@synthesize tabNames = _tabNames;
@synthesize delegate = _delegate;
@synthesize selectedTabIndex = _selectedTabIndex;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [_tabNames release];
    [_tabs release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = CGRectInset(self.bounds, 5, 5);
    float width = rect.size.width / [_tabs count];
    
    for (int i = 0;i < [_tabs count];i++) {
        GTIOTab* tab = [_tabs objectAtIndex:i];
        tab.frame = CGRectMake(rect.origin.x + width * i, rect.origin.y, width, rect.size.height);
        CGRect titleLabelFrame = tab.titleLabel.frame;
        tab.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,width - titleLabelFrame.size.width - 10);
    }
}

- (void)tabPressed:(id)sender {
    NSUInteger index = [_tabs indexOfObject:sender];
    self.selectedTabIndex = index;
    [_delegate tabBar:self selectedTabAtIndex:index];
}

- (void)setSelectedTabIndex:(NSUInteger)index {
    _selectedTabIndex = index;
    for (GTIOTab* tab in _tabs) {
        [tab setSelected:NO];
    }
    GTIOTab* selectedTab = [_tabs objectAtIndex:_selectedTabIndex];
    [selectedTab setSelected:YES];
}

- (void)setTabNames:(NSArray*)names {
    [names retain];
    [_tabNames release];
    _tabNames = names;
    [_tabs release];
    _tabs = [NSMutableArray new];
    
    for (NSString* name in _tabNames) {
        // create tabs.
        GTIOTab* tab = [[[GTIOTab alloc] initWithFrame:CGRectZero] autorelease];
        [tab setTitle:name forState:UIControlStateNormal];
        [tab addTarget:self action:@selector(tabPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_tabs addObject:tab];
        // Round correct corners.
        int index = [_tabNames indexOfObject:name];
        if (0 == index) {
            [tab setRelativePosition:-1];
        } else if ([_tabNames count] - 1 == index) {
            [tab setRelativePosition:1];
        } else {
            [tab setRelativePosition:0];
        }
        [self addSubview:tab];
    }
    
    GTIOTab* selectedTab = [_tabs objectAtIndex:_selectedTabIndex];
    [selectedTab setSelected:YES];
}

@end
