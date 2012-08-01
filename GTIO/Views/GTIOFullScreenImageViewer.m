//
//  GTIOFullScreenImageViewer.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/10/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFullScreenImageViewer.h"
#import "UIImageView+WebCache.h"

@interface GTIOFullScreenImageViewer()

@property (nonatomic, strong) UIView *windowMask;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) NSURL *photoURL;

@end

@implementation GTIOFullScreenImageViewer


- (id)initWithPhotoURL:(NSURL *)url
{
    self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    if (self) {
        _windowMask = [[UIView alloc] initWithFrame:CGRectZero];
        _windowMask.backgroundColor = [UIColor whiteColor];
        _windowMask.alpha = 0.0;
        _windowMask.opaque = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_windowMask addGestureRecognizer:tapGestureRecognizer];
        
        _photo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_windowMask addSubview:_photo];
        
        _photoURL = url;

        self.useAnimation = YES;
    }
    return self;
}

- (void)show 
{
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    double statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [self.windowMask setFrame:(CGRect){ 0, statusBarHeight, mainWindow.bounds.size.width, mainWindow.bounds.size.height - statusBarHeight }];
    [mainWindow insertSubview:self.windowMask aboveSubview:mainWindow];
    NSLog(@"full screen: %@", NSStringFromCGRect(self.windowMask.frame));
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
    _photo.contentMode = UIViewContentModeScaleAspectFit;
    
    if (self.useAnimation){
        [UIView animateWithDuration:0.25 animations:^{
            self.windowMask.alpha = 1.0;
        }];
    } else {
        self.windowMask.alpha = 1.0;
    }
}

- (void)dismiss
{
    if (self.useAnimation){
        [UIView animateWithDuration:0.25 animations:^{
            self.windowMask.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.windowMask removeFromSuperview];
        }];
    } else {
        self.windowMask.alpha = 0.0;
        [self.windowMask removeFromSuperview];
    }
}

@end
