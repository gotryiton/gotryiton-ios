//
//  GTIOPostMasonryView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOUserProfile.h"
#import "GTIOPost.h"
#import "GTIOMasonGridView.h"

@interface GTIOPostMasonryView : UIView

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) GTIOUserProfile *userProfile;
@property (nonatomic, assign) GTIOPostType postType;
@property (nonatomic, strong) GTIOMasonGridView *masonGridView;

- (id)initWithGTIOPostType:(GTIOPostType)postType;
- (void)setItems:(NSArray *)items userProfile:(GTIOUserProfile *)userProfile;

@end
