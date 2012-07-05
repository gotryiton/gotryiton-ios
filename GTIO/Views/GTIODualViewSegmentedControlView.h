//
//  GTIODualViewSegmentedControlView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOUser.h"
#import "GTIOPostMasonryView.h"

@interface GTIODualViewSegmentedControlView : UIView

@property (nonatomic, strong) GTIOPostMasonryView *leftPostsView;
@property (nonatomic, strong) GTIOPostMasonryView *rightPostsView;

- (id)initWithFrame:(CGRect)frame leftControlTitle:(NSString *)leftControlTitle leftControlPostsType:(GTIOPostType)leftControlPostsType rightControlTitle:(NSString *)rightControlTitle rightControlPostsType:(GTIOPostType)rightControlPostsType;
- (void)setPosts:(NSArray *)posts GTIOPostType:(GTIOPostType)postType user:(GTIOUser *)user;

@end
