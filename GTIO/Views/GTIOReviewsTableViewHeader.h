//
//  GTIOReviewsTableViewHeader.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOPost.h"

@interface GTIOReviewsTableViewHeader : UIView

@property (nonatomic, strong) GTIOPost *post;
@property (nonatomic, copy) GTIOButtonDidTapHandler commentButtonTapHandler;
@property (nonatomic, copy) GTIOButtonDidTapHandler postImageTapHandler;

@end
