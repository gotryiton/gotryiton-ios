//
//  GTIOPhotoShootProgressToolbarView.m
//  GTIO
//
//  Created by Scott Penrose on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoShootProgressToolbarView.h"

NSInteger const kGTIONumberOfDots = 9;
NSInteger const kGTIODotWidth = 14;
NSInteger const kGTIODotStartOriginX = 40;
NSInteger const kGTIODotSpacer = 7;
NSInteger const kGTIODotGroupSpacer = 29;

@interface GTIOPhotoShootProgressToolbarView ()

@property (nonatomic, strong) NSMutableArray *dotImageViews;

/** Updates all the dot images based on number of dots on
 */
- (void)updateDotImages;

@end

@implementation GTIOPhotoShootProgressToolbarView

@synthesize dotImageViews = _dotImageViews;
@synthesize numberOfDotsOn = _numberOfDotsOn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ frame.origin, { frame.size.width, 53 } }];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ 0, -5, frame.size.width, 58 }];
        [backgroundImageView setImage:[UIImage imageNamed:@"upload.bottom.bar.png"]];
        [self addSubview:backgroundImageView];
        
        UIImageView *timerBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timer-progress-bg.png"]];
        [timerBarImageView setFrame:(CGRect){ { (self.frame.size.width - timerBarImageView.image.size.width) / 2, (self.frame.size.height - timerBarImageView.image.size.height) / 2 }, timerBarImageView.image.size }];
        [self addSubview:timerBarImageView];
        
        _dotImageViews = [NSMutableArray array];
        CGFloat originX = kGTIODotStartOriginX;
        for (int i = 0; i < kGTIONumberOfDots; i++) {
            UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:(CGRect){ originX, (self.frame.size.height - kGTIODotWidth) / 2, kGTIODotWidth, kGTIODotWidth }];
            [_dotImageViews addObject:dotImageView];
            [self addSubview:dotImageView];
            
            originX += kGTIODotWidth + kGTIODotSpacer;
            
            if ((i + 1) % 3 == 0) {
                originX += kGTIODotGroupSpacer;
            }
        }
        
        [self updateDotImages];
    }
    return self;
}

- (void)setNumberOfDotsOn:(NSInteger)numberOfDotsOn
{
    _numberOfDotsOn = numberOfDotsOn;
    [self updateDotImages];
}

- (void)updateDotImages
{
    [self.dotImageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *dotImageView = obj;
        
        if (idx + 1 <= self.numberOfDotsOn) {
            [dotImageView setImage:[UIImage imageNamed:@"timer-progress-dot-ON.png"]];
        } else {
            [dotImageView setImage:[UIImage imageNamed:@"timer-progress-dot-OFF.png"]];
        }
    }];
}

@end
