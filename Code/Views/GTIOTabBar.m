//
//  GTIOTabBar.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOTabBar.h"

@implementation GTIOTab

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        UIColor* gray = RGBCOLOR(71,71,71);
        UIColor* white = [UIColor whiteColor];
        [self setTitleColor:gray forState:UIControlStateNormal];
        [self setTitleColor:white forState:UIControlStateSelected];
        [self setTitleColor:white forState:UIControlStateHighlighted];
        [self setTitleColor:white forState:UIControlStateSelected|UIControlStateHighlighted];
        self.titleLabel.font = kGTIOFetteFontOfSize(18);
        
        UIImage* streachableImage = [[UIImage imageNamed:@"todos-badge.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:12];
        _badgeBackgroundImage = [[[UIImageView alloc] initWithImage:streachableImage] autorelease];
        [self addSubview:_badgeBackgroundImage];
        
        _badgeLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = UITextAlignmentCenter;
        _badgeLabel.font = kGTIOFontBoldHelveticaNeueOfSize(14);
        [self addSubview:_badgeLabel];
    }
    return self;
}

- (NSNumber*)badge {
    return [NSNumber numberWithInt:[_badgeLabel.text intValue]];
}

- (void)setBadge:(NSNumber*)badge {
    if ([badge intValue] > 0) {
        _badgeLabel.text = [NSString stringWithFormat:@"%@", badge];
    } else {
        _badgeLabel.text = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_badgeLabel.text) {
        [_badgeLabel sizeToFit];
        _badgeLabel.frame = CGRectMake(self.bounds.size.width - _badgeLabel.bounds.size.width - 16, -1, _badgeLabel.bounds.size.width, _badgeLabel.bounds.size.height);
        _badgeBackgroundImage.frame = CGRectMake(0,0, 23 + (([_badgeLabel.text length] - 1) * 6), 24);
        _badgeBackgroundImage.center = CGPointMake(_badgeLabel.center.x, _badgeLabel.center.y + 2);
    } else {
        _badgeLabel.frame = CGRectZero;
        _badgeBackgroundImage.frame = CGRectZero;
    }
}

- (void)setRelativePosition:(NSInteger)pos {
    NSString* unselectedImageName;
    NSString* selectedImageName;
    switch (pos) {
        case -1:
            unselectedImageName = @"tabs3-1-off.png";
            selectedImageName = @"tabs3-1-on.png";
            break;
        case 0:
            unselectedImageName = @"tabs3-2-off.png";
            selectedImageName = @"tabs3-2-on.png";
            break;
        default:
            unselectedImageName = @"tabs3-3-off.png";
            selectedImageName = @"tabs3-3-on.png";
            break;
    }
    UIImage* unselectedImage = [[UIImage imageNamed:unselectedImageName] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage* selectedImage = [[UIImage imageNamed:selectedImageName] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [self setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
}

@end

/// ======================================================================================

@implementation GTIOTabBar

@synthesize tabNames = _tabNames;
@synthesize tabs = _tabs;
@synthesize delegate = _delegate;
@synthesize selectedTabIndex = _selectedTabIndex;
@synthesize subtitle = _subtitle;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"todo-tab-bg.png"]];
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.clipsToBounds = YES;
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = [UIColor whiteColor];
        _subtitleLabel.textAlignment = UITextAlignmentCenter;
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_subtitleLabel];
    }
    return self;
}

- (void)dealloc {
    [_tabNames release];
    [_tabs release];
    [_subtitle release];
    [_subtitleLabel release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = CGRectOffset(CGRectInset(self.bounds, 5, 3), 0, 2);
    if (_subtitle) {
        rect = CGRectOffset(CGRectInset(self.bounds, 5, 3+8), 0, 2-8);
    }
    float width = rect.size.width / [_tabs count];
    
    for (int i = 0;i < [_tabs count];i++) {
        GTIOTab* tab = [_tabs objectAtIndex:i];
        tab.frame = CGRectMake(floor(rect.origin.x + width * i), rect.origin.y, floor(width), rect.size.height);
        CGRect titleLabelFrame = tab.titleLabel.frame;
        if (tab.titleLabel.text) {
            tab.titleEdgeInsets = UIEdgeInsetsMake(1,4,1,tab.frame.size.width - titleLabelFrame.size.width - 12+2);
        }
    }
    _subtitleLabel.frame = CGRectZero;
    if (_subtitle) {
        [self addSubview:_subtitleLabel]; // Pop to the top.
        _subtitleLabel.frame = CGRectMake(rect.origin.y, CGRectGetMaxY(rect)-3, rect.size.width, 16);
        _subtitleLabel.text = _subtitle;
    }
}

- (void)setSubtitle:(NSString*)subtitle {
    BOOL hadSubtitle = (_subtitle != nil);
    [subtitle retain];
    [_subtitle release];
    _subtitle = subtitle;
    if (hadSubtitle && !_subtitle) {
        // reduce frame by 16 pixels
        self.frame = CGRectOffset(CGRectInset(self.frame, 0, 8), 0, -8);
    } else if (!hadSubtitle && _subtitle) {
        // increase frame by 16 pixels
        self.frame = CGRectOffset(CGRectInset(self.frame, 0, -8), 0, 8);
    }
}

- (void)tabPressed:(id)sender {
    NSUInteger index = [_tabs indexOfObject:sender];
    if (index == _selectedTabIndex) {
        return;
    }
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

- (GTIOTab*)selectedTab {
    return [_tabs objectAtIndex:_selectedTabIndex];
}

- (void)setTabNames:(NSArray*)names {
    [names retain];
    [_tabNames release];
    _tabNames = names;
    [self removeAllSubviews];
    [_tabs release];
    _tabs = [NSMutableArray new];
    
    for (NSString* name in _tabNames) {
        // create tabs.
        GTIOTab* tab = [[[GTIOTab alloc] initWithFrame:CGRectZero] autorelease];
        [tab setTitle:[name uppercaseString] forState:UIControlStateNormal];
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
