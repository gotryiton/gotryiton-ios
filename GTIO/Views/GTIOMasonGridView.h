//
//  GTIOMasonGridView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOPost.h"
#import "GTIOMasonGridItem.h"

@interface GTIOMasonGridView : UIScrollView <GTIOMasonGridItemDelegate>

@property (nonatomic, assign) CGFloat topPadding;

- (void)setPosts:(NSArray *)posts postsType:(GTIOPostType)postsType;
- (void)cancelAllItemDownloads;

@end
