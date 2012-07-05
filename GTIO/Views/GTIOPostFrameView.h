//
//  GTIOPostFrameView.h
//  GTIO
//
//  Created by Scott Penrose on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPost.h"

@interface GTIOPostFrameView : UIView

@property (nonatomic, strong) GTIOPost *post;
@property (nonatomic, strong) UIImageView *photoImageView;

+ (CGFloat)heightWithPost:(GTIOPost *)post;
+ (CGSize)scalePhotoSize:(CGSize)actualPhotoSize;

@end
