//
//  GTIOPhotoShootGridView.m
//  GTIO
//
//  Created by Scott Penrose on 5/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoShootGridView.h"

NSInteger const kGTIONumberOfPhotos = 9;
CGFloat const kGTIOXOriginStart = 16.0f;
CGFloat const kGTIOYOriginStart = 15.0f;
CGFloat const kGTIOHorizontalPhotoPadding = 20.0f;
CGFloat const kGTIOVerticalPhotoPadding = 23.0f;

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
        [gridImageView setFrame:(CGRect){ { 12, 12 }, gridImageView.image.size }];
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
    UIImage *image = [sender imageForState:UIControlStateNormal];

    if (self.imageSelectedHandler) {
        self.imageSelectedHandler(image);
    }
}

@end
