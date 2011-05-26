//
//  GTIOOutfitTableHeaderDragRefreshView.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/18/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOOutfitTableHeaderDragRefreshView.h"

@interface TTTableHeaderDragRefreshView (Overrides)
- (UIImageView*)bgImageView;
@end

@implementation GTIOOutfitTableHeaderDragRefreshView

- (NSString*)backgroundImageName {
    return @"outfit-pull-background.png";
}

- (NSString*)arrowImageName {
    return @"outfit-pull-arrow.png";
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(53,53,53);
        [[self bgImageView] setFrame:CGRectOffset([[self bgImageView] frame], 0, 10)];
        _statusLabel.textColor = RGBCOLOR(197,197,197);
        
        _statusLabel.frame = CGRectMake(0.0f, floor(frame.size.height - 24.0f),
                                        floor(frame.size.width), 20.0f );
        _statusLabel.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}

@end
