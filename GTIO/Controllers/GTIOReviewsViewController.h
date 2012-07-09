//
//  GTIOReviewsViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"

@interface GTIOReviewsViewController : GTIOViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithPostID:(NSString *)postID;

@end
