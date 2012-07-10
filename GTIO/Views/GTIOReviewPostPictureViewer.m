//
//  GTIOReviewPostPictureViewer.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/10/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOReviewPostPictureViewer.h"
#import "UIImageView+WebCache.h"

@interface GTIOReviewPostPictureViewer()

@property (nonatomic, strong) UIButton *windowMask;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) NSURL *photoURL;

@end

@implementation GTIOReviewPostPictureViewer

@synthesize windowMask = _windowMask, photo = _photo, photoURL = _photoURL;

- (id)initWithPhotoURL:(NSURL *)url
{
    self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    if (self) {
        _windowMask = [UIButton buttonWithType:UIButtonTypeCustom];
        _windowMask.backgroundColor = [UIColor whiteColor];
        _windowMask.alpha = 0.0;
        _windowMask.opaque = YES;
        [_windowMask addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        _photo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_windowMask addSubview:_photo];
        
        _photoURL = url;
    }
    return self;
}

- (void)show
{
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    double statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [self.windowMask setFrame:(CGRect){ 0, statusBarHeight, mainWindow.bounds.size.width, mainWindow.bounds.size.height - statusBarHeight }];
    [mainWindow insertSubview:self.windowMask aboveSubview:mainWindow];
    
    __block typeof(self) blockSelf = self;
    [_photo setImageWithURL:self.photoURL success:^(UIImage *image) {
        if (image.size.width > self.windowMask.bounds.size.width) {
            double imageWidthHeightRatio = image.size.width / image.size.height;
            [self.photo setFrame:(CGRect){ 0, 0, self.windowMask.bounds.size.width, self.windowMask.bounds.size.width / imageWidthHeightRatio }];
        } else {
            [self.photo setFrame:(CGRect){ 0, 0, image.size }];
        }
        [self.photo setCenter:(CGPoint){ self.windowMask.bounds.size.width / 2, self.windowMask.bounds.size.height / 2 }];
    } failure:^(NSError *error) {
        [blockSelf dismiss];
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.windowMask.alpha = 1.0;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.windowMask.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.windowMask removeFromSuperview];
    }];
}

@end
