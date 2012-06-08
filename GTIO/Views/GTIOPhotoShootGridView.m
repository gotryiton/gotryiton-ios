//
//  GTIOPhotoShootGridView.m
//  GTIO
//
//  Created by Scott Penrose on 5/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoShootGridView.h"

static NSInteger const kGTIONumberOfPhotos = 9;
static CGFloat const kGTIOXOriginStart = 14.0f;
static CGFloat const kGTIOYOriginStart = 17.0f;
static CGFloat const kGTIOHorizontalPhotoPadding = 20.5f;
static CGFloat const kGTIOVerticalPhotoPadding = 23.0f;
static NSInteger const kGTIOStartingPhotoTag = 1000;

@interface GTIOPhotoShootGridView ()

@end

@implementation GTIOPhotoShootGridView

@synthesize images = _images;
@synthesize imageSelectedHandler = _imageSelectedHandler;

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {        
        UIImageView *gridImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload.photoreel.bg.png"]];
        [gridImageView setFrame:(CGRect){ { 10, 14 }, gridImageView.image.size }];
        [self addSubview:gridImageView];
        
        _images = images;
        
        if ([_images count] >= kGTIONumberOfPhotos) {
            CGFloat xOrigin = kGTIOXOriginStart;
            CGFloat yOrigin = kGTIOYOriginStart;
            
            for (int i = 0; i < kGTIONumberOfPhotos; i++) {
                UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [imageButton setFrame:(CGRect){ xOrigin, yOrigin, 84, 112 }];
                [imageButton setImage:[_images objectAtIndex:i] forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(photoSelected:) forControlEvents:UIControlEventTouchUpInside];
                [imageButton setTag:kGTIOStartingPhotoTag + i];
                [self addSubview:imageButton];
                
                if ((i + 1) % 3 == 0) { // New line
                    xOrigin = kGTIOXOriginStart;
                    yOrigin = kGTIOYOriginStart + ((i + 1) / 3) * imageButton.frame.size.height +  ((i + 1) / 3) * kGTIOVerticalPhotoPadding;
                } else { // next column
                    xOrigin += imageButton.frame.size.width + kGTIOHorizontalPhotoPadding;
                }
            }
        } else {
            NSLog(@"Not enough photos");
        }
    }
    return self;
}

- (void)photoSelected:(id)sender
{
    NSInteger tag = [sender tag] - kGTIOStartingPhotoTag;

    if (tag >= 0 && self.imageSelectedHandler) {
        self.imageSelectedHandler(tag);
    }
}

@end
