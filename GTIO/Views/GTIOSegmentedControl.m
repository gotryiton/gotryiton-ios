//
//  GTIOSegmentedControl.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOSegmentedControl.h"

@implementation GTIOSegmentedControl

- (id)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    if (self) {
        self.clipsToBounds = YES;
        [self setBackgroundImage:[UIImage imageNamed:@"profile.tabbar.right.bg.off.png"] 
                        forState:UIControlStateNormal 
                      barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[[UIImage imageNamed:@"profile.tabbar.right.bg.on.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 5.0, 0.0)] 
                        forState:UIControlStateSelected 
                      barMetrics:UIBarMetricsDefault];
        [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor gtio_reallyDarkGrayTextColor], UITextAttributeTextColor,  
                                        [UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:14.0], UITextAttributeFont,
                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                      nil] 
                            forState:UIControlStateNormal];
        [self setDividerImage:[UIImage imageNamed:@"profile.tabbar.left.separator.png"] 
          forLeftSegmentState:UIControlStateSelected 
            rightSegmentState:UIControlStateNormal 
                   barMetrics:UIBarMetricsDefault];
        [self setDividerImage:[UIImage imageNamed:@"profile.tabbar.right.separator.png"] 
          forLeftSegmentState:UIControlStateNormal 
            rightSegmentState:UIControlStateSelected 
                   barMetrics:UIBarMetricsDefault];
    }
    return self;
}

@end
