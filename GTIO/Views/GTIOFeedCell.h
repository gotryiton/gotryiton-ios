//
//  GTIOFeedCell.h
//  GTIO
//
//  Created by Scott Penrose on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPost.h"
#import "GTIOFeedViewController.h"

@interface GTIOFeedCell : UITableViewCell

@property (nonatomic, strong) GTIOPost *post;
@property (nonatomic, weak) id<GTIOFeedHeaderViewDelegate> delegate;

+ (CGFloat)cellHeightWithPost:(GTIOPost *)post;

@end
