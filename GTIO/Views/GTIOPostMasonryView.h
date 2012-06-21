//
//  GTIOPostMasonryView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOUser.h"

typedef enum GTIOPostType {
    GTIOPostTypeNone = 0,
    GTIOPostTypeHeart,
    GTIOPostTypeStar
} GTIOPostType;

@interface GTIOPostMasonryView : UIScrollView

@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) GTIOUser *user;
@property (nonatomic, assign) GTIOPostType postType;

- (id)initWithGTIOPostType:(GTIOPostType)postType;
- (void)setPosts:(NSArray *)posts user:(GTIOUser *)user;

@end
