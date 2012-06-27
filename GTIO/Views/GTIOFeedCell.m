//
//  GTIOFeedCell.m
//  GTIO
//
//  Created by Scott Penrose on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFeedCell.h"

#import "GTIOPostFrameView.h"

@interface GTIOFeedCell ()

@property (nonatomic, strong) GTIOPostFrameView *frameView;

@end

@implementation GTIOFeedCell

@synthesize post = _post;
@synthesize frameView = _frameView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setClipsToBounds:YES];
        
        // Post Frame View
        _frameView = [[GTIOPostFrameView alloc] initWithFrame:(CGRect){ 3.5, 0, CGSizeZero }];
        [self addSubview:_frameView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setBackgroundColor:[UIColor clearColor]];
//    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
}

#pragma mark - Properties

- (void)setPost:(GTIOPost *)post
{
    if (_post != post) {
        _post = post;
        
        [self.frameView setPost:_post];
    }
}

#pragma mark - Height

+ (CGFloat)cellHeightWithPost:(GTIOPost *)post
{
    CGFloat photoFrameHeight = [GTIOPostFrameView heightWithPost:post];
    return photoFrameHeight;
}

@end
