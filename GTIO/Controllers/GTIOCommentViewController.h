//
//  GTIOCommentViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/10/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"

@protocol GTIOAutoCompleteViewDelegate <NSObject>

@required
- (void)textViewDidSubmit;
- (void)textInputIsEmpty:(BOOL)empty;
@end

@interface GTIOCommentViewController : GTIOViewController <GTIOAutoCompleteViewDelegate>

@property (nonatomic, retain) GTIOUIButton *saveButton;

- (id)initWithPostID:(NSString *)postID;
- (void)textViewDidSubmit;
- (void)textInputIsEmpty;

@end
