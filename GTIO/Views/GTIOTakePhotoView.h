//
//  GTIOTakePhotoView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOTakePhotoView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

- (void)setImage:(UIImage *)image;
- (void)setDeleteButtonPosition:(GTIODeleteButtonPosition)position;
- (void)setDeleteButtonHidden:(BOOL)hidden;

@end