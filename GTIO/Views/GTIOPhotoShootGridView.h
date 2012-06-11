//
//  GTIOPhotoShootGridView.h
//  GTIO
//
//  Created by Scott Penrose on 5/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GTIOImageSelectedHandler)(NSInteger photoIndex);

@interface GTIOPhotoShootGridView : UIView

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) GTIOImageSelectedHandler imageSelectedHandler;

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images;

@end
