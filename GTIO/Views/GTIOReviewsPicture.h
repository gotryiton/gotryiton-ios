//
//  GTIOReviewsPicture.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOReviewsPicture : UIImageView

@property (nonatomic, assign) BOOL hasInnerShadow;
@property (nonatomic, copy) GTIOButtonDidTapHandler invisibleButtonTapHandler;

- (id)initWithFrame:(CGRect)frame imageURL:(NSURL *)url;
- (void)proxySetImageWithURL:(NSURL *)url;

@end
