//
//  GTIOCommentViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/10/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"

@interface GTIOCommentViewController : GTIOViewController <UITextViewDelegate>

@property (nonatomic, retain) GTIOUIButton *saveButton;

- (id)initWithPostID:(NSString *)postID;


@end
