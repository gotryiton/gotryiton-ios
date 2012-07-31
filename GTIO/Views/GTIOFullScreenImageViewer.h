//
//  GTIOFullScreenImageViewer.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/10/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOFullScreenImageViewer : UIView

@property (nonatomic, assign) BOOL useAnimation;

- (id)initWithPhotoURL:(NSURL *)url;
- (void)show;

@end
