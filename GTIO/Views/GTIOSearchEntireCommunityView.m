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


@end

@implementation GTIOSearchEntireCommunityView

@synthesize magnifyingGlassImageView = _magnifyingGlassImageView, delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _magnifyingGlassImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.area.start.png"]];
        [self addSubview:_magnifyingGlassImageView];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [self.magnifyingGlassImageView setFrame:(CGRect){ self.bounds.size.width / 2 - self.magnifyingGlassImageView.bounds.size.width / 2, self.frame.size.height /2 - self.magnifyingGlassImageView.bounds.size.height/2, self.magnifyingGlassImageView.bounds.size }];
    
    if ([self.delegate respondsToSelector:@selector(reloadTableData)]) {
        [self.delegate reloadTableData];
    }
}


- (CGFloat)height
{
    return self.magnifyingGlassImageView.frame.origin.y + self.magnifyingGlassImageView.bounds.size.height + 15;
}

@end
