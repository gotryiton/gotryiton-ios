//
//  GTIOMasonGridItemWithFrameView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kGTIOGridItemPhotoPadding = 4.0f;
static CGFloat const kGTIOGridItemPhotoBottomPadding = 5.0f;

@interface GTIOMasonGridItemWithFrameView : UIView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end
