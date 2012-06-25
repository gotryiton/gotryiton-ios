//
//  GTIOFeedCell.h
//  GTIO
//
//  Created by Scott Penrose on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPost.h"

@interface GTIOFeedCell : UITableViewCell

@property (nonatomic, strong) GTIOPost *post;

+ (CGFloat)cellHeightWithPost:(GTIOPost *)post;

@end
